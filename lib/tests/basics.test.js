(function() {
  'use strict';
  var CND, alert, badge, debug, echo, help, info, jr, log, test, urge, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  badge = 'INTERTEXT/TESTS/BASICS';

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
  test = require('guy-test');

  //===========================================================================================================
  // TESTS
  //-----------------------------------------------------------------------------------------------------------
  this["BASICS rpr"] = async function(T, done) {
    var INTERTEXT, error, i, len, matcher, probe, probes_and_matchers, rpr;
    INTERTEXT = require('../..');
    ({rpr} = INTERTEXT.export());
    //.........................................................................................................
    probes_and_matchers = [
      ["foo",
      "'foo'",
      null],
      [["foo"],
      "[ 'foo' ]",
      null],
      [
        {
          this: 42,
          and: true,
          that: [1,
        2,
        null,
        void 0]
        },
        "{ this: 42, and: true, that: [ 1, 2, null, undefined ] }",
        null
      ],
      [void 0,
      "undefined",
      null],
      [2e308,
      "Infinity",
      null]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve) {
          var result;
          result = rpr(probe);
          return resolve(result);
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["BASICS camelize"] = async function(T, done) {
    var INTERTEXT, camelize, error, i, len, matcher, probe, probes_and_matchers;
    INTERTEXT = require('../..');
    ({camelize} = INTERTEXT.export());
    //.........................................................................................................
    probes_and_matchers = [['', ''], ['-', ''], ['--', ''], ['-a-', 'A'], ['-a', 'A'], ['a-', 'a'], ['helo', 'helo'], ['helo-world', 'heloWorld'], ['HELO-WORLD', 'HELOWORLD'], ['µ-DOM', 'µDOM'], ['danish-øre', 'danishØre']];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve) {
          var result;
          result = camelize(probe);
          return resolve(result);
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
      // debug ( k for k of ( require '../..' ).HTML ).sort().join ' '
      // await @_demo()
      // test @
      return test(this["BASICS camelize"]);
    })();
  }

  // test @[ "HTML.datoms_from_html (dubious)" ]
// test @[ "HTML.datoms_from_html (2)" ]
// test @[ "HTML.html_from_datoms (singular tags)" ]
// test @[ "HTML Cupofhtml (1)" ]
// test @[ "HTML Cupofhtml (2)" ]
// test @[ "HTML._parse_compact_tagname" ]

}).call(this);

//# sourceMappingURL=basics.test.js.map