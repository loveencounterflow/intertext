(function() {
  'use strict';
  var CND, alert, assign, badge, cast, copy, debug, echo, help, info, is_empty, isa, jr, last_of, log, rpr, test, type_of, types, urge, validate, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/TESTS/TABULATE';

  log = CND.get_logger('plain', badge);

  info = CND.get_logger('info', badge);

  whisper = CND.get_logger('whisper', badge);

  alert = CND.get_logger('alert', badge);

  debug = CND.get_logger('debug', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  echo = CND.echo.bind(CND);

  ({is_empty, copy, assign, jr} = CND);

  // PATH                      = require 'path'
  // FS                        = require 'fs'
  //...........................................................................................................
  test = require('guy-test');

  //...........................................................................................................
  types = (require('../..')).types;

  ({isa, validate, cast, last_of, type_of} = types);

  //-----------------------------------------------------------------------------------------------------------
  this._xxx_kw_demo = function() {
    return new Promise((resolve) => {
      var $, $async, $drain, $show, $watch, SP, TBL, pipeline, ref, source;
      SP = require('steampipes');
      ({$, $async, $watch, $show, $drain} = SP.export());
      TBL = (require('../..')).TBL;
      source = [
        Array.from('abcdefg'),
        (function() {
          var results = [];
          for (var i = 1e6, ref = 1e6 + 7; 1e6 <= ref ? i <= ref : i >= ref; 1e6 <= ref ? i++ : i--){ results.push(i); }
          return results;
        }).apply(this)
      ];
      //.........................................................................................................
      pipeline = [];
      pipeline.push(source);
      pipeline.push(TBL.$tabulate());
      pipeline.push($watch(function(d) {
        return echo(d.text);
      }));
      pipeline.push($drain(function(result) {
        return resolve(result);
      }));
      SP.pull(...pipeline);
      resolve();
      return null;
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  this.demo = function(T, done) {
    return new Promise(async(resolve) => {
      var $, $async, $drain, $show, $watch, SP, TBL, error, i, len, matcher, probe, probes_and_matchers, ref;
      SP = require('steampipes');
      ({$, $async, $watch, $show, $drain} = SP.export());
      //...........................................................................................................
      TBL = (require('../..')).TBL;
      probes_and_matchers = [
        [
          [
            Array.from('abcdefg'),
            (function() {
              var results = [];
              for (var i = 1e6, ref = 1e6 + 7; 1e6 <= ref ? i <= ref : i >= ref; 1e6 <= ref ? i++ : i--){ results.push(i); }
              return results;
            }).apply(this)
          ],
          [
            {
              "text": "┌──────────────┬──────────────┬──────────────┬──────────────┬──────────────┬──────────────┬──────────────┐",
              "$key": "^table"
            },
            {
              "text": "│ 0            │ 1            │ 2            │ 3            │ 4            │ 5            │ 6            │",
              "$key": "^table"
            },
            {
              "text": "├──────────────┼──────────────┼──────────────┼──────────────┼──────────────┼──────────────┼──────────────┤",
              "$key": "^table"
            },
            {
              "text": "│ a            │ b            │ c            │ d            │ e            │ f            │ g            │",
              "$key": "^table"
            },
            {
              "text": "│ 1000000      │ 1000001      │ 1000002      │ 1000003      │ 1000004      │ 1000005      │ 1000006      │",
              "$key": "^table"
            },
            {
              "text": "└──────────────┴──────────────┴──────────────┴──────────────┴──────────────┴──────────────┴──────────────┘",
              "$key": "^table"
            }
          ]
        ]
      ];
//.........................................................................................................
      for (i = 0, len = probes_and_matchers.length; i < len; i++) {
        [probe, matcher, error] = probes_and_matchers[i];
        await T.perform(probe, matcher, error, function() {
          return new Promise(function(resolve) {
            var pipeline;
            pipeline = [];
            pipeline.push(probe);
            pipeline.push(TBL.$tabulate());
            pipeline.push($watch(function(d) {
              return echo(d.text);
            }));
            pipeline.push($drain(function(result) {
              return resolve(result);
            }));
            return SP.pull(...pipeline);
          });
        });
      }
      if (done != null) {
        //.........................................................................................................
        done();
      }
      resolve();
      return null;
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  this["multiline text"] = function(T, done) {
    return new Promise(async(resolve) => {
      var $, $async, $drain, $show, $watch, SP, TBL, error, i, len, matcher, probe, probes_and_matchers;
      SP = require('steampipes');
      ({$, $async, $watch, $show, $drain} = SP.export());
      //...........................................................................................................
      TBL = (require('../..')).TBL;
      probes_and_matchers = [
        [
          [
            {
              key: 1,
              value: "helo"
            },
            {
              key: 2,
              value: "world"
            },
            {
              key: 2,
              value: "on\nmultiple\nlines"
            }
          ],
          void 0
        ]
      ];
//.........................................................................................................
      for (i = 0, len = probes_and_matchers.length; i < len; i++) {
        [probe, matcher, error] = probes_and_matchers[i];
        await T.perform(probe, matcher, error, function() {
          return new Promise(function(resolve) {
            var pipeline;
            pipeline = [];
            pipeline.push(probe);
            pipeline.push(TBL.$tabulate({
              multiline: false
            }));
            pipeline.push($watch(function(d) {
              return echo(d.text);
            }));
            pipeline.push($drain(function(result) {
              return resolve(void 0); // result
            }));
            return SP.pull(...pipeline);
          });
        });
      }
      if (done != null) {
        //.........................................................................................................
        done();
      }
      resolve();
      return null;
    });
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      // await @_xxx_kw_demo()
      return test(this);
    })();
  }

  // test @[ "demo" ]

}).call(this);
