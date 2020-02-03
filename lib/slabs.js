(function() {
  'use strict';
  var $, $drain, CND, DATOM, FS, INTERTEXT, LineBreaker, PATH, SP, alert, assign, badge, cast, debug, help, info, isa, join_path, jr, new_datom, rpr, select, type_of, types, urge, validate, warn, whisper;

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

  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  this.slabs_from_text = function(text) {
    var R, end, ends, last_idx, lbo, line_breaker, prv_position, shy, slab, slabs, spc;
    /* TAINT why doesn't import in top level work? */
    if (INTERTEXT == null) {
      INTERTEXT = require('..');
    }
    /* TAINT benchmark against https://github.com/hfour/linebreak-ts */
    if (LineBreaker == null) {
      LineBreaker = require('linebreak');
    }
    line_breaker = new LineBreaker(text);
    //.........................................................................................................
    shy = INTERTEXT.HYPH.soft_hyphen_chr;
    spc = '\x20';
    prv_position = 0;
    slabs = [];
    ends = [];
    R = {slabs, ends};
    //.........................................................................................................
    /* LBO: line break opportunity */
    while ((lbo = line_breaker.nextBreak()) != null) {
      end = 'x';
      slab = text.slice(prv_position, lbo.position);
      prv_position = lbo.position;
      last_idx = slab.length - 1;
      //.......................................................................................................
      switch (slab[last_idx]) {
        case shy:
          [end, slab] = ['|', slab.slice(0, last_idx)];
          break;
        /* TAINT in the future, we might want to consider other breaking (fixed or variable) spaces */
        case spc:
          [end, slab] = ['_', slab.slice(0, last_idx)];
      }
      //.......................................................................................................
      slabs.push(slab);
      ends.push(end);
    }
    //.........................................................................................................
    R.ends = R.ends.join('');
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.assemble = function(me, first_idx = null, last_idx = null) {
    var R, end, i, idx, ref, ref1;
    /* TAINT validate indexes? */
    if (first_idx == null) {
      first_idx = 0;
    }
    if (last_idx == null) {
      last_idx = me.slabs.length - 1;
    }
    first_idx = Math.max(first_idx, 0);
    last_idx = Math.min(last_idx, me.slabs.length - 1);
    R = '';
//.........................................................................................................
    for (idx = i = ref = first_idx, ref1 = last_idx; i <= ref1; idx = i += +1) {
      R += me.slabs[idx];
      switch (end = me.ends[idx]) {
        case 'x':
          null;
          break;
        case '_':
          (idx !== last_idx ? R += '\x20' : void 0);
          break;
        /* TAINT allow to configure hyphen */
        case '|':
          (idx === last_idx ? R += '-' : void 0);
          break;
        default:
          throw new Error(`^INTERTEXT/SLABS@4352^ unknown slab \`end\` option ${rpr(end)}`);
      }
    }
    //.........................................................................................................
    return R;
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      var html, text;
      // @demo_linebreak()
      // @demo_hyphenation()
      html = `<p><strong>Letterpress</strong> printing is a <em>technique of relief printing using a printing
press,</em> a process by which many copies are produced by <em>repeated direct impression of an inked,
raised surface</em> against sheets or a continuous roll of paper.</p> <p>A worker composes and locks
movable type into the ‘bed’ or ‘chase’ of a press, inks it, and presses paper against it to transfer the
ink from the type which creates an impression on the paper.</p>`;
      text = `Letterpress printing is a technique of relief printing using a printing press.`;
      html = `<p>${text}</p>`;
      // urge @slabs_from_paragraph html
      return urge(this.slabs_from_text(text));
    })();
  }

}).call(this);
