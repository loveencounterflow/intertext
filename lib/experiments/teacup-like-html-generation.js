(function() {
  'use strict';
  var CND, DATOM, MAIN, Multimix, XXX, Xxx, alert, badge, debug, help, info, isa, jr, lets, log, new_datom, rpr, select, test, type_of, types, urge, validate, warn, whisper,
    splice = [].splice;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr.bind(CND);

  badge = 'INTERTEXT/EXPERIMENTS/TEACUP-LIKE-HTML-GENERATION';

  log = CND.get_logger('plain', badge);

  info = CND.get_logger('info', badge);

  whisper = CND.get_logger('whisper', badge);

  alert = CND.get_logger('alert', badge);

  debug = CND.get_logger('debug', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  //...........................................................................................................
  DATOM = new (require('datom')).Datom({
    dirty: false
  });

  ({new_datom, lets, select} = DATOM.export());

  //...........................................................................................................
  types = require('../types');

  ({isa, validate, type_of} = types);

  //...........................................................................................................
  // INTERTEXT                 = require '../..'
  // { HTML }                  = INTERTEXT
  // { datoms_as_html
  //   raw
  //   text
  //   script
  //   css
  //   dhtml }                 = HTML.export()
  ({jr} = CND);

  test = require('guy-test');

  Multimix = require('multimix');

  //-----------------------------------------------------------------------------------------------------------
  this.walk = function(list) {
    var idx, ref, type, x;
    idx = -1;
    while (true) {
      idx++;
      if (idx > list.length - 1) {
        break;
      }
      x = list[idx];
      switch (type = type_of(x)) {
        case 'null':
          list.splice(idx, 1);
          idx--;
          break;
        case 'list':
          this.walk(x);
          break;
        case 'function':
          this.target = [];
          x();
          whisper(this.target);
          splice.apply(list, [idx, idx - idx + 1].concat(ref = this.target)), ref;
          idx--;
          break;
        default:
          info(rpr(x));
      }
    }
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.unwrap = function(x) {
    if (!isa.list(x)) {
      return x;
    }
    if (x.length !== 1) {
      return x;
    }
    if (!isa.list(x[0])) {
      return x;
    }
    return this.unwrap(x[0]);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.render = function(list) {
    this.walk(list);
    return this.unwrap(list);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.h = function(...x) {
    this.target.push(x);
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  MAIN = this;

  Xxx = (function() {
    class Xxx extends Multimix {
      // @extend MAIN, { overwrite: false, }

        //---------------------------------------------------------------------------------------------------------
      constructor() {
        super();
        // @export @target if @target?
        this.collector = [];
        this.target = this.collector;
        return this;
      }

    };

    Xxx.include(MAIN, {
      overwrite: false
    });

    return Xxx;

  }).call(this);

  //###########################################################################################################
  module.exports = XXX = new Xxx();

  //-----------------------------------------------------------------------------------------------------------
  this["XXX demo"] = function(T, done) {
    var d, h, render;
    ({h, render} = XXX.export());
    //.........................................................................................................
    h(null, function() {
      h('pre');
      h('one', function() {
        h('two', 42);
        return h('three', function() {
          return h('four');
        });
      });
      return h('post');
    });
    urge(rpr(XXX.collector));
    d = render(XXX.collector);
    T.eq(d, [['pre'], ['one', ['two', 42], ['three', ['four']]], ['post']]);
    info(rpr(d));
    if (done != null) {
      //.........................................................................................................
      return done();
    }
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      return test(this["XXX demo"]);
    })();
  }

  // @[ "XXX demo" ]()

  // urge @collector; @collector.length = 0

}).call(this);
