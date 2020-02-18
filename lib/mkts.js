(function() {
  'use strict';
  var CND, DATOM, HTML, HtmlParser, alert, assign, badge, debug, echo, help, info, isa, jr, lets, log, new_datom, rpr, select, type_of, types, urge, validate, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/MKTS';

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

  assign = Object.assign;

  HTML = null;

  //-----------------------------------------------------------------------------------------------------------
  this.html_from_datoms = (...P) => {
    return (HTML != null ? HTML : HTML = (require('..')).HTML).html_from_datoms(...P);
  };

  this.$html_from_datoms = (...P) => {
    return (HTML != null ? HTML : HTML = (require('..')).HTML).$html_from_datoms(...P);
  };

  //===========================================================================================================
  // PARSING
  //-----------------------------------------------------------------------------------------------------------
  this._find_next_tag = function(text, prv_idx = 0) {
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
  this._analyze_compact_tag_syntax = function(datoms) {
    var compact_tagname, d, i, idx, len, p, sigil;
    /*
    compact syntax for HTMLish tags:

    `<div#c432.foo.bar>...</div>` => `<div id=c432 class='foo bar'>...</div>`
    `<p.noindent>...</p>` => `<p class=noindent>...</p>`

    positional arguments (not yet implemented):
    `<columns=2>` => `<columns count=2/>` => `<columns count=2></columns>` ?=> `<mkts-columns count=2></mkts-columns>`
    `<multiply =2 =3>` (???)

    NB Svelte uses capitalized names, allows self-closing tags(!): `<Mytag/>`

    */
    if (HTML == null) {
      HTML = (require('..')).HTML;
    }
    for (idx = i = 0, len = datoms.length; i < len; idx = ++i) {
      d = datoms[idx];
      sigil = d.$key[0];
      compact_tagname = d.$key.slice(1);
      p = HTML._parse_compact_tagname(compact_tagname);
      if ((p.tagname === compact_tagname) && (p.id == null) && (p.class == null)) {
        continue;
      }
      datoms[idx] = lets(d, function(d) {
        d.$key = `${sigil}${p.tagname}`;
        if (p.id != null) {
          d.id = p.id;
        }
        if (p.class != null) {
          return d.class = p.class;
        }
      });
    }
    return datoms;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.datoms_from_html = function(text) {
    var R, d, error, idx_0, idx_1, prv_idx, prv_idx_1, source, tags;
    R = [];
    prv_idx = 0;
    prv_idx_1 = -1;
    if (HTML == null) {
      HTML = (require('..')).HTML;
    }
    while (true) {
      try {
        //.......................................................................................................
        //.........................................................................................................
        [idx_0, idx_1] = this._find_next_tag(text, prv_idx);
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
          text: text.slice(prv_idx_1 + 1, idx_0).toString()
        }));
      }
      if (idx_0 == null) {
        break;
      }
      tags = this._analyze_compact_tag_syntax(HTML.datoms_from_html(text.slice(idx_0, +idx_1 + 1 || 9e9)));
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
        text: text.slice(prv_idx_1 + 1).toString()
      }));
    }
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.$datoms_from_html = function() {
    var $;
    ({$} = (require('steampipes')).export());
    return $((buffer_or_text, send) => {
      var d, i, len, ref;
      ref = this.datoms_from_html(buffer_or_text);
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
