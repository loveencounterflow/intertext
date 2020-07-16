(function() {
  'use strict';
  var CND, FS, Multimix, PATH, Wrap, alert, assign, badge, cast, debug, help, info, intersperse, isa, join_path, jr, rpr, type_of, types, urge, validate, warn, whisper,
    modulo = function(a, b) { return (+a % (b = +b) + b) % b; };

  /*

  Word wrapping, line justification

  */
  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/WRAP';

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

  // SP                        = require 'steampipes'
  // { $
  //   $drain }                = SP.export()
  // DATOM                     = require 'datom'
  // { new_datom
  //   select }                = DATOM.export()
  // INTERTEXT                 = null
  // LineBreaker               = null
  Multimix = require('multimix');

  //-----------------------------------------------------------------------------------------------------------
  intersperse = function*(list, x) {
    /* thx to https://stackoverflow.com/a/37129036/7568091 */
    var i, is_first, len, value;
    is_first = true;
    for (i = 0, len = list.length; i < len; i++) {
      value = list[i];
      if (!is_first) {
        yield x;
      }
      is_first = false;
      yield value;
    }
    return null;
  };

  Wrap = (function() {
    //===========================================================================================================

    //-----------------------------------------------------------------------------------------------------------
    class Wrap extends Multimix {
      //---------------------------------------------------------------------------------------------------------
      constructor(settings = null) {
        super();
        this.settings = {...this._defaults, ...settings};
        return this;
      }

      //---------------------------------------------------------------------------------------------------------
      justify_monospaced(words, line_width, word_widths = null) {
        var width_of, word;
        validate.list_of('nonempty_text', words);
        if (words.length === 0) {
          throw new Error("^itx/wrap/justify@448^ expected list with at least 1 element, got empty list");
        }
        validate.positive_integer(line_width);
        if (word_widths != null) {
          validate.list_of('positive_integer', word_widths);
          if (word_widths.length !== words.length) {
            throw new Error(`^itx/wrap/justify@334^ length of list word_widths must match length of words list, got list of length ${word_widths.length}`);
          }
        } else {
          ({width_of} = require('to-width'));
          word_widths = (function() {
            var i, len, results;
            results = [];
            for (i = 0, len = words.length; i < len; i++) {
              word = words[i];
              results.push(width_of(word));
            }
            return results;
          })();
        }
        return (this._justify_monospaced(words, line_width, word_widths)).join('');
      }

      //---------------------------------------------------------------------------------------------------------
      _justify_monospaced(words, line_width, word_widths) {
        var R, idx, idxs, j, material_width, word_count;
        if ((word_count = words.length) === 1) {
          return words[0];
        }
        material_width = (word_widths.reduce(((a, x) => {
          return a + x + 1;
        }), 0)) - 1;
        if (material_width > line_width) {
          throw new Error(`^itx/wrap/justify@997^ material width ${material_width} exceeds line width ${line_width}`);
        }
        if (word_count === 2) {
          return [words[0], ' '.repeat(line_width - material_width), words[1]];
        }
        //.......................................................................................................
        R = [...(intersperse(words, ' '))];
        idxs = (function() {
          var i, ref, results;
          results = [];
          for (idx = i = 0, ref = R.length; (0 <= ref ? i < ref : i > ref); idx = 0 <= ref ? ++i : --i) {
            if ((modulo(idx, 2)) === 1) {
              results.push(idx);
            }
          }
          return results;
        })();
        j = -1;
        CND.shuffle(idxs);
        while (true) {
          if (material_width >= line_width) {
            break;
          }
          j = (j + 1) % idxs.length;
          R[idxs[j]] += ' ';
          material_width++;
        }
        //.......................................................................................................
        return R;
      }

    };

    Wrap.prototype._defaults = {};

    return Wrap;

  }).call(this);

  //###########################################################################################################
  module.exports = new Wrap();

  //###########################################################################################################
  if (module === require.main) {
    (() => {})();
  }

}).call(this);

//# sourceMappingURL=wordwrap.js.map