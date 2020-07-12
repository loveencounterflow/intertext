(function() {
  'use strict';
  var $, $drain, CND, DATOM, FS, INTERTEXT, LineBreaker, Multimix, PATH, SP, Slabs, alert, assign, badge, cast, debug, help, info, isa, join_path, jr, new_datom, rpr, select, type_of, types, urge, validate, warn, whisper;

  /*

  'Slab': the part of a word that is separated from others by breakpoints

  > The addressable unit of memory on the NCR 315 series is a "slab", short for "syllable", consisting of 12
  > data bits and a parity bit. Its size falls between a byte and a typical word (hence the name, 'syllable').
  > A slab may contain three digits (with at sign, comma, space, ampersand, point, and minus treated as
  > digits) or two alphabetic characters of six bits each.—[Wikipedia, "NCR
  > 315"](https://en.wikipedia.org/wiki/NCR_315)

  */
  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/SLABS';

  debug = CND.get_logger('debug', badge);

  alert = CND.get_logger('alert', badge);

  whisper = CND.get_logger('whisper', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  info = CND.get_logger('info', badge);

  PATH = require('path');

  FS = require('fs');

  ({jr} = CND);

  assign = Object.assign;

  join_path = function(...P) {
    return PATH.resolve(PATH.join(...P));
  };

  //...........................................................................................................
  types = require('./types');

  ({isa, validate, cast, type_of} = types);

  SP = require('steampipes');

  ({$, $drain} = SP.export());

  DATOM = require('datom');

  ({new_datom, select} = DATOM.export());

  INTERTEXT = null;

  LineBreaker = null;

  Multimix = require('multimix');

  Slabs = (function() {
    //===========================================================================================================

    //-----------------------------------------------------------------------------------------------------------
    class Slabs extends Multimix {
      //---------------------------------------------------------------------------------------------------------
      constructor(settings = null) {
        super();
        this.settings = {...this._defaults, ...settings};
        return this;
      }

      //---------------------------------------------------------------------------------------------------------
      _slabs_from_text(text) {
        var R, blunt, end, ends, last_idx, lbo, line_breaker, prv_position, shy, shy_chr, slab, slabs, space, spc_chr;
        /* TAINT why doesn't import in top level work? */
        if (INTERTEXT == null) {
          INTERTEXT = require('..');
        }
        /* TAINT benchmark against https://github.com/hfour/linebreak-ts */
        if (LineBreaker == null) {
          LineBreaker = require('linebreak');
        }
        line_breaker = new LineBreaker(text);
        //.......................................................................................................
        shy_chr = INTERTEXT.HYPH.soft_hyphen_chr;
        spc_chr = '\x20';
        prv_position = 0;
        slabs = [];
        ends = [];
        R = {slabs, ends};
        ({blunt, shy, space} = this.settings.joints);
        //.......................................................................................................
        /* LBO: line break opportunity */
        while ((lbo = line_breaker.nextBreak()) != null) {
          end = blunt;
          slab = text.slice(prv_position, lbo.position);
          prv_position = lbo.position;
          last_idx = slab.length - 1;
          //.....................................................................................................
          switch (slab[last_idx]) {
            case shy_chr:
              [end, slab] = [shy, slab.slice(0, last_idx) + '-'];
              break;
            /* TAINT in the future, we might want to consider other breaking (fixed or variable) spaces */
            case spc_chr:
              [end, slab] = [space, slab.slice(0, last_idx)];
          }
          //.....................................................................................................
          slabs.push(slab);
          ends.push(end);
        }
        //.......................................................................................................
        R.ends = R.ends.join('');
        return R;
      }

      //---------------------------------------------------------------------------------------------------------
      slabjoints_from_text(text) {
        var ends, idx, joints, segments, slab, slabs, version;
        ({slabs, ends} = this._slabs_from_text(text));
        version = this.settings.versions.slabjoints;
        joints = this.settings.joints;
        segments = (function() {
          var i, len, results;
          results = [];
          for (idx = i = 0, len = slabs.length; i < len; idx = ++i) {
            slab = slabs[idx];
            results.push(slab + ends[idx]);
          }
          return results;
        })();
        return {
          segments,
          version,
          joints,
          size: segments.length,
          cursor: 0
        };
      }

      //---------------------------------------------------------------------------------------------------------
      text_and_joint_from_segment(text) {
        /* TAINT should pass in slabjoints object, idx, should not return joint chr but joint type */
        validate.nonempty_text(text);
        return [text.slice(0, text.length - 1), text[text.length - 1]];
      }

      //---------------------------------------------------------------------------------------------------------
      get_line_candidates(slabjoints, metrics) {
        validate.intertext_slabs_slabjoints_v001(slabjoints);
        validate.intertext_slabs_metrics(metrics);
        return this._get_line_candidates(slabjoints, metrics);
      }

      //---------------------------------------------------------------------------------------------------------
      _get_line_candidates(slabjoints, metrics) {
        return validate.intertext_slabs_slabjoints_v001(slabjoints);
      }

      //---------------------------------------------------------------------------------------------------------
      assemble(slabjoints, first_idx = null, last_idx = null) {
        var R, blunt, final, i, idx, ref, ref1, segment, segments, shy, space, text;
        /* TAINT validate indexes? */
        validate.intertext_slabs_slabjoints_v001(slabjoints);
        ({blunt, shy, space} = slabjoints.joints);
        ({segments} = slabjoints);
        if (first_idx == null) {
          first_idx = 0;
        }
        if (last_idx == null) {
          last_idx = segments.length - 1;
        }
        first_idx = Math.max(first_idx, 0);
        last_idx = Math.min(last_idx, segments.length - 1);
        R = '';
//.......................................................................................................
        for (idx = i = ref = first_idx, ref1 = last_idx; i <= ref1; idx = i += +1) {
          segment = segments[idx];
          text = segment.slice(0, segment.length - 1);
          final = segment[segment.length - 1];
          R += text;
          switch (final) {
            case blunt:
              null;
              break;
            case space:
              (idx !== last_idx ? R += '\x20' : void 0);
              break;
            /* TAINT allow to configure hyphen */
            case shy:
              (idx !== last_idx ? R = R.slice(0, R.length - 1) : void 0);
              break;
            default:
              // when shy    then ( if idx is last_idx then R += '-' )
              throw new Error(`^INTERTEXT/SLABS@4352^ unknown slab \`end\` option ${rpr(end)}`);
          }
        }
        //.......................................................................................................
        return R;
      }

    };

    Slabs.prototype._defaults = {
      /* NOTE A joint is a single chr from the Unicode BMP signalling the behavior/status of the right hand
         end of a slab:
         * **blunt**— joint: `#`; nothing (empty string) whether non-final or final
         * **shy**—   joint: `=`; nothing when non-final, add hyphen (U+002d) when final
         * **space**— joint: `°`; space (U+0020) when non-final, nothing (empty string) when final
          */
      joints: {
        blunt: '#',
        shy: '=',
        space: '°'
      },
      versions: {
        slabjoints: '0.0.1'
      }
    };

    return Slabs;

  }).call(this);

  //###########################################################################################################
  module.exports = new Slabs();

  //###########################################################################################################
  if (module === require.main) {
    (() => {})();
  }

}).call(this);

//# sourceMappingURL=slabs.js.map