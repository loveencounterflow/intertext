(function() {
  //!node
  var CND, Diff, Multimix, alert, badge, debug, echo, help, info, isa, log, to_width, type_of, types, urge, validate, warn, whisper, width_of;

  CND = require('cnd');

  badge = 'INTERTEXT/DIFF';

  log = CND.get_logger('plain', badge);

  info = CND.get_logger('info', badge);

  whisper = CND.get_logger('whisper', badge);

  alert = CND.get_logger('alert', badge);

  debug = CND.get_logger('debug', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  echo = CND.echo.bind(CND);

  //...........................................................................................................
  types = require('./types');

  ({isa, validate, type_of} = types);

  ({to_width, width_of} = require('to-width'));

  Multimix = require('multimix');

  Diff = (function() {
    //-----------------------------------------------------------------------------------------------------------
    class Diff extends Multimix {
      //---------------------------------------------------------------------------------------------------------
      constructor(settings = null) {
        var INTERTEXT;
        super();
        this.settings = {...this._defaults, ...settings};
        this._DMP = require('diff-match-patch');
        this._dmp = new this._DMP.diff_match_patch();
        if (this.settings.tty_columns == null) {
          INTERTEXT = require('..');
          this.settings.tty_columns = (INTERTEXT.get_terminal_size()).columns;
        }
        return this;
      }

      //---------------------------------------------------------------------------------------------------------
      rawdiff(old_text, new_text) {
        var R;
        R = this._dmp.diff_main(old_text, new_text);
        this._dmp.diff_cleanupSemantic(R);
        return R;
      }

      //---------------------------------------------------------------------------------------------------------
      colordiff(old_text, new_text) {
        /* TAINT to be replaced by INTERTEXT.COLORS */
        var INTERTEXT, R, _cnd, colorized, dd, diff, i, len, line, lines, text;
        INTERTEXT = require('..');
        _cnd = require('cnd/lib/TRM-CONSTANTS');
        R = '';
        diff = this.rawdiff(old_text, new_text);
        colorized = ((function() {
          var i, len, results;
          results = [];
          for (i = 0, len = diff.length; i < len; i++) {
            [dd, text] = diff[i];
            results.push(this._colorize(dd, text));
          }
          return results;
        }).call(this)).join('');
        lines = colorized.split('\n');
        for (i = 0, len = lines.length; i < len; i++) {
          line = lines[i];
          line += _cnd.reverse + _cnd.colors.white;
          line = (to_width(line, this.settings.tty_columns)) + '\n';
          R += line;
        }
        return R;
      }

      //---------------------------------------------------------------------------------------------------------
      _colorize(delta_code, text) {
        /* TAINT to be replaced by INTERTEXT.COLORS */
        var color, line, lines;
        lines = text.split('\n');
        color = (function() {
          switch (delta_code) {
            case -1:
              return CND[this.settings.color_old];
            case 0:
              return CND[this.settings.color_same];
            case +1:
              return CND[this.settings.color_new];
          }
        }).call(this);
        return ((function() {
          var i, len, results;
          results = [];
          for (i = 0, len = lines.length; i < len; i++) {
            line = lines[i];
            results.push(CND.reverse(color(line)));
          }
          return results;
        })()).join('\n');
      }

    };

    // @include MAIN, { overwrite: false, }
    // @extend MAIN, { overwrite: false, }
    Diff.prototype._defaults = {
      color_same: 'white',
      color_old: 'orange',
      color_new: 'lime',
      tty_columns: null
    };

    return Diff;

  }).call(this);

  //###########################################################################################################
  module.exports = new Diff();

  //###########################################################################################################
  if (module === require.main) {
    (() => {})();
  }

}).call(this);

//# sourceMappingURL=diff.js.map