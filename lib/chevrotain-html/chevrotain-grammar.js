(function() {
  'use strict';
  var CND, LEXER, PARSER, alert, assign, badge, debug, echo, freeze, help, info, isa, jr, lets, log, rpr, urge, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'CHEVROTAIN-HTML-GRAMMAR';

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

  ({lets, freeze} = (new (require('datom')).Datom({
    dirty: false
  })).export());

  ({isa} = require('../types'));

  //-----------------------------------------------------------------------------------------------------------
  this.distill_token = function(token) {
    var name, ref, ref1, start, stop, text;
    text = token.image;
    start = token.startOffset;
    stop = token.endOffset + 1;
    name = (ref = (ref1 = token.tokenType) != null ? ref1.name : void 0) != null ? ref : '???';
    return freeze({
      $key: '^token',
      name,
      text,
      start,
      stop
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  this._errors_from_parsification = function(parsification) {
    var R, code, context, error, i, j, len, len1, length, message, name, not_given, offset, ref, ref1, resyncedTokens, source, start, stop, text, token;
    not_given = function(x) {
      return (x === '') || (x == null) || (isa.nan(x));
    };
    ({source} = parsification);
    R = [];
    ref = parsification.errors.lexer;
    for (i = 0, len = ref.length; i < len; i++) {
      error = ref[i];
      ({offset, length, message} = error);
      start = offset;
      stop = offset + length;
      text = parsification.source.slice(start, stop);
      if (message.startsWith('extraneous')) {
        code = 'extraneous';
      } else {
        code = 'other';
      }
      R.push({
        $key: '^error',
        code,
        origin: 'lexer',
        message,
        text,
        start,
        stop
      });
    }
    ref1 = parsification.errors.parser;
    for (j = 0, len1 = ref1.length; j < len1; j++) {
      error = ref1[j];
      ({name, message, token, resyncedTokens, context} = error);
      start = error.token.startOffset;
      stop = error.token.endOffset;
      text = error.token.image;
      switch (name) {
        case 'NotAllInputParsedException':
          code = 'extraneous';
          break;
        case 'MismatchedTokenException':
          code = 'mismatch';
          break;
        case 'NoViableAltException':
          code = 'missing';
          break;
        default:
          code = 'other';
      }
      if (not_given(start)) {
        start = error.previousToken.startOffset;
      }
      if (not_given(stop)) {
        stop = error.previousToken.endOffset;
      }
      if (not_given(text)) {
        text = error.previousToken.image;
      }
      if (not_given(start)) {
        start = 0;
      }
      if (not_given(stop)) {
        stop = parsification.source.length;
      }
      if (not_given(text)) {
        text = parsification.source.slice(start, stop);
      }
      R.push({
        $key: '^error',
        code,
        chvtname: name,
        origin: 'parser',
        message,
        text,
        start,
        stop
      });
    }
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.extract_tokens = function(parsification) {
    /* TAINT adapt errors */
    var R, cst, errors, report, source, tokens;
    ({source, cst} = parsification);
    errors = this._errors_from_parsification(parsification);
    report = {
      '$key': '^report',
      source,
      errors
    };
    tokens = this._extract_tokens(source, cst);
    R = [report, ...tokens, ...errors];
    /* sort errors, tokens consistently */
    R.sort(function(a, b) {
      return a.start - b.start;
    });
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this._extract_tokens = function*(source, tree, level = 0) {
    var atr, atrs, d, i, indent, j, k, key, len, len1, name, ref, ref1, ref2, ref3, ref4, ref5, start, stop, text, token, tokens, type, v;
    if (tree == null) {
      /* terminals: ["image","startOffset","endOffset",...
       non-terminals: ["name","children","location"] */
      // whisper jr ( k for k of tree )
      return null;
    }
    indent = '  '.repeat(level);
    //.........................................................................................................
    if (tree.children == null) {
      switch (type = tree.tokenType.name) {
        case 'o_text':
        case 'stm_text':
          yield lets(this.distill_token(tree), function(d) {
            d.$key = '^text';
            return delete d.name;
          });
          break;
        case 'stm_slash2':
          yield lets(this.distill_token(tree), function(d) {
            d.$key = '>tag';
            d.type = 'nctag';
            return delete d.name;
          });
          break;
        case 'o_comment':
          yield lets(this.distill_token(tree), function(d) {
            d.$key = '^COMMENT';
            return delete d.name;
          });
          break;
        case 'o_pi':
          yield lets(this.distill_token(tree), function(d) {
            d.$key = '^PI';
            return delete d.name;
          });
          break;
        case 'o_cdata':
          d = this.distill_token(tree);
          start = d.start + 9;
          stop = d.stop - 3;
          text = source.slice(start, stop);
          yield lets(d, function(d) {
            d.$key = '<CDATA';
            delete d.name;
            d.stop = start;
            return d.text = source.slice(d.start, d.stop);
          });
          yield ({
            $key: '^text',
            text,
            start,
            stop
          });
          yield lets(d, function(d) {
            d.$key = '>CDATA';
            delete d.name;
            d.start = stop;
            return d.text = source.slice(d.start, d.stop);
          });
          break;
        default:
          yield this.distill_token(tree);
      }
      return null;
    }
    //.........................................................................................................
    ({start, stop} = this.distill_token(tree.location));
    text = source.slice(start, stop);
    type = (ref = tree.name) != null ? ref : '???';
    switch (type) {
      case 'osntag':
        name = tree.children.i_name[0].image;
        if (tree.children.i_close != null) {
          type = 'otag';
        } else if (tree.children.i_slash_close != null) {
          type = 'stag';
        } else if (tree.children.stm_slash1 != null) {
          type = 'ntag';
        }
        if (tree.children.attributes != null) {
          atrs = {};
          ref1 = tree.children.attributes[0].children.attribute;
          // debug '^33412-1^', jr tree.children.attributes
          // debug '^33412-2^', jr tree.children.attributes[ 0 ]
          // debug '^33412-3^', jr tree.children.attributes[ 0 ].children.attribute
          for (i = 0, len = ref1.length; i < len; i++) {
            atr = ref1[i];
            k = atr.children.i_name[0].image;
            v = (ref2 = (ref3 = atr.children.v_value) != null ? (ref4 = ref3[0]) != null ? ref4.image : void 0 : void 0) != null ? ref2 : true;
            atrs[k] = v;
          }
          yield ({
            $key: '<tag',
            name,
            type,
            text,
            start,
            stop,
            atrs
          });
        } else {
          yield ({
            $key: '<tag',
            name,
            type,
            text,
            start,
            stop
          });
        }
        break;
      case 'ctag':
        name = tree.children.i_name[0].image;
        yield ({
          $key: '>tag',
          name,
          type,
          text,
          start,
          stop
        });
        break;
      default:
        if (type !== 'document') {
          yield ({
            $key: "^unknown",
            type,
            text,
            start,
            stop
          });
        }
        ref5 = tree.children;
        for (key in ref5) {
          tokens = ref5[key];
          for (j = 0, len1 = tokens.length; j < len1; j++) {
            token = tokens[j];
            yield* this._extract_tokens(source, token, level + 1);
          }
        }
    }
    return null;
  };

}).call(this);
