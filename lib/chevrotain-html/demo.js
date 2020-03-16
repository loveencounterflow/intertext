(function() {
  'use strict';
  var CND, GRAMMAR, LEXER, PARSER, alert, as_text, assign, badge, debug, echo, freeze, help, info, isa, jr, lets, lft, log, rpr, urge, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'CHEVROTAIN-API';

  log = CND.get_logger('plain', badge);

  info = CND.get_logger('info', badge);

  whisper = CND.get_logger('whisper', badge);

  alert = CND.get_logger('alert', badge);

  debug = CND.get_logger('debug', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  echo = CND.echo.bind(CND);

  //...........................................................................................................
  ({assign, jr} = CND);

  LEXER = require('./chevrotain-lexer');

  PARSER = require('./chevrotain-parser');

  GRAMMAR = require('./chevrotain-grammar');

  ({lets, freeze} = (new (require('datom')).Datom({
    dirty: false
  })).export());

  ({isa} = require('../types'));

  //-----------------------------------------------------------------------------------------------------------
  this.parse = function(html, settings) {
    var R, color, defaults, i, len, parsification, ref, token, tokenization, tokens;
    echo(CND.white(CND.reverse(CND.bold((jr(html)).padEnd(108, ' ')))));
    defaults = {
      lexer_mode: 'outside_mode',
      parser_start: 'document'
    };
    settings = {...defaults, ...settings};
    tokenization = LEXER.tokenize(html, settings.lexer_mode);
    this.show_tokens(html, tokenization);
    parsification = PARSER.parse(tokenization, settings.parser_start);
    R = {
      source: html,
      cst: parsification.cst,
      lexer_mode: settings.lexer_mode,
      parser_start: settings.parser_start,
      errors: {
        lexer: tokenization.errors,
        parser: parsification.errors
      }
    };
    this.show_tree(R);
    ref = (tokens = GRAMMAR.extract_tokens(R));
    for (i = 0, len = ref.length; i < len; i++) {
      token = ref[i];
      if (token.$stamped) {
        color = CND.grey;
      } else if (token.$key === '^unknown') {
        color = CND.red;
      } else if (token.$key === '^text') {
        color = CND.white;
      } else if (token.$key === '^error') {
        color = function(...P) {
          return CND.red(CND.reverse(CND.bold(...P)));
        };
      } else {
        color = CND.orange;
      }
      echo(color(jr(token)));
    }
    this.show_condensed_tokens(tokens);
    echo(CND.grey(CND.reverse(CND.bold((jr(html)).padEnd(108, ' ')))));
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.show_tree = function(parsification) {
    var cst, error, error_count, errors, i, j, len, len1, ref, ref1, source;
    ({source, cst, errors} = parsification);
    this._show_tree(source, cst);
    error_count = errors.lexer.length + errors.parser.length;
    if (error_count > 0) {
      ref = errors.lexer;
      for (i = 0, len = ref.length; i < len; i++) {
        error = ref[i];
        warn('lexer:', jr(error));
      }
      ref1 = errors.parser;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        error = ref1[j];
        warn('parser:', jr(error));
      }
    }
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  lft = function(x) {
    return x.toString().padEnd(15, ' ');
  };

  this._show_tree = function(source, tree, level = 0) {
    var i, indent, key, len, name, ref, start, stop, text, token, tokens;
    if (tree == null) {
      /* terminals: ["image","startOffset","endOffset",...
       non-terminals: ["name","children","location"] */
      // whisper jr ( k for k of tree )
      return null;
    }
    indent = '  '.repeat(level);
    //.........................................................................................................
    if (tree.children == null) {
      ({name, start, stop, text} = GRAMMAR.distill_token(tree));
      echo(`${indent}${CND.blue(lft(name))} ${CND.grey(lft(jr([start, stop])))} ${CND.yellow(jr(text))}`);
      return null;
    }
    //.........................................................................................................
    ({start, stop} = GRAMMAR.distill_token(tree.location));
    text = source.slice(start, stop);
    echo(`${indent}${CND.lime(lft(tree.name))} ${CND.grey(lft(jr([start, stop])))} ${CND.yellow(jr(text))}`);
    ref = tree.children;
    for (key in ref) {
      tokens = ref[key];
      for (i = 0, len = tokens.length; i < len; i++) {
        token = tokens[i];
        this._show_tree(source, token, level + 1);
      }
    }
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.show_tokens = function(source, tokenization) {
    var i, len, token, tokens;
    tokens = [...tokenization.tokens].sort(function(a, b) {
      return a.startOffset - b.startOffset;
    });
    for (i = 0, len = tokens.length; i < len; i++) {
      token = tokens[i];
      echo(CND.blue(jr(GRAMMAR.distill_token(token))));
    }
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  as_text = function(x) {
    if (isa.object(x)) {
      return jr(x);
    }
    if (isa.list(x)) {
      return jr(x);
    }
    return x.toString();
  };

  //-----------------------------------------------------------------------------------------------------------
  this.condense_token = function(token) {
    var k, keys, values;
    keys = (Object.keys(token)).sort();
    keys = keys.filter(function(x) {
      return x !== 'message';
    });
    values = (function() {
      var i, len, results;
      results = [];
      for (i = 0, len = keys.length; i < len; i++) {
        k = keys[i];
        results.push(as_text(token[k]));
      }
      return results;
    })();
    return values.join('-');
  };

  //-----------------------------------------------------------------------------------------------------------
  this.condense_tokens = function(tokens) {
    var t;
    return ((function() {
      var i, len, results;
      results = [];
      for (i = 0, len = tokens.length; i < len; i++) {
        t = tokens[i];
        if (t.$key !== '^report') {
          results.push(this.condense_token(t));
        }
      }
      return results;
    }).call(this)).join('#');
  };

  //-----------------------------------------------------------------------------------------------------------
  this.show_condensed_tokens = function(tokens) {
    var i, len, token;
    for (i = 0, len = tokens.length; i < len; i++) {
      token = tokens[i];
      help(this.condense_token(token));
    }
    info(this.condense_tokens(tokens));
    return null;
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      this.parse(`<a>before<tag>text</tag>after</a>`);
      this.parse(`before<py/ma3ke4dang1/<oyaji/馬克當/<a><b/></c></d>`);
      this.parse(`before <![CDATA[\none\ntwo\n]]>after`);
      this.parse(`before <![CDATA[x]]>after`);
      this.parse(`before <![CDATA[x]]>`);
      this.parse(`before <![CDATA[]]>`);
      this.parse(`<!DOCTYPE html>`);
      this.parse(`<?xml something something?>`);
      this.parse(`<?xml something something>`);
      this.parse(`<?dodat blah?>`);
      this.parse(`before <otag a1=41 a2=42>after`);
      this.parse(`before <ntag a1=41 a2=42/stm_text/ after`);
      this.parse(`before <ntag a1=v1 a2=v2/stm_text/ after`);
      this.parse(`before <otag a1=v1 a2=v2>after`);
      this.parse(`<br><tag a1 a2=v2 a3 = v3>some text</tag>`);
      this.parse(`<br><tag a1 a2=v2 p3:a3 = v3>some text</tag>`);
      this.parse(`<br><tag#c5 a1 a2=v2 p3:a3 = v3>some text</tag>`);
      this.parse(`<A></B>`);
      this.parse(`<STAG/>`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`</CTAG>`, {
        lexer_mode: 'outside_mode',
        parser_start: 'ctag'
      });
      this.parse(`<NTAG/`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`<a><!-- COMMENT HERE --><b>`);
      echo(CND.blue(CND.reverse('  /'.repeat(36))));
      echo(CND.blue(CND.reverse(' / '.repeat(36))));
      echo(CND.blue(CND.reverse('/  '.repeat(36))));
      this.parse(`<UNFINISHED`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`<?=)(//&%%$§$§"!`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`<>`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`<!>`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`<![CDATA[`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`>`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`< =`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`<a b= >`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`foo bar<a b= >`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`foo bar<c><a b= >`, {
        lexer_mode: 'outside_mode',
        parser_start: 'osntag'
      });
      this.parse(`foo bar<c><a b= >`);
      this.parse("< >");
      this.parse("< x >");
      this.parse("<>");
      this.parse("<");
      this.parse("<tag");
      this.parse("if <math> a > b </math> then");
      this.parse("if <math> a < b </math> then");
      this.parse(">");
      this.parse("&");
      this.parse("&amp;");
      this.parse("<tag a='<'>");
      this.parse(`BEFORE <NTAG/STM_TEXT/ AFTER`);
      this.parse(`bare value: <t a=v>`);
      this.parse(`bare value: <t a=v'w>`);
      this.parse(`bare value: <t a=v"w>`);
      this.parse(`squot value: <t a='v'>`);
      this.parse(`dquot value: <t a="v">`);
      this.parse(`squot value: <t a='"v"'>`);
      return this.parse(`dquot value: <t a="'v'">`);
    })();
  }

  /*

vocabulary:

  from lexer:
    ^raw    { ..., }
    ^error { code: 'extraneous', message, ... }
    ^error { code: 'missing', message, ... }

  public:
    <document { start, }
    >document { stop,  }
    ^otag     { name, a,  start, stop, } for tags like `<a b=c>`
    ^ctag     { name,     start, stop, } for tags like `</a>`
    ^stag     { name,     start, stop, } for tags like `<a b=c/>`
    ^ntag     { name,     start, stop, } for opening part in NET tags like `<a b=c/d/`
    ^ztag     { name,     start, stop, } for closing part (the slash) in NET tags like `<a b=c/d/`
    ^text     { text,     start, stop, }
    <CDATA    { text,     start, stop, }
    >CDATA    { text,     start, stop, }
    ^COMMENT  { text,     start, stop, }

'<CDATA'
'>CDATA'
'^COMMENT'
'^DOCTYPE'
'^PI'
'^report'
'^error'
'^text'
'<tag'
'>tag'
'^text'
'^token'

*/

}).call(this);
