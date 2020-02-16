(function() {
  'use strict';
  var CND, CUP, Cupofjoe, DATOM, MAIN, Multimix, alert, badge, debug, help, info, isa, jr, lets, log, new_datom, rpr, select, test, type_of, types, urge, validate, warn, whisper,
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
  this.expand = function() {
    this._expand(this.collector);
    return this._unwrap(this.collector);
  };

  this.expand_async = async function() {
    await this._expand_async(this.collector);
    return this._unwrap(this.collector);
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
      if ((x = list[idx]) == null) {
        list.splice(idx, 1);
        idx--;
        continue;
      }
      if ((type = type_of(x)) === 'list') {
        this._expand(x);
      } else if (type === 'function') {
        this.target = [];
        x();
        splice.apply(list, [idx, idx - idx + 1].concat(ref = this.target)), ref;
        idx--;
      } else if (type === 'asyncfunction') {
        throw new Error("^7767^ unable to synchronically expand async function");
      }
    }
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this._expand_async = async function(list) {
    var idx, ref, ref1, type, x;
    idx = -1;
    while (true) {
      idx++;
      if (idx > list.length - 1) {
        break;
      }
      if ((x = list[idx]) == null) {
        list.splice(idx, 1);
        idx--;
        continue;
      }
      if ((type = type_of(x)) === 'list') {
        await this._expand_async(x);
      } else if (type === 'function') {
        this.target = [];
        x();
        splice.apply(list, [idx, idx - idx + 1].concat(ref = this.target)), ref;
        idx--;
      } else if (type === 'asyncfunction') {
        this.target = [];
        await x();
        splice.apply(list, [idx, idx - idx + 1].concat(ref1 = this.target)), ref1;
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

  Cupofjoe = (function() {
    class Cupofjoe extends Multimix {
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

    Cupofjoe.include(MAIN, {
      overwrite: false
    });

    return Cupofjoe;

  }).call(this);

  //###########################################################################################################
  module.exports = CUP = new Cupofjoe();

  //-----------------------------------------------------------------------------------------------------------
  this["CUP demo 1"] = function(T, done) {
    var cram, ds, expand;
    ({cram, expand} = CUP.export());
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
    ds = expand();
    info(rpr(ds));
    // urge '^4443^', ds
    T.eq(ds, [['pre'], ['one', ['two', 42], ['three', ['four', ['five', ['six']]]]], ['post']]);
    if (done != null) {
      //.........................................................................................................
      return done();
    }
  };

  //-----------------------------------------------------------------------------------------------------------
  this["CUP demo 2"] = function(T, done) {
    var cram, ds, expand, h, html;
    ({cram, expand} = CUP.export());
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
    urge(rpr(CUP.collector));
    ds = expand();
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

  //-----------------------------------------------------------------------------------------------------------
  this["CUP demo 3"] = async function(T, done) {
    var cram, ds, expand, expand_async, request, sleep;
    ({cram, expand, expand_async} = CUP.export());
    //.........................................................................................................
    sleep = function(dts) {
      return new Promise((done) => {
        return setTimeout(done, dts * 1000);
      });
    };
    request = async function() {
      await sleep(0);
      return 'request complete';
    };
    //.........................................................................................................
    cram(null, function() {
      cram('pre');
      return cram('one', async function() {
        return cram('two', (await request()));
      });
    });
    // urge rpr CUP.collector
    ds = (await expand_async());
    info(rpr(ds));
    T.eq(ds, [['pre'], ['one', ['two', 'request complete']]]);
    if (done != null) {
      //.........................................................................................................
      return done();
    }
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      // test @
      // test @[ "CUP demo 1" ]
      test(this["CUP demo 2"]);
      return test(this["CUP demo 3"]);
    })();
  }

  // @[ "CUP demo" ]()

  // urge @collector; @collector.length = 0

}).call(this);
