(function() {
  //###########################################################################################################
  var $, $as_event, $as_row, $async, $cleanup, $dividers_bottom, $dividers_top, $drain, $set_widths_etc, $show, $watch, CND, DATOM, SP, _new_state, alert, as_row, as_text, assign, badge, boxes, cast, copy, debug, freeze, get_divider, help, isa, jr, keys_toplevel, last_of, lets, new_datom, rpr, select, to_width, type_of, types, urge, validate, values_alignment, values_overflow, warn, width_of, wrap_datom;

  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/TBL';

  // log                       = CND.get_logger 'plain',     badge
  // info                      = CND.get_logger 'info',      badge
  // whisper                   = CND.get_logger 'whisper',   badge
  alert = CND.get_logger('alert', badge);

  debug = CND.get_logger('debug', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  // echo                      = CND.echo.bind CND
  //...........................................................................................................
  ({assign, jr} = CND);

  types = require('./types');

  ({isa, validate, cast, last_of, type_of} = types);

  SP = require('steampipes');

  ({$, $async, $watch, $show, $drain} = SP.export());

  ({jr} = CND);

  DATOM = new (require('datom')).Datom({
    dirty: false
  });

  ({new_datom, wrap_datom, lets, freeze, select} = DATOM.export());

  ({to_width, width_of} = require('to-width'));

  //-----------------------------------------------------------------------------------------------------------
  this.$tabulate = function(settings = {}) {
    var S, pipeline;
    S = _new_state(settings);
    //.........................................................................................................
    pipeline = [$as_event(S), $set_widths_etc(S), $dividers_top(S), $dividers_bottom(S), $as_row(S), $cleanup(S)];
    //.........................................................................................................
    return SP.pull(...pipeline);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.$show_table = function(settings) {
    throw new Error("not implemented");
  };

  //-----------------------------------------------------------------------------------------------------------
  _new_state = function(settings) {
    var S, box_style, ref, ref1, ref10, ref11, ref12, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9;
    S = {};
    /* TAINT use intertype */
    // validate_keys "settings", "one or more out of", ( Object.keys settings ), keys_toplevel
    //.........................................................................................................
    if (settings == null) {
      settings = {};
    }
    S.width = (ref = settings['width']) != null ? ref : 12;
    S.alignment = (ref1 = settings['alignment']) != null ? ref1 : 'left';
    S.fit = (ref2 = settings['fit']) != null ? ref2 : null;
    S.ellipsis = (ref3 = settings['ellipsis']) != null ? ref3 : '…';
    S.pad = (ref4 = settings['pad']) != null ? ref4 : ' ';
    S.overflow = (ref5 = settings['overflow']) != null ? ref5 : 'show';
    S.alignment = (ref6 = settings['alignment']) != null ? ref6 : 'left';
    S.multiline = (ref7 = settings['multiline']) != null ? ref7 : false;
    //.........................................................................................................
    S.widths = copy((ref8 = settings['widths']) != null ? ref8 : []);
    S.alignments = (ref9 = settings['alignments']) != null ? ref9 : [];
    S.headings = (ref10 = settings['headings']) != null ? ref10 : true;
    S.keys = (ref11 = settings['keys']) != null ? ref11 : null;
    S.box = copy((ref12 = settings['box']) != null ? ref12 : copy(boxes['plain']));
    if (CND.isa_number(S.pad)) {
      //.........................................................................................................
      S.pad = ' '.repeat(S.pad);
    }
    if (CND.isa_text(S.box)) {
      //.........................................................................................................
      S.box = box_style = boxes[S.box];
    }
    if (S.box == null) {
      throw new Error(`unknown box style ${rpr(box_style)}`);
    }
    //.........................................................................................................
    S.box.left = S.box.vs + S.pad;
    S.box.center = S.pad + S.box.vs + S.pad;
    S.box.right = S.pad + S.box.vs;
    S.box.left_width = width_of(S.box.left);
    S.box.center_width = width_of(S.box.center);
    S.box.right_width = width_of(S.box.right);
    //.........................................................................................................
    /* TAINT use intertype */
    // validate_keys "alignment", "one of", [ S.alignment, ], values_alignment
    // validate_keys "overflow",  "one of", [ S.overflow,  ], values_overflow
    //.........................................................................................................
    if (S.overflow !== 'show') {
      throw new Error("setting 'overflow' not yet supported");
    }
    if (S.fit != null) {
      throw new Error("setting 'fit' not yet supported");
    }
    //.........................................................................................................
    /* TAINT use intertype */
    /* TAINT check widths etc. are non-zero integers */
    /* TAINT check values in headings, widths, keys (?) */
    //.........................................................................................................
    return S;
  };

  //-----------------------------------------------------------------------------------------------------------
  /* TAINT use intertype */
  keys_toplevel = ['alignment', 'alignments', 'box', 'default', 'ellipsis', 'fit', 'headings', 'keys', 'overflow', 'pad', 'width', 'widths'];

  values_overflow = ['show', 'hide'];

  values_alignment = ['left', 'right', 'center'];

  //-----------------------------------------------------------------------------------------------------------
  $set_widths_etc = function(S) {
    var is_first;
    is_first = true;
    return $(function(d, send) {
      var _, base, base1, data, i, idx, j, key, ref, ref1;
      if (!is_first) {
        return send(d);
      }
      if (!select(d, '^data')) {
        return send(d);
      }
      is_first = false;
      ({data} = d);
      //...................................................................................................
      if (S.keys == null) {
        if (isa.list(data)) {
          S.keys = (function() {
            var i, len, results;
            results = [];
            for (idx = i = 0, len = data.length; i < len; idx = ++i) {
              _ = data[idx];
              results.push(idx);
            }
            return results;
          })();
        } else if (isa.object(data)) {
          S.keys = (function() {
            var results;
            results = [];
            for (key in data) {
              results.push(key);
            }
            return results;
          })();
        } else {
          throw new Error(`^intertext/tabulate/set_widths_etc@1^ expected a list or an object, got a ${CND.type_of(data)}`);
        }
      }
      if (S.headings === true) {
        S.headings = S.keys;
      }
      //...................................................................................................
      if (S.widths != null) {
        for (idx = i = 0, ref = S.keys.length; (0 <= ref ? i < ref : i > ref); idx = 0 <= ref ? ++i : --i) {
          if ((base = S.widths)[idx] == null) {
            base[idx] = S.width;
          }
        }
      } else {
        S.widths = (function() {
          var j, len, ref1, results;
          ref1 = S.keys;
          results = [];
          for (j = 0, len = ref1.length; j < len; j++) {
            key = ref1[j];
            results.push(S.width);
          }
          return results;
        })();
      }
      //...................................................................................................
      if (S.alignments != null) {
        for (idx = j = 0, ref1 = S.keys.length; (0 <= ref1 ? j < ref1 : j > ref1); idx = 0 <= ref1 ? ++j : --j) {
          if ((base1 = S.alignments)[idx] == null) {
            base1[idx] = S.alignment;
          }
        }
      } else {
        S.alignments = (function() {
          var k, len, ref2, results;
          ref2 = S.keys;
          results = [];
          for (k = 0, len = ref2.length; k < len; k++) {
            key = ref2[k];
            results.push(S.alignment);
          }
          return results;
        })();
      }
      //...................................................................................................
      return send(d);
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  as_row = (S, data, keys = null) => {
    var R, align, ellipsis, i, idx, key, keys_and_idxs, len, text, width;
    R = [];
    if (keys != null) {
      keys_and_idxs = (function() {
        var i, len, results;
        results = [];
        for (idx = i = 0, len = keys.length; i < len; idx = ++i) {
          key = keys[idx];
          results.push([key, idx]);
        }
        return results;
      })();
    } else {
      keys_and_idxs = (function() {
        var i, ref, results;
        results = [];
        for (idx = i = 0, ref = data.length; (0 <= ref ? i < ref : i > ref); idx = 0 <= ref ? ++i : --i) {
          results.push([idx, idx]);
        }
        return results;
      })();
    }
    if (S.multiline !== false) {
      throw new Error(`^intertype/tabulate/as_row@2^ setting multiline ${rpr(S.multiline)} not supported`);
    }
    for (i = 0, len = keys_and_idxs.length; i < len; i++) {
      [key, idx] = keys_and_idxs[i];
      text = as_text(S, data[key]);
      width = S.widths[idx];
      align = S.alignments[idx];
      ellipsis = S.ellipsis;
      R.push(to_width(text, width, {align, ellipsis}));
    }
    //.......................................................................................................
    return S.box.left + (R.join(S.box.center)) + S.box.right;
  };

  //-----------------------------------------------------------------------------------------------------------
  $as_row = function(S) {
    return $(function(d, send) {
      var data, text;
      if (!select(d, '^data')) {
        return send(d);
      }
      ({data} = d);
      text = as_row(S, d.data, S.keys);
      return send(new_datom('^table', {text}));
      return send(d);
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  get_divider = function(S, position) {
    var R, center, column, count, i, idx, last_idx, left, len, ref, right, width;
    switch (position) {
      case 'top':
        left = S.box.lt;
        center = S.box.ct;
        right = S.box.rt;
        break;
      case 'heading':
        left = S.box.lm;
        center = S.box.cm;
        right = S.box.rm;
        break;
      case 'mid':
        left = S.box.lm;
        center = S.box.cm;
        right = S.box.rm;
        break;
      case 'bottom':
        left = S.box.lb;
        center = S.box.cb;
        right = S.box.rb;
        break;
      default:
        throw new Error(`unknown position ${rpr(position)}`);
    }
    //.........................................................................................................
    last_idx = S.widths.length - 1;
    R = [];
    ref = S.widths;
    //.........................................................................................................
    /* TAINT simplified calculation; assumes single-width glyphs and symmetric padding etc. */
    for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
      width = ref[idx];
      column = [];
      if (idx === 0) {
        column.push(left);
        count = (S.box.left_width - 1) + width + ((S.box.center_width - 1) / 2);
      } else if (idx === last_idx) {
        column.push(center);
        count = ((S.box.center_width - 1) / 2) + width + (S.box.right_width - 1);
      } else {
        column.push(center);
        count = ((S.box.center_width - 1) / 2) + width + ((S.box.center_width - 1) / 2);
      }
      column.push(S.box.hs.repeat(count));
      if (idx === last_idx) {
        column.push(right);
      }
      R.push(column.join(''));
    }
    //.........................................................................................................
    return R.join('');
  };

  // #-----------------------------------------------------------------------------------------------------------
  // $dividers = ( S ) ->
  //   # return D.new_stream pipeline: [ ( $dividers_top S ), ( $dividers_mid S ), ( $dividers_bottom S ), ]
  //   return D.new_stream pipeline: [ ( $dividers_top S ), ( $dividers_bottom S ), ]

  //...........................................................................................................
  $dividers_top = function(S) {
    var is_first;
    is_first = true;
    return $(function(d, send) {
      var ref;
      if (!is_first) {
        return send(d);
      }
      is_first = false;
      send(new_datom('^table', {
        text: get_divider(S, 'top')
      }));
      //.......................................................................................................
      if ((ref = S.headings) !== null && ref !== false) {
        send(new_datom('^table', {
          text: as_row(S, S.headings)
        }));
        send(new_datom('^table', {
          text: get_divider(S, 'heading')
        }));
      }
      //.......................................................................................................
      return send(d);
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  $dividers_bottom = function(S) {
    return SP.window({
      width: 2,
      fallback: null
    }, $(function(de, send) {
      var d, e;
      [d, e] = de;
      if (d == null) {
        return null;
      }
      send(d);
      if (e == null) {
        send(new_datom('^table', {
          text: get_divider(S, 'bottom')
        }));
      }
      return null;
    }));
  };

  //-----------------------------------------------------------------------------------------------------------
  $cleanup = function(S) {
    return SP.$filter(function(d) {
      return select(d, '^table');
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  boxes = {
    plain: {
      lt: '┌',
      ct: '┬',
      rt: '┐',
      lm: '├',
      cm: '┼',
      rm: '┤',
      lb: '└',
      cb: '┴',
      rb: '┘',
      vs: '│',
      hs: '─'
    },
    round: {
      lt: '╭',
      ct: '┬',
      rt: '╮',
      lm: '├',
      cm: '┼',
      rm: '┤',
      lb: '╰',
      cb: '┴',
      rb: '╯',
      vs: '│',
      hs: '─'
    }
  };

  //===========================================================================================================
  // HELPERS
  //-----------------------------------------------------------------------------------------------------------
  $as_event = function(S) {
    return $(function(data, send) {
      return send(new_datom('^data', {data}));
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  as_text = function(S, x) {
    var type;
    switch (type = type_of(x)) {
      case 'text':
        if (S.multiline) {
          return x;
        }
        if (!((x === '') || (/\s/.test(x)))) {
          return x;
        }
        return jr(x);
    }
    /* other types, number formatting go here */
    return rpr(x);
  };

  //-----------------------------------------------------------------------------------------------------------
  copy = function(x) {
    if (isa.list(x)) {
      return Object.assign([], x);
    }
    if (isa.object(x)) {
      return Object.assign({}, x);
    }
    return x;
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {})();
  }

}).call(this);