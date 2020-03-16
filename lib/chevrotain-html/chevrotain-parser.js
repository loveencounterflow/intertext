(function() {
  'use strict';
  var CND, CstParser, Xml_parser, alert, assign, badge, debug, echo, help, info, jr, log, rpr, t, urge, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'CHEVROTAIN-HTML-PARSER';

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

  ({CstParser} = require('chevrotain'));

  ({
    tokensDictionary: t
  } = require('./chevrotain-lexer'));

  //-----------------------------------------------------------------------------------------------------------
  Xml_parser = class Xml_parser extends CstParser {
    //---------------------------------------------------------------------------------------------------------
    constructor() {
      var $;
      super(t, {
        nodeLocationTracking: 'full'
      });
      $ = this;
      //-------------------------------------------------------------------------------------------------------
      this.RULE('document', () => {
        return this.MANY(() => {
          return this.OR([
            {
              ALT: () => {
                return this.CONSUME(t.o_doctype);
              }
            },
            {
              ALT: () => {
                return this.CONSUME(t.o_xmldecl);
              }
            },
            {
              ALT: () => {
                return this.CONSUME(t.o_pi);
              }
            },
            {
              ALT: () => {
                return this.CONSUME(t.o_cdata);
              }
            },
            {
              ALT: () => {
                return this.CONSUME(t.o_comment);
              }
            },
            {
              ALT: () => {
                return this.CONSUME(t.o_text);
              }
            },
            {
              ALT: () => {
                return this.CONSUME(t.stm_text);
              }
            },
            {
              ALT: () => {
                return this.SUBRULE(this.osntag);
              }
            },
            {
              ALT: () => {
                return this.SUBRULE(this.ctag);
              }
            },
            {
              ALT: () => {
                return this.CONSUME(t.stm_slash2);
              }
            }
          ]);
        });
      });
      //-------------------------------------------------------------------------------------------------------
      this.RULE('osntag', ()/* `<a b=c>`, `<a b=c/>`, or `<a b=c/` */ => {
        this.CONSUME(t.i_open);
        this.CONSUME(t.i_name);
        this.OPTION(() => {
          return this.SUBRULE(this.attributes);
        });
        return this.OR([
          {
            ALT: () => {
              return this.CONSUME(t.i_close);
            }
          },
          {
            ALT: () => {
              return this.CONSUME(t.i_slash_close);
            }
          },
          {
            ALT: () => {
              return this.CONSUME(t.stm_slash1);
            }
          }
        ]);
      });
      //-------------------------------------------------------------------------------------------------------
      this.RULE('ctag', ()/* `</a>` */ => {
        this.CONSUME(t.i_slash_open);
        this.CONSUME(t.i_name);
        return this.CONSUME(t.i_close);
      });
      //-------------------------------------------------------------------------------------------------------
      this.RULE('attributes', () => {
        return this.AT_LEAST_ONE(() => {
          return this.SUBRULE(this.attribute);
        });
      });
      //-------------------------------------------------------------------------------------------------------
      this.RULE('attribute', () => {
        this.CONSUME(t.i_name);
        return this.OPTION(() => {
          this.CONSUME(t.v_equals);
          return this.CONSUME(t.v_value);
        });
      });
      //-------------------------------------------------------------------------------------------------------
      this.performSelfAnalysis();
    }

  };

  //-----------------------------------------------------------------------------------------------------------
  this.parser = new Xml_parser();

  //-----------------------------------------------------------------------------------------------------------
  this.cst_from_token = function(tokenization, parser_start) {
    this.parser.input = tokenization.tokens;
    return this.parser[parser_start]();
  };

  //-----------------------------------------------------------------------------------------------------------
  this.parse = function(tokenization, parser_start) {
    /* NOTE put potential reorganizations of results here */
    var cst, errors;
    cst = this.cst_from_token(tokenization, parser_start);
    errors = this.parser.errors;
    return {cst, errors};
  };

}).call(this);