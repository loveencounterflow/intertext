(function() {
  'use strict';
  var CND, Cupofhtml, FS, Htmlish, Hyph, INTERTEXT, Intertext, MAIN, Multimix, PATH, Patterns, Tbl, Ucd, alert, assign, badge, cast, debug, echo, help, info, inspect, isa, jr, log, rpr, type_of, urge, validate, warn, whisper;

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

  ({inspect} = require('util'));

  Htmlish = (function() {
    /*
    #...........................................................................................................
    _format                   = require 'number-format.js'
    format_float              = ( x ) -> _format '#,##0.000', x
    format_integer            = ( x ) -> _format '#,##0.',    x
    format_as_percentage      = ( x ) -> _format '#,##0.00',  x * 100
     */
    //-----------------------------------------------------------------------------------------------------------
    class Htmlish extends Multimix {};

    Htmlish.include(require('./htmlish'));

    return Htmlish;

  }).call(this);

  Cupofhtml = (function() {
    //-----------------------------------------------------------------------------------------------------------
    class Cupofhtml extends Multimix {};

    Cupofhtml.include(require('./cupofhtml'));

    return Cupofhtml;

  }).call(this);

  Hyph = (function() {
    //-----------------------------------------------------------------------------------------------------------
    class Hyph extends Multimix {};

    Hyph.include(require('./hyphenation'));

    return Hyph;

  }).call(this);

  Ucd = (function() {
    //-----------------------------------------------------------------------------------------------------------
    class Ucd extends Multimix {};

    Ucd.include(require('./ucd'));

    return Ucd;

  }).call(this);

  Patterns = (function() {
    //-----------------------------------------------------------------------------------------------------------
    class Patterns extends Multimix {};

    Patterns.include(require('./_patterns'));

    return Patterns;

  }).call(this);

  Tbl = (function() {
    //-----------------------------------------------------------------------------------------------------------
    class Tbl extends Multimix {};

    Tbl.include(require('./tabulate'));

    return Tbl;

  }).call(this);

  //-----------------------------------------------------------------------------------------------------------
  this.get_terminal_size = function() {
    return (require('../dependencies/sindre-sorhus-term-size.js'))();
  };

  //-----------------------------------------------------------------------------------------------------------
  this.rpr = function(...P) {
    var x;
    return ((function() {
      var i, len, results;
      results = [];
      for (i = 0, len = P.length; i < len; i++) {
        x = P[i];
        results.push(inspect(x, this.rpr_settings));
      }
      return results;
    }).call(this)).join(' ');
  };

  //-----------------------------------------------------------------------------------------------------------
  this.camelize = function(text) {
    /* thx to https://github.com/lodash/lodash/blob/master/camelCase.js */
    var i, idx, ref, word, words;
    words = text.split('-');
    for (idx = i = 1, ref = words.length; i < ref; idx = i += +1) {
      word = words[idx];
      if (word === '') {
        continue;
      }
      words[idx] = word[0].toUpperCase() + word.slice(1);
    }
    return words.join('');
  };

  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  MAIN = this;

  Intertext = (function() {
    class Intertext extends Multimix {
      // @extend MAIN, { overwrite: false, }

        //---------------------------------------------------------------------------------------------------------
      constructor(target = null) {
        super();
        this.HTMLISH = new Htmlish();
        this.CUPOFHTML = new Cupofhtml();
        this.HYPH = new Hyph();
        this.UCD = new Ucd();
        this._PATTERNS = new Patterns();
        this.TBL = new Tbl();
        this.DIFF = require('./diff');
        this.RE = require('./re');
        this.rpr_settings = {
          depth: 2e308,
          maxArrayLength: 2e308,
          breakLength: 2e308,
          compact: true
        };
        if (target != null) {
          this.export(target);
        }
        return this;
      }

    };

    Intertext.include(MAIN, {
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

//# sourceMappingURL=main.js.map