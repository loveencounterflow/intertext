(function() {
  'use strict';
  var CND, DATOM, INTERTEXT, alert, badge, debug, echo, help, info, isa, jr, lets, log, new_datom, rpr, select, test, type_of, types, urge, validate, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/TESTS/SLABS';

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

  INTERTEXT = require('../..');

  //===========================================================================================================
  // TESTS
  //-----------------------------------------------------------------------------------------------------------
  this["INTERTEXT.SLABS.slabs_from_text"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [
        "",
        {
          "slabs": [],
          "ends": []
        },
        null
      ],
      [
        "a very fine day",
        {
          "slabs": ["a",
        "very",
        "fine",
        "day"],
          "ends": ["spc",
        "spc",
        "spc",
        null]
        },
        null
      ],
      [
        "a cro\xadmu\xadlent so\xadlu\xadtion",
        {
          "slabs": ["a",
        "cro",
        "mu",
        "lent",
        "so",
        "lu",
        "tion"],
          "ends": ["spc",
        "shy",
        "shy",
        "spc",
        "shy",
        "shy",
        null]
        },
        null
      ],
      [
        "䷾Letterpress printing",
        {
          "slabs": ["䷾Letterpress",
        "printing"],
          "ends": ["spc",
        null]
        },
        null
      ],
      [
        "ベルリンBerlin",
        {
          "slabs": ["ベ",
        "ル",
        "リ",
        "ン",
        "Berlin"],
          "ends": [null,
        null,
        null,
        null,
        null]
        },
        null
      ],
      [
        "其法用膠泥刻字、薄如錢唇",
        {
          "slabs": ["其",
        "法",
        "用",
        "膠",
        "泥",
        "刻",
        "字、",
        "薄",
        "如",
        "錢",
        "唇"],
          "ends": [null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null]
        },
        null
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          // debug '^44453^', INTERTEXT.HYPH.new_hyphenator()
          // debug '^44453^', INTERTEXT.HYPH.reveal_hyphens INTERTEXT.HYPH.new_hyphenator() 'fantastic'
          // debug '^777801^', INTERTEXT.SLABS.slabs_from_text probe
          return resolve(INTERTEXT.SLABS.slabs_from_text(probe));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["INTERTEXT.SLABS.assemble (1)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [["", "", null], ["a very fine day", "a very fine day", null], ["a cro\xadmu\xadlent so\xadlu\xadtion", "a cromulent solution", null], ["䷾Letterpress printing", "䷾Letterpress printing", null], ["ベルリンBerlin", "ベルリンBerlin", null], ["其法用膠泥刻字、薄如錢唇", "其法用膠泥刻字、薄如錢唇", null]];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          return resolve(INTERTEXT.SLABS.assemble(INTERTEXT.SLABS.slabs_from_text(probe)));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["INTERTEXT.SLABS.assemble (2)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [["", "", null], ["a very fine day", "fine day", null], ["a cro­mu­lent so­lu­tion", "mulent solu-", null], ["䷾Letterpress printing", "", null], ["ベルリンBerlin", "リンBerlin", null], ["其法用膠泥刻字、薄如錢唇", "用膠泥刻", null]];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var slb;
          slb = INTERTEXT.SLABS.slabs_from_text(probe);
          return resolve(INTERTEXT.SLABS.assemble(slb, 2, 5));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => { // await do =>
      // await @_demo()
      test(this);
      return help('ok');
    })();
  }

  // test @[ "demo" ]

}).call(this);
