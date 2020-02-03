(function() {
  'use strict';
  var $, $drain, CND, DATOM, FS, INTERTEXT, PATH, SP, alert, assign, badge, cast, debug, help, info, isa, join_path, jr, new_datom, reconstitute_text, rpr, select, type_of, types, urge, validate, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/SLABS';

  debug = CND.get_logger('debug', badge);

  alert = CND.get_logger('alert', badge);

  whisper = CND.get_logger('whisper', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  info = CND.get_logger('info', badge);

  PATH = require('path');

  FS = require('fs');

  ({jr} = CND);

  assign = Object.assign;

  join_path = function(...P) {
    return PATH.resolve(PATH.join(...P));
  };

  //...........................................................................................................
  types = require('./types');

  ({isa, validate, cast, type_of} = types);

  SP = require('steampipes');

  ({$, $drain} = SP.export());

  DATOM = require('datom');

  ({new_datom, select} = DATOM.export());

  INTERTEXT = require('..');

  //-----------------------------------------------------------------------------------------------------------
  this.demo_hyphenation = function() {
    var htext, i, len, text, texts;
    texts = ["typesetting", "supercalifragilistic", "phototypesetter", "hairstylist", "gargantuan", "the lopsided honeybadger"];
    for (i = 0, len = texts.length; i < len; i++) {
      text = texts[i];
      htext = hyphenate(text);
      htext = htext.replace(/\u00ad/g, '-');
      info(htext);
    }
    return null;
  };

  /*

  'Slab': the part of a word that is separated from others by breakpoints

  > The addressable unit of memory on the NCR 315 series is a "slab", short for "syllable", consisting of 12
  > data bits and a parity bit. Its size falls between a byte and a typical word (hence the name, 'syllable').
  > A slab may contain three digits (with at sign, comma, space, ampersand, point, and minus treated as
  > digits) or two alphabetic characters of six bits each.—[Wikipedia, "NCR
  > 315"](https://en.wikipedia.org/wiki/NCR_315)

  */
  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  reconstitute_text = function(slab) {
    var R;
    R = slab.txt;
    if (slab.rhs === 'shy') {
      R += '-';
    } else if (slab.rhs === 'spc') {
      R += ' ';
    }
    return R;
  };

  this.slabs_from_paragraph = function(text) {
    /* TAINT avoid to instantiate new parser for each paragraph */
    /* TAINT consider to use pipestreaming instead of looping */
    var R, closer, ctx_stack, d, element, i, len, opener, parse_html, ref, ref1, slab, slabs;
    parse_html = SP.HTML.new_onepiece_parser();
    ctx_stack = [];
    R = [];
    ref = parse_html(text);
    for (i = 0, len = ref.length; i < len; i++) {
      d = ref[i];
      /* TAINT should check for matching tags */
      /* TAINT must also store HTML attributes */
      if (select(d, '<')) {
        ctx_stack.push(d.$key.slice(1));
      } else if (select(d, '>')) {
        ctx_stack.pop();
      }
      //.......................................................................................................
      if ((select(d, '<')) && ((ref1 = d.is_block) != null ? ref1 : false)) {
        info(CND.white('————————————————————————————————————— ' + d.$key));
        continue;
      }
      //.......................................................................................................
      if (select(d, '^text')) {
        text = d.text.replace(/\n/g, ' ');
        slabs = this.slabs_from_text(text);
        R.push(slabs);
        // for slab in slabs.$value
        //   rhs = if slab.rhs? then slab.rhs else null
        opener = "<slug>" + ((function() {
          var j, len1, results;
          results = [];
          for (j = 0, len1 = ctx_stack.length; j < len1; j++) {
            element = ctx_stack[j];
            results.push(`<${element}>`);
          }
          return results;
        })()).join('');
        closer = "</slug>";
        info(CND.yellow(opener), ((function() {
          var j, len1, ref2, results;
          ref2 = slabs.$value;
          results = [];
          for (j = 0, len1 = ref2.length; j < len1; j++) {
            slab = ref2[j];
            results.push(CND.blue(reconstitute_text(slab)));
          }
          return results;
        })()).join(CND.grey('|')), CND.yellow(closer));
        continue;
      }
      whisper(d.$key);
    }
    //.........................................................................................................
    return new_datom('^slab-blocks', R);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.slabs_from_text = function(text) {
    /* TAINT benchmark against https://github.com/hfour/linebreak-ts */
    var LineBreaker, breaker, last_codeunit, lbo, prv_position, shy, slab, slabs, txt;
    shy = INTERTEXT.HYPH.soft_hyphen_chr;
    text = hyphenate(text);
    LineBreaker = require('linebreak');
    breaker = new LineBreaker(text);
    prv_position = 0;
    slabs = [];
    /* LBO: line break opportunity */
    while ((lbo = breaker.nextBreak()) != null) {
      txt = text.slice(prv_position, lbo.position);
      prv_position = lbo.position;
      last_codeunit = txt[txt.length - 1];
      slab = {};
      if (last_codeunit === shy) {
        slab.rhs = 'shy';
        txt = txt.slice(0, txt.length - 1);
      } else if (last_codeunit === '\u0020') {
        /* TAINT in the future, we might want to consider other breaking (fixed or variable) spaces */
        slab.rhs = 'spc';
        txt = txt.slice(0, txt.length - 1);
      }
      // debug '^876^', jr txt
      slab.txt = txt;
      slabs.push(slab);
    }
    return new_datom('^slabs', slabs);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.demo_linebreak = function() {
    var LineBreaker, breaker, keep_hyphen, last, lbo, nbsp, rq, shy, text, word, xhy;
    LineBreaker = require('linebreak');
    keep_hyphen = String.fromCodePoint(0x2011);
    shy = String.fromCodePoint(0x00ad);
    nbsp = String.fromCodePoint(0x00a0);
    text = `Super-cali${keep_hyphen}frag${shy}i${shy}lis${shy}tic\nis a won${shy}der${shy}ful word我很喜歡這個單字。`;
    breaker = new LineBreaker(text);
    last = 0;
    /* LBO: line break opportunity */
    while ((lbo = breaker.nextBreak()) != null) {
      // get the string between the last break and this one
      word = text.slice(last, lbo.position);
      xhy = isa.interplot_shy(word) ? CND.gold('-') : '';
      rq = lbo.required ? '!' : ' ';
      word = word.trimEnd();
      info(rq, jr(word), xhy);
      last = lbo.position;
    }
    return null;
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      var html, text;
      // @demo_linebreak()
      // @demo_hyphenation()
      html = `<p><strong>Letterpress</strong> printing is a <em>technique of relief printing using a printing
press,</em> a process by which many copies are produced by <em>repeated direct impression of an inked,
raised surface</em> against sheets or a continuous roll of paper.</p> <p>A worker composes and locks
movable type into the ‘bed’ or ‘chase’ of a press, inks it, and presses paper against it to transfer the
ink from the type which creates an impression on the paper.</p>`;
      text = `Letterpress printing is a technique of relief printing using a printing press.`;
      html = `<p>${text}</p>`;
      // urge @slabs_from_paragraph html
      return urge(this.slabs_from_text(text));
    })();
  }

}).call(this);
