(function() {
  'use strict';
  var CND, FS, INTERTEXT, Intertext, MAIN, Multimix, PATH, alert, assign, badge, cast, debug, echo, help, info, isa, jr, log, rpr, type_of, urge, validate, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT';

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
  FS = require('fs');

  PATH = require('path');

  Multimix = require('multimix');

  ({assign, jr} = CND);

  this.types = require('./types');

  ({isa, validate, cast, type_of} = this.types);

  Multimix = require('multimix');

  /*
  #...........................................................................................................
  _format                   = require 'number-format.js'
  format_float              = ( x ) -> _format '#,##0.000', x
  format_integer            = ( x ) -> _format '#,##0.',    x
  format_as_percentage      = ( x ) -> _format '#,##0.00',  x * 100
   */
  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  MAIN = this;

  Intertext = (function() {
    class Intertext extends Multimix {
      // @extend MAIN, { overwrite: false, }

        //---------------------------------------------------------------------------------------------------------
      constructor(target = null) {
        super();
        this.HTML = require('./html');
        if (target != null) {
          this.export(target);
        }
        return this;
      }

    };

    Intertext.include(MAIN, {
      overwrite: false
    });

    Intertext.include(require('./hyphenation'), {
      overwrite: false
    });

    return Intertext;

  }).call(this);

  module.exports = INTERTEXT = new Intertext();

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      return null;
    })();
  }

}).call(this);
