(function() {
  'use strict';
  var CND, Cupofjoe, DATOM, alert, assign, badge, compact_tagname_re, debug, echo, excluded_content_parts, freeze, help, info, is_frozen, isa, jr, lets, log, new_datom, rpr, select, thaw, type_of, types, urge, validate, warn, whisper,
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

  compact_tagname_re = /(?<prefix>[^\s.:#]+(?=:))|(?<id>(?<=#)[^\s.:#]+)|(?<class>(?<=\.)[^\s.:#]+)|(?<name>[^\s.:#]+)/ug;

  //-----------------------------------------------------------------------------------------------------------
  this.parse_compact_tagname = function(compact_tagname, strict = false) {
    var R, groups, k, ref, target, v, y;
    R = {};
    ref = compact_tagname.matchAll(compact_tagname_re);
    for (y of ref) {
      ({groups} = y);
      for (k in groups) {
        v = groups[k];
        if ((v == null) || (v === '')) {
          continue;
        }
        if (k === 'class') {
          (R.class != null ? R.class : R.class = []).push(v);
        } else {
          if ((target = R[k]) != null) {
            throw new Error(`^intertext/htmlish/parse_compact_tagname@1^ found duplicate values for ${rpr(k)}: ${rpr(target)}, ${rpr(v)}`);
          }
          R[k] = v;
        }
      }
    }
    if (strict && (R.name == null)) {
      throw new Error(`^intertext/htmlish/parse_compact_tagname@2^ illegal compact tag syntax in ${rpr(compact_tagname)}`);
    }
    return R;
  };

  //===========================================================================================================

  // #-----------------------------------------------------------------------------------------------------------
  // @_escape_text = ( x ) ->
  //   R           = x
  //   R           = R.replace /&/g,   '&amp;'
  //   R           = R.replace /</g,   '&lt;'
  //   R           = R.replace />/g,   '&gt;'
  //   return R

  // #-----------------------------------------------------------------------------------------------------------
  // @_as_attribute_literal = ( x ) ->
  //   R           = if isa.text x then x else JSON.stringify x
  //   must_quote  = not isa._intertext_html_naked_attribute_text R
  //   R           = @_escape_text R
  //   R           = R.replace /'/g,   '&#39;'
  //   R           = R.replace /\n/g,  '&#10;'
  //   R           = "'" + R + "'" if must_quote
  //   return R
  /*
  #-----------------------------------------------------------------------------------------------------------
  @_parse_compact_tagname = ( compact_tagname ) ->
    { tagname
      attributes }  = ( compact_tagname.match /^(?<tagname>[^#.]*)(?<attributes>.*)$/ ).groups
    R               = {}
    R.tagname       = tagname unless tagname is ''
    return R if attributes is ''
    for attribute in attributes.split /([#.][^#.]*)/
      continue if attribute is ''
      avalue = attribute[ 1 .. ]
      unless avalue.length > 0
        throw new Error "^intertext/_parse_compact_tagname@1234^ illegal compact tag syntax in #{rpr compact_tagname}"
      if attribute[ 0 ] is '#' then R.id = avalue
      else                          ( R.class ?= [] ).push avalue
    R.class = R.class.join ' ' if R.class?
    return R

  #-----------------------------------------------------------------------------------------------------------
  @tag = ( compact_tagname, attributes, content... ) ->
    { start, content, end, } = @_tag compact_tagname, attributes, content
    return [ start, content..., end, ] if end?
    return [ start, content..., ]

  #-----------------------------------------------------------------------------------------------------------
  @_tag = ( compact_tagname, attributes, content, settings ) ->
    validate.nonempty_text compact_tagname
    { tagname, id, class: clasz, }  = @_parse_compact_tagname compact_tagname
    validate.intertext_html_tagname tagname
    use_attributes                  = false
    processed_content               = []
    call_functions                  = settings?.call_functions ? true
    content                         = thaw content if ( Object.isFrozen content )
    #.........................................................................................................
    if attributes?
      if isa.object attributes then use_attributes = true
      else                          content.unshift attributes
    #.........................................................................................................
    if content.length is 0
      sigil   = '^'
      end_tag = null
    #.........................................................................................................
    else
      sigil   = '<'
      end_tag = new_datom ">#{tagname}"
      for part in content
        continue if part in excluded_content_parts
        switch type_of part
          when 'text'     then  processed_content.push new_datom '^text', { text: part, }
          when 'function'
            if call_functions then  processed_content.push x unless ( x = part() ) in excluded_content_parts
            else                    processed_content.push part
          else                  processed_content.push part
    #.........................................................................................................
    if id? or clasz?
      idclass         = {}
      idclass.id      = id    if id?
      idclass.class   = clasz if clasz?
      if use_attributes
        attributes = assign idclass, attributes
      else
        use_attributes  = true
        attributes      = idclass
    #.........................................................................................................
    if use_attributes then  start_tag = new_datom "#{sigil}#{tagname}", attributes
    else                    start_tag = new_datom "#{sigil}#{tagname}"
    #.........................................................................................................
    processed_content = processed_content.flat Infinity
    return { start: start_tag, content: processed_content, end: end_tag, } if end_tag?
    return { start: start_tag, content: processed_content, }
   */
  //-----------------------------------------------------------------------------------------------------------
  this.html_from_datoms = function(ds, settings) {
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

//# sourceMappingURL=htmlish.js.map