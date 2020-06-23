(function() {
  //!node
  var CND, Multimix, Re, alert, badge, debug, echo, help, info, isa, log, to_width, type_of, types, urge, validate, warn, whisper, width_of;

  CND = require('cnd');

  badge = 'INTERTEXT/RE';

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

  Re = (function() {
    //-----------------------------------------------------------------------------------------------------------
    class Re extends Multimix {
      //---------------------------------------------------------------------------------------------------------
      constructor(settings = null) {
        super();
        this.settings = {...this._defaults, ...settings};
        return this;
      }

      //---------------------------------------------------------------------------------------------------------
      static escape(text) {
        /* Given a `text`, return the same with all regular expression metacharacters properly escaped. Escaped
           characters are `[]{}()*+?-.,\^$|#` plus whitespace. */
        //.......................................................................................................
        return text.replace(/[-[\]{}()*+?.,\\\/^$|#\s]/g, "\\$&");
      }

      //---------------------------------------------------------------------------------------------------------
      static re_from_text(text, flags = null) {
        return new RegExp(this.escape(text), flags != null ? flags : 'g');
      }

    };

    Re.prototype._defaults = {};

    return Re;

  }).call(this);

  //###########################################################################################################
  module.exports = new Re();

  //###########################################################################################################
  if (module === require.main) {
    (() => {})();
  }

}).call(this);

//# sourceMappingURL=re.js.map