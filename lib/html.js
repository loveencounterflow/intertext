(function() {
  'use strict';
  var CND, DATOM, HtmlParser, alert, badge, debug, echo, help, info, isa, jr, log, new_datom, rpr, type_of, urge, validate, warn, whisper,
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
  DATOM = require('datom');

  ({new_datom} = DATOM.export());

  this.types = require('./types');

  // cast
  // declare
  // declare_cast
  // check
  // sad
  // is_sad
  // is_happy
  ({isa, validate, type_of} = this.types);

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

  // slash = if sigil is '<' then '' else '/'
  // return "<#{tagname}#{slash}>" if atxt is ''
  // return "<#{tagname}#{atxt}#{slash}>"

  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  this.new_parse_method = function() {
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
  this.html_as_datoms = this.new_parse_method();

  //###########################################################################################################
  if (module === require.main) {
    (() => { // await do =>
      return help('ok');
    })();
  }

}).call(this);
