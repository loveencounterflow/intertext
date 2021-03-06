// Generated by CoffeeScript 2.5.1
(function() {
  'use strict';
  var CND, DATOM, alert, badge, debug, echo, help, info, isa, jr, lets, log, new_datom, rpr, select, test, type_of, types, urge, validate, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/TESTS/UCD';

  log = CND.get_logger('plain', badge);

  info = CND.get_logger('info', badge);

  whisper = CND.get_logger('whisper', badge);

  alert = CND.get_logger('alert', badge);

  debug = CND.get_logger('debug', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  echo = CND.echo.bind(CND);

  ({jr} = CND);

  //...........................................................................................................
  DATOM = new (require('datom')).Datom({
    dirty: false
  });

  ({new_datom, lets, select} = DATOM.export());

  types = require('../types');

  // cast
  // declare
  // declare_cast
  // check
  // sad
  // is_sad
  // is_happy
  ({isa, validate, type_of} = types);

  //...........................................................................................................
  test = require('guy-test');

  //===========================================================================================================
  // TESTS
  //-----------------------------------------------------------------------------------------------------------
  this["INTERTEXT.UCD.get_block_list"] = function(T, done) {
    var INTERTEXT;
    INTERTEXT = require('../..');
    debug(INTERTEXT.UCD.get_block_list());
    // probes_and_matchers = []
    // for [ probe, matcher, error, ] in probes_and_matchers
    //   await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
    //     resolve INTERTEXT.SLABS.slabs_from_text probe
    //.........................................................................................................
    done();
    return null;
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      return test(this);
    })();
  }

  // help 'ok'
// test @[ "demo" ]

}).call(this);

//# sourceMappingURL=ucd.test.js.map
