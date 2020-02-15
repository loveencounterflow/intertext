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

  // #-----------------------------------------------------------------------------------------------------------
  // get_nesting_level = ( list ) ->
  //   validate.list list
  //   return _get_nesting_level list, -1, -1
  // _get_nesting_level = ( list, level, max_nesting_level ) ->
  //   level            += 1
  //   max_nesting_level = Math.max max_nesting_level, level
  //   for x in list
  //     continue unless isa.list x
  //     max_nesting_level = Math.max max_nesting_level, _get_nesting_level x, level, max_nesting_level
  //   return max_nesting_level
  // urge '^897^', get_nesting_level []
  // urge '^897^', get_nesting_level [ 1, ]
  // urge '^897^', get_nesting_level [[]]
  // urge '^897^', get_nesting_level [ [ 4, ], ]
  // urge '^897^', get_nesting_level [[[]]]
  // urge '^897^', get_nesting_level [ 1, [ 2, 4, [ 5, ], [ 6, ], ], ]

  //-----------------------------------------------------------------------------------------------------------
  this.expand = function(list) {
    this._expand(list);
    return this._unwrap(list);
  };

  //-----------------------------------------------------------------------------------------------------------
  this._expand = function(list) {
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
          this._expand(x);
          break;
        case 'function':
          this.target = [];
          x();
          splice.apply(list, [idx, idx - idx + 1].concat(ref = this.target)), ref;
          idx--;
      }
    }
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this._unwrap = function(x) {
    if (!isa.list(x)) {
      return x;
    }
    if (x.length !== 1) {
      return x;
    }
    if (!isa.list(x[0])) {
      return x;
    }
    return this._unwrap(x[0]);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.cram = function(...x) {
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
  this["XXX demo 1"] = function(T, done) {
    var cram, ds, expand;
    ({cram, expand} = XXX.export());
    //.........................................................................................................
    cram(null, function() {
      cram('pre');
      cram('one', function() {
        cram('two', 42);
        return cram('three', function() {
          return cram('four', function() {
            return cram('five', function() {
              return cram('six');
            });
          });
        });
      });
      return cram('post');
    });
    // urge rpr XXX.collector
    ds = expand(XXX.collector);
    // urge '^4443^', ds
    T.eq(ds, [['pre'], ['one', ['two', 42], ['three', ['four', ['five', ['six']]]]], ['post']]);
    info(rpr(ds));
    if (done != null) {
      //.........................................................................................................
      return done();
    }
  };

  //-----------------------------------------------------------------------------------------------------------
  this["XXX demo 2"] = function(T, done) {
    var cram, ds, expand, h, html;
    ({cram, expand} = XXX.export());
    //.........................................................................................................
    h = function(tagname, ...content) {
      var d, d1, d2;
      if (content.length === 0) {
        d = new_datom(`^${tagname}`);
        return cram(d, ...content);
      }
      d1 = new_datom(`<${tagname}`);
      d2 = new_datom(`>${tagname}`);
      return cram(d1, ...content, d2);
    };
    //.........................................................................................................
    cram(null, function() {
      h('pre');
      h('one', function() {
        h('two', new_datom('^text', {
          text: '42'
        }));
        return h('three', function() {
          return h('four', function() {
            return h('five', function() {
              return h('six', function() {
                return cram(new_datom('^text', {
                  text: 'bottom'
                }));
              });
            });
          });
        });
      });
      return h('post');
    });
    urge(rpr(XXX.collector));
    ds = expand(XXX.collector);
    info(rpr(ds));
    urge(html = (require('../..')).HTML.datoms_as_html(ds));
    T.eq(html, "<pre></pre><one><two>42</two><three><four><five><six>bottom</six></five></four></three></one><post></post>");
    T.eq(ds, [
      [
        {
          '$key': '^pre'
        }
      ],
      [
        {
          '$key': '<one'
        },
        [
          {
            '$key': '<two'
          },
          {
            text: '42',
            '$key': '^text'
          },
          {
            '$key': '>two'
          }
        ],
        [
          {
            '$key': '<three'
          },
          [
            {
              '$key': '<four'
            },
            [
              {
                '$key': '<five'
              },
              [
                {
                  '$key': '<six'
                },
                [
                  {
                    text: 'bottom',
                    '$key': '^text'
                  }
                ],
                {
                  '$key': '>six'
                }
              ],
              {
                '$key': '>five'
              }
            ],
            {
              '$key': '>four'
            }
          ],
          {
            '$key': '>three'
          }
        ],
        {
          '$key': '>one'
        }
      ],
      [
        {
          '$key': '^post'
        }
      ]
    ]);
    if (done != null) {
      //.........................................................................................................
      return done();
    }
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      // test @[ "XXX demo 1" ]
      return test(this["XXX demo 2"]);
    })();
  }

  // @[ "XXX demo" ]()

  // urge @collector; @collector.length = 0

}).call(this);
