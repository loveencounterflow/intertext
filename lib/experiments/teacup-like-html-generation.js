(function() {
  // cannot 'use strict'

  //###########################################################################################################
  var CND, DATOM, HTML, INTERTEXT, alert, badge, css, datoms_as_html, debug, demo_1, demo_2, demo_3, dhtml, help, info, isa, jr, lets, log, new_datom, raw, rpr, script, select, text, type_of, types, urge, validate, warn, whisper,
    splice = [].splice;

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
  INTERTEXT = require('../..');

  ({HTML} = INTERTEXT);

  ({datoms_as_html, raw, text, script, css, dhtml} = HTML.export());

  ({jr} = CND);

  //-----------------------------------------------------------------------------------------------------------
  demo_1 = function() {
    var c, g, h, render, target, walk;
    c = [];
    target = c;
    render = function(...x) {
      return x;
    };
    h = function(...x) {
      target.push(x);
      return null;
    };
    //.........................................................................................................
    render(h('one', function() {
      h('two', 42);
      return h('three', function() {
        return h('four');
      });
    }));
    //.........................................................................................................
    urge(c);
    target = c[0];
    g = target.pop();
    g();
    urge(c);
    //.........................................................................................................
    walk = function(list) {
      var i, idx, len, x;
      for (idx = i = 0, len = list.length; i < len; idx = ++i) {
        x = list[idx];
        if (isa.list(x)) {
          walk(x);
        }
        if (isa.function(x)) {
          list[idx] = target = [];
          x();
        } else {
          info(rpr(x));
        }
      }
      return null;
    };
    //.........................................................................................................
    walk(c);
    urge(jr(c));
    return info(CND.equals(c, [["one", ["two", 42], ["three", [["four"]]]]]));
  };

  //-----------------------------------------------------------------------------------------------------------
  demo_2 = function() {
    var c, d, h, render, target, unwrap, walk;
    c = [];
    target = c;
    h = function(...x) {
      target.push(x);
      return null;
    };
    //.........................................................................................................
    h('one', function() {
      h('two', 42);
      return h('three', function() {
        return h('four');
      });
    });
    //.........................................................................................................
    walk = function(list) {
      var idx, x;
      idx = -1;
      while (true) {
        idx++;
        if (idx > list.length - 1) {
          break;
        }
        x = list[idx];
        if (isa.list(x)) {
          walk(x);
          continue;
        }
        if (isa.function(x)) {
          target = [];
          x();
          whisper(target);
          splice.apply(list, [idx, idx - idx + 1].concat(target)), target;
          idx--;
          continue;
        }
        info(rpr(x));
      }
      return null;
    };
    unwrap = function(x) {
      if (!isa.list(x)) {
        return x;
      }
      if (x.length !== 1) {
        return x;
      }
      if (!isa.list(x[0])) {
        return x;
      }
      return x[0];
    };
    render = function(list) {
      walk(list);
      return unwrap(list);
    };
    //.........................................................................................................
    urge(rpr(c));
    d = render(c);
    info(CND.truth(CND.equals(c, [['one', ['two', 42], ['three', ['four']]]])));
    info(CND.truth(CND.equals(d, ['one', ['two', 42], ['three', ['four']]])));
    info(rpr(d));
    //.........................................................................................................
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  demo_3 = function() {
    var c, d, h, render, target, unwrap, walk;
    c = [];
    target = c;
    h = function(...x) {
      target.push(x);
      return null;
    };
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
    //.........................................................................................................
    walk = function(list) {
      var idx, type, x;
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
            walk(x);
            break;
          case 'function':
            target = [];
            x();
            whisper(target);
            splice.apply(list, [idx, idx - idx + 1].concat(target)), target;
            idx--;
            break;
          default:
            info(rpr(x));
        }
      }
      return null;
    };
    unwrap = function(x) {
      if (!isa.list(x)) {
        return x;
      }
      if (x.length !== 1) {
        return x;
      }
      if (!isa.list(x[0])) {
        return x;
      }
      return unwrap(x[0]);
    };
    render = function(list) {
      walk(list);
      return unwrap(list);
    };
    //.........................................................................................................
    urge(rpr(c));
    d = render(c);
    info(CND.truth(CND.equals(d, [['pre'], ['one', ['two', 42], ['three', ['four']]], ['post']])));
    info(rpr(d));
    //.........................................................................................................
    return null;
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      // demo_1()
      // demo_2()
      return demo_3();
    })();
  }

  // urge c; c.length = 0

}).call(this);
