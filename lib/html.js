(function() {
  'use strict';
  var CND, DATOM, HtmlParser, alert, badge, debug, echo, find_next_tag, help, info, isa, jr, lets, log, new_datom, rpr, select, type_of, types, urge, validate, warn, whisper,
    indexOf = [].indexOf;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/HTML';

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

  types = require('./types');

  // cast
  // declare
  // declare_cast
  // check
  // sad
  // is_sad
  // is_happy
  ({isa, validate, type_of} = types);

  //...........................................................................................................
  HtmlParser = require('atlas-html-stream');

  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  this._escape_text = function(x) {
    var R;
    R = x;
    R = R.replace(/&/g, '&amp;');
    R = R.replace(/</g, '&lt;');
    R = R.replace(/>/g, '&gt;');
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this._as_attribute_literal = function(x) {
    var R, must_quote;
    R = isa.text(x) ? x : JSON.stringify(x);
    must_quote = !isa._intertext_html_naked_attribute_text(R);
    R = this._escape_text(R);
    R = R.replace(/'/g, '&#39;');
    R = R.replace(/\n/g, '&#10;');
    if (must_quote) {
      R = "'" + R + "'";
    }
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.datom_as_html = (d) => {
    var atxt, i, key, len, ref, ref1, ref2, ref3, sigil, slash, src, tagname, value, x_key, x_sys_key;
    DATOM.types.validate.datom_datom(d);
    atxt = '';
    sigil = d.$key[0];
    tagname = d.$key.slice(1);
    x_key = null;
    //.........................................................................................................
    /* TAINT simplistic solution; namespace might already be taken? */
    if (indexOf.call('[~]', sigil) >= 0) {
      switch (sigil) {
        case '[':
          sigil = '<';
          break;
        case '~':
          sigil = '^';
          break;
        case ']':
          sigil = '>';
      }
      [x_key, tagname] = [tagname, 'x-sys'];
    }
    if ((sigil === '^') && (tagname === 'text')) {
      //.........................................................................................................
      return this._escape_text((ref = d.text) != null ? ref : '');
    }
    if ((sigil === '^') && (tagname === 'raw')) {
      return (ref1 = d.text) != null ? ref1 : '';
    }
    if ((sigil === '^') && (tagname === 'doctype')) {
      return `<!DOCTYPE ${(ref2 = d.$value) != null ? ref2 : 'html'}>`;
    }
    if (sigil === '>') {
      return `</${tagname}>`;
    }
    //.........................................................................................................
    /* NOTE sorting atxt by keys to make result predictable: */
    if (isa.object(d.$value)) {
      src = d.$value;
    } else {
      src = d;
    }
    if (x_key != null) {
      atxt += ` x-key=${this._as_attribute_literal(x_key)}`;
    }
    ref3 = (Object.keys(src)).sort();
    for (i = 0, len = ref3.length; i < len; i++) {
      key = ref3[i];
      if (key.startsWith('$')) {
        continue;
      }
      if ((value = src[key]) === true) {
        atxt += ` ${key}`;
      } else {
        atxt += ` ${key}=${this._as_attribute_literal(value)}`;
      }
    }
    //.........................................................................................................
    /* TAINT make self-closing elements configurable, depend on HTML5 type */
    slash = sigil === '<' ? '' : `</${tagname}>`;
    x_sys_key = x_key != null ? `<x-sys-key>${x_key}</x-sys-key>` : '';
    if (atxt === '') {
      return `<${tagname}>${slash}${x_sys_key}`;
    }
    return `<${tagname}${atxt}>${x_sys_key}${slash}`;
  };

  //===========================================================================================================
  // PARSING
  //-----------------------------------------------------------------------------------------------------------
  // @new_parse_method = ( settings ) ->
  //   validate.parse_html_settings settings = { types.defaults.parse_html_settings..., settings..., }
  this._new_parse_method = function(settings) {
    var R, parser;
    R = null;
    parser = new HtmlParser({
      preserveWS: true
    });
    //.........................................................................................................
    parser.on('data', ({name, data, text}) => {
      var $value, has_keys, key, value;
      if (name != null) {
        name = name.toLowerCase();
      }
      //.......................................................................................................
      if (name === '!doctype') {
        $value = 'html';
        for (key in data) {
          $value = key;
          break;
        }
        return R.push(new_datom('^doctype', $value));
      }
      if (text != null) {
        //.......................................................................................................
        return R.push(new_datom('^text', {text}));
      }
      if (data == null) {
        return R.push(new_datom('>' + name));
      }
      has_keys = false;
      for (key in data) {
        value = data[key];
        has_keys = true;
        if (value === '') {
          data[key] = true;
        }
      }
      if (!has_keys) {
        return R.push(new_datom('<' + name));
      }
      return R.push(new_datom('<' + name, data));
    });
    parser.on('error', function(error) {
      throw error;
    });
    // parser.on 'end', -> R.push new_datom '^stop'
    //.........................................................................................................
    return (html) => {
      R = [];
      parser.write(html);
      parser.flushText();
      parser.reset();
      return R;
    };
  };

  //-----------------------------------------------------------------------------------------------------------
  this.html_as_datoms = this._new_parse_method();

  //-----------------------------------------------------------------------------------------------------------
  find_next_tag = function(text, prv_idx = 0) {
    var idx_0, idx_1, idx_2;
    idx_0 = text.indexOf('<', prv_idx);
    idx_1 = text.indexOf('>', prv_idx);
    if (idx_0 < 0) {
      if (idx_1 < 0) {
        return [null, null];
      }
      throw new Error("Syntax error: closing but no opening bracket");
    }
    if (idx_1 < 0) {
      throw new Error("Syntax error: opening but no closing bracket");
    }
    if (idx_1 < idx_0) {
      throw new Error("Syntax error: closing before opening bracket");
    }
    if (idx_1 < idx_0 + 2) {
      throw new Error("Syntax error: closing bracket too close to opening bracket");
    }
    if (/\s/.test(text[idx_0 + 1])) {
      throw new Error("Syntax error: whitespace not allowed here");
    }
    idx_2 = text.indexOf('<', idx_0 + 1);
    if ((0 < idx_2 && idx_2 < idx_1)) {
      throw new Error("Syntax error: additional opening bracket");
    }
    return [idx_0, idx_1];
  };

  //-----------------------------------------------------------------------------------------------------------
  this.mkts_html_as_datoms = function(text) {
    var R, d, error, idx_0, idx_1, prv_idx, prv_idx_1, source, tags;
    R = [];
    prv_idx = 0;
    prv_idx_1 = -1;
    while (true) {
      try {
        //.......................................................................................................
        //.........................................................................................................
        [idx_0, idx_1] = find_next_tag(text, prv_idx);
      } catch (error1) {
        error = error1;
        if (!/Syntax error/.test(error.message)) {
          throw error;
        }
        source = text.slice(prv_idx);
        R.push(new_datom('~error', {
          message: `${error.message}: ${jr(source)}`,
          type: 'mkts-syntax-html',
          source: source
        }));
        return R;
      }
      //.......................................................................................................
      if (idx_0 > prv_idx_1 + 1) {
        R.push(new_datom('^text', {
          text: text.slice(prv_idx_1 + 1, idx_0)
        }));
      }
      if (idx_0 == null) {
        break;
      }
      tags = this.html_as_datoms(text.slice(idx_0, +idx_1 + 1 || 9e9));
      if (text[idx_1 - 1] === '/') {
        R.push(d = lets(tags[0], function(d) {
          return d.$key = '^' + d.$key.slice(1);
        }));
      } else {
        R.push(...tags);
      }
      prv_idx_1 = idx_1;
      prv_idx = idx_1 + 1;
    }
    //.........................................................................................................
    // debug '7776^', rpr { prv_idx, prv_idx_1, idx_0, idx_1, length: text.length, }
    if (prv_idx < text.length) {
      R.push(new_datom('^text', {
        text: text.slice(prv_idx_1 + 1)
      }));
    }
    return R;
  };

  //===========================================================================================================
  // PARSING
  //-----------------------------------------------------------------------------------------------------------
  this.$html_as_datoms = function() {
    var $;
    ({$} = (require('steampipes')).export());
    return $((buffer_or_text, send) => {
      var d, i, len, ref;
      ref = this.html_as_datoms(buffer_or_text);
      for (i = 0, len = ref.length; i < len; i++) {
        d = ref[i];
        send(d);
      }
      return null;
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  this.$mkts_html_as_datoms = function() {
    var $;
    ({$} = (require('steampipes')).export());
    return $((buffer_or_text, send) => {
      var d, i, len, ref;
      ref = this.mkts_html_as_datoms(buffer_or_text);
      for (i = 0, len = ref.length; i < len; i++) {
        d = ref[i];
        send(d);
      }
      return null;
    });
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => { // await do =>
      return help('ok');
    })();
  }

}).call(this);
