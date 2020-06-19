(function() {
  'use strict';
  var CND, Cupofjoe, DATOM, alert, assign, badge, debug, echo, excluded_content_parts, freeze, help, info, is_frozen, isa, jr, lets, log, new_datom, rpr, select, thaw, type_of, types, urge, validate, warn, whisper,
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

  ({new_datom, lets, freeze, thaw, is_frozen, select} = DATOM.export());

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
  ({Cupofjoe} = require('cupofjoe'));

  assign = Object.assign;

  excluded_content_parts = ['', null, void 0];

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
  this._parse_compact_tagname = function(compact_tagname) {
    var R, attribute, attributes, avalue, i, len, ref, tagname;
    ({tagname, attributes} = (compact_tagname.match(/^(?<tagname>[^#.]*)(?<attributes>.*)$/)).groups);
    R = {};
    if (tagname !== '') {
      R.tagname = tagname;
    }
    if (attributes === '') {
      return R;
    }
    ref = attributes.split(/([#.][^#.]*)/);
    for (i = 0, len = ref.length; i < len; i++) {
      attribute = ref[i];
      if (attribute === '') {
        continue;
      }
      avalue = attribute.slice(1);
      if (!(avalue.length > 0)) {
        throw new Error(`^intertext/_parse_compact_tagname@1234^ illegal compact tag syntax in ${rpr(compact_tagname)}`);
      }
      if (attribute[0] === '#') {
        R.id = avalue;
      } else {
        (R.class != null ? R.class : R.class = []).push(avalue);
      }
    }
    if (R.class != null) {
      R.class = R.class.join(' ');
    }
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.tag = function(compact_tagname, attributes, ...content) {
    var end, start;
    ({start, content, end} = this._tag(compact_tagname, attributes, content));
    if (end != null) {
      return [start, ...content, end];
    }
    return [start, ...content];
  };

  //-----------------------------------------------------------------------------------------------------------
  this._tag = function(compact_tagname, attributes, content, settings) {
    var call_functions, clasz, end_tag, i, id, idclass, len, part, processed_content, ref, ref1, sigil, start_tag, tagname, use_attributes, x;
    validate.nonempty_text(compact_tagname);
    ({
      tagname,
      id,
      class: clasz
    } = this._parse_compact_tagname(compact_tagname));
    validate.intertext_html_tagname(tagname);
    use_attributes = false;
    processed_content = [];
    call_functions = (ref = settings != null ? settings.call_functions : void 0) != null ? ref : true;
    if (Object.isFrozen(content)) {
      content = thaw(content);
    }
    //.........................................................................................................
    if (attributes != null) {
      if (isa.object(attributes)) {
        use_attributes = true;
      } else {
        content.unshift(attributes);
      }
    }
    //.........................................................................................................
    if (content.length === 0) {
      sigil = '^';
      end_tag = null;
    } else {
      //.........................................................................................................
      sigil = '<';
      end_tag = new_datom(`>${tagname}`);
      for (i = 0, len = content.length; i < len; i++) {
        part = content[i];
        if (indexOf.call(excluded_content_parts, part) >= 0) {
          continue;
        }
        switch (type_of(part)) {
          case 'text':
            processed_content.push(new_datom('^text', {
              text: part
            }));
            break;
          case 'function':
            if (call_functions) {
              if (ref1 = (x = part()), indexOf.call(excluded_content_parts, ref1) < 0) {
                processed_content.push(x);
              }
            } else {
              processed_content.push(part);
            }
            break;
          default:
            processed_content.push(part);
        }
      }
    }
    //.........................................................................................................
    if ((id != null) || (clasz != null)) {
      idclass = {};
      if (id != null) {
        idclass.id = id;
      }
      if (clasz != null) {
        idclass.class = clasz;
      }
      if (use_attributes) {
        attributes = assign(idclass, attributes);
      } else {
        use_attributes = true;
        attributes = idclass;
      }
    }
    //.........................................................................................................
    if (use_attributes) {
      start_tag = new_datom(`${sigil}${tagname}`, attributes);
    } else {
      start_tag = new_datom(`${sigil}${tagname}`);
    }
    //.........................................................................................................
    processed_content = processed_content.flat(2e308);
    if (end_tag != null) {
      return {
        start: start_tag,
        content: processed_content,
        end: end_tag
      };
    }
    return {
      start: start_tag,
      content: processed_content
    };
  };

  //-----------------------------------------------------------------------------------------------------------
  this.html_from_datoms = function(...ds) {
    var d;
    return ((function() {
      var i, len, ref, results;
      ref = ds.flat(2e308);
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        d = ref[i];
        results.push(this._html_from_datom(d));
      }
      return results;
    }).call(this)).join('');
  };

  //-----------------------------------------------------------------------------------------------------------
  this.$html_from_datoms = function() {
    var $;
    ({$} = (require('steampipes')).export());
    return $((d, send) => {
      var i, len, ref, x;
      if (!isa.list(d)) {
        return send(this._html_from_datom(d));
      }
      ref = this.html_from_datoms(...d);
      for (i = 0, len = ref.length; i < len; i++) {
        x = ref[i];
        send(x);
      }
      return null;
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  this._html_from_datom = function(d) {
    var atxt, bnl, i, is_block_tag, is_empty_tag, key, len, ref, ref1, ref2, ref3, ref4, sigil, slash, src, tagname, value, x_key, x_sys_key, xnl;
    if (isa.text(d)) {
      return this._html_from_datom((this.text(d))[0]);
    }
    /* TAINT ??? */    DATOM.types.validate.datom_datom(d);
    atxt = '';
    sigil = d.$key[0];
    tagname = d.$key.slice(1);
    is_empty_tag = isa._intertext_html_empty_element_tagname(tagname);
    x_key = null;
    is_block_tag = (ref = d.$blk) != null ? ref : false;
    bnl = is_block_tag ? '\n\n' : ''/* TAINT make configurable */
    xnl = '\n'/* TAINT make configurable */
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
      return this._escape_text((ref1 = d.text) != null ? ref1 : '');
    }
    if ((sigil === '^') && (tagname === 'raw')) {
      return (ref2 = d.text) != null ? ref2 : '';
    }
    if ((sigil === '^') && (tagname === 'doctype')) {
      return `<!DOCTYPE ${(ref3 = d.$value) != null ? ref3 : 'html'}>${xnl}`;
    }
    if (sigil === '>') {
      return `</${tagname}>${bnl}`;
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
    ref4 = (Object.keys(src)).sort();
    for (i = 0, len = ref4.length; i < len; i++) {
      key = ref4[i];
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
    slash = (sigil === '<') || is_empty_tag ? '' : `</${tagname}>${bnl}`;
    x_sys_key = x_key != null ? `<x-sys-key>${x_key}</x-sys-key>` : '';
    if (atxt === '') {
      return `<${tagname}>${slash}${x_sys_key}`;
    }
    return `<${tagname}${atxt}>${x_sys_key}${slash}`;
  };

}).call(this);

//# sourceMappingURL=html.js.map