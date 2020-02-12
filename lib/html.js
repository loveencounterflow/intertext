(function() {
  'use strict';
  var CND, DATOM, HtmlParser, alert, assign, badge, debug, echo, excluded_content_parts, freeze, help, info, is_frozen, isa, jr, lets, log, new_datom, rpr, select, thaw, type_of, types, urge, validate, warn, whisper,
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
  HtmlParser = require('atlas-html-stream');

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
  this.parse_compact_tagname = function(compact_tagname) {
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
        throw new Error(`^intertext/parse_compact_tagname@1234^ illegal compact tag syntax in ${rpr(compact_tagname)}`);
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
  this.dhtml = function(compact_tagname, attributes, ...content) {
    var end, start;
    ({start, content, end} = this._dhtml(compact_tagname, attributes, content));
    if (end != null) {
      return [start, ...content, end];
    }
    return [start, ...content];
  };

  //-----------------------------------------------------------------------------------------------------------
  this._dhtml = function(compact_tagname, attributes, content, settings) {
    var call_functions, clasz, end_tag, i, id, idclass, len, part, processed_content, ref, ref1, sigil, start_tag, tagname, use_attributes, x;
    validate.nonempty_text(compact_tagname);
    ({
      tagname,
      id,
      class: clasz
    } = this.parse_compact_tagname(compact_tagname));
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

  // #-----------------------------------------------------------------------------------------------------------
  // @new_dhtml_writer = ->
  //   dhtml = ( compact_tagname, attributes, content... ) =>
  //     # XXX = @_dhtml compact_tagname, attributes, content, { call_functions: false, }
  //     dhtml.collector.push new_datom '~ff', { $value: [ compact_tagname, attributes, content, ], }
  //     return null
  //   #.........................................................................................................
  //   dhtml.text = ( text ) =>
  //     dhtml.collector.push new_datom '^text', { text, }
  //     return null
  //   #.........................................................................................................
  //   dhtml.as_html   = =>
  //   dhtml.expand = =>
  //     R                       = []
  //     xxx                     = dhtml.collector[ .. ]
  //     dhtml.collector.length  = 0
  //     debug '^2223^', 'xxx', CND.blue xxx
  //     for d in xxx
  //       if select d, '~ff'
  //         # R[ R.length .. ] = @_dhtml d.$value...
  //         help '^7776^', "_dhtml call:    ", @_dhtml d.$value...
  //         urge '^7776^', "dhtml.collector:", dhtml.collector
  //       else
  //         R.push d
  //     # debug '^2223^', CND.yellow xxx
  //     # debug '^2223^', CND.orange dhtml.collector
  //     # debug '^2223^', CND.lime R
  //     # { collector, } =  dhtml
  //     # dhtml.collector = []
  //     @datoms_as_html dhtml.collector
  //     dhtml.collector.length = 0
  //   #.........................................................................................................
  //   dhtml.collector = []
  //   return dhtml

  //-----------------------------------------------------------------------------------------------------------
  this.datoms_as_html = function(ds) {
    var d;
    validate.list(ds);
    return ((function() {
      var i, len, results;
      results = [];
      for (i = 0, len = ds.length; i < len; i++) {
        d = ds[i];
        results.push(this.datom_as_html(d));
      }
      return results;
    }).call(this)).join('');
  };

  //-----------------------------------------------------------------------------------------------------------
  this.datom_as_html = function(d) {
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

  //-----------------------------------------------------------------------------------------------------------
  this.$datom_as_html = function() {
    var $;
    ({$} = (require('steampipes')).export());
    return $((d, send) => {
      send(this.datom_as_html(d));
      return null;
    });
  };

  //===========================================================================================================
  // HTML SPECIALS
  //-----------------------------------------------------------------------------------------------------------
  this.raw = function(text) {
    var arity;
    if ((arity = arguments.length) !== 1) {
      throw new Error(`^intertext/raw@1801^ expected 1 argument, got ${arity}`);
    }
    validate.text(text);
    return [new_datom('^raw', {text})];
  };

  //-----------------------------------------------------------------------------------------------------------
  this.text = function(text) {
    var arity;
    if ((arity = arguments.length) !== 1) {
      throw new Error(`^intertext/text@2368^ expected 1 argument, got ${arity}`);
    }
    validate.text(text);
    return [new_datom('^text', {text})];
  };

  //-----------------------------------------------------------------------------------------------------------
  this.css = function(href) {
    /* Creates a list with one datom representing a stylesheet link: `<link rel=stylesheet
     href="../reset.css"/>`
     */
    var arity;
    if ((arity = arguments.length) !== 1) {
      throw new Error(`^intertext/css@2935^ expected 1 argument, got ${arity}`);
    }
    validate.nonempty_text(href);
    return [
      new_datom('^link',
      {
        rel: 'stylesheet',
        href
      })
    ];
  };

  //-----------------------------------------------------------------------------------------------------------
  this.script = function(x) {
    var arity, type;
    if ((arity = arguments.length) !== 1) {
      throw new Error(`^intertext/script@3502^ expected 1 argument, got ${arity}`);
    }
    switch (type = type_of(x)) {
      case 'text':
        return this._script_src(x);
      case 'function':
        return this._script_literal(x);
    }
    throw new Error(`^intertext/script@4069^ expected a text or a function, got a ${type}`);
  };

  //-----------------------------------------------------------------------------------------------------------
  this._script_src = function(src) {
    /* Creates a list with one datom representing a script tag: `<script type="text/javascript"
     src="../jquery-3.4.1.js">`
     */
    validate.nonempty_text(src);
    return [new_datom('^script', {src})];
  };

  //-----------------------------------------------------------------------------------------------------------
  this._script_literal = function(f) {
    /* Creates a list with three datoms representing a script tag with embedded JavaScript source text:
     ```
     <script type="text/javascript">
       var a, b;
       a = 42;
       b = a * 2;
       </script>`
     */
    return [new_datom('<script'), this._as_iife(f), new_datom('>script')];
  };

  //-----------------------------------------------------------------------------------------------------------
  this._as_iife = function(f) {
    var R;
    R = `(${f.toString()})();`;
    return (this.raw(R))[0];
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

  //###########################################################################################################
  if (module === require.main) {
    (() => { // await do =>
      return help('ok');
    })();
  }

  /*

--------------------------------------------------------------------------------
from https://github.com/goodeggs/teacup/blob/master/src/teacup.coffee
elements =
 * Valid HTML 5 elements requiring a closing tag.
 * Note: the `var` element is out for obvious reasons, please use `tag 'var'`.
  regular: 'a abbr address article aside audio b bdi bdo blockquote body button
 canvas caption cite code colgroup datalist dd del details dfn div dl dt em
 fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
 html i iframe ins kbd label legend li map mark menu meter nav noscript object
 ol optgroup option output p pre progress q rp rt ruby s samp section
 select small span strong sub summary sup table tbody td textarea tfoot
 th thead time title tr u ul video'

  raw: 'style'

  script: 'script'

 * Valid self-closing HTML 5 elements.
  void: 'area base br col command embed hr img input keygen link meta param
 source track wbr'

  obsolete: 'applet acronym bgsound dir frameset noframes isindex listing
 nextid noembed plaintext rb strike xmp big blink center font marquee multicol
 nobr spacer tt'

  obsolete_void: 'basefont frame'
--------------------------------------------------------------------------------

 * #-----------------------------------------------------------------------------------------------------------
 * @html5_block_level_tagnames = new Set """address article aside blockquote dd details dialog div dl dt
 * fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 header hgroup hr li main nav ol p pre section table
 * td th ul""".split /\s+/

 * #-----------------------------------------------------------------------------------------------------------
 * @_new_datom = ( name, data, text ) ->
 *   return new_datom '^text', { text, } if text?
 *   #.........................................................................................................
 *   is_block = @html5_block_level_tagnames.has name
 *   unless data?
 *     return new_datom '>' + name unless is_block
 *     return new_datom '>' + name, { is_block, }
 *   #.........................................................................................................
 *   has_keys = false
 *   for key, value of data
 *     has_keys    = true
 *     data[ key ] = true if value is ''
 *   #.........................................................................................................
 *   unless has_keys
 *     return new_datom '<' + name unless is_block
 *     return new_datom '<' + name, { is_block, }
 *   #.........................................................................................................
 *   return new_datom '<' + name, { data, } unless is_block
 *   return new_datom '<' + name, { data, is_block, }

#-----------------------------------------------------------------------------------------------------------
 * @_new_parse_method = ( piecemeal ) ->
 *   R       = null
 *   parser  = new HtmlParser { preserveWS: true, }
 *   #.........................................................................................................
 *   parser.on 'data', ( { name, data, text, } ) => R.push @_new_datom name, data, text
 *   parser.on 'error', ( error ) -> throw error
 *   # parser.on 'end', -> R.push new_datom '^stop'
 *   #.........................................................................................................
 *   R = ( html ) =>
 *     R = []
 *     parser.write html
 *     unless piecemeal
 *       parser.flushText()
 *       parser.reset()
 *     return R
 *   #.........................................................................................................
 *   R.flush = -> parser.flushText()
 *   R.reset = -> parser.reset()
 *   return R

#-----------------------------------------------------------------------------------------------------------
class Htmlparser extends Multimix
 * @extend   object_with_class_properties
  @include L

  #---------------------------------------------------------------------------------------------------------
  constructor: ( @settings = null ) ->
    super()

 */

}).call(this);
