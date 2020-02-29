(function() {
  'use strict';
  var $, $async, $drain, $show, $watch, CND, SP, alert, assign, badge, cast, copy, debug, echo, help, info, is_empty, isa, jr, last_of, log, rpr, test, type_of, types, urge, validate, warn, whisper;

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
  SP = require('steampipes');

  ({$, $async, $watch, $show, $drain} = SP.export());

  //...........................................................................................................
  types = (require('../..')).types;

  ({isa, validate, cast, last_of, type_of} = types);

  //-----------------------------------------------------------------------------------------------------------
  this.demo = function(T, done) {
    return new Promise(async(resolve) => {
      var TBL, error, i, len, matcher, probe, probes_and_matchers, ref;
      TBL = require('../tabulate');
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

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      return test(this);
    })();
  }

  // test @[ "demo" ]

}).call(this);
