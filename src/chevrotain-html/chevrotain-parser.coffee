

'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'CHEVROTAIN-HTML-PARSER'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
echo                      = CND.echo.bind CND
#...........................................................................................................
{ assign
  jr }                    = CND
{ CstParser }             = require 'chevrotain'
{ tokensDictionary: t }   = require './chevrotain-lexer'


#-----------------------------------------------------------------------------------------------------------
class Xml_parser extends CstParser

  #---------------------------------------------------------------------------------------------------------
  constructor: ->
    super t, { nodeLocationTracking: 'full', }
    $ = @

    #-------------------------------------------------------------------------------------------------------
    @RULE 'document', =>
      @MANY =>
        @OR [
          { ALT: => @CONSUME t.o_doctype    }
          { ALT: => @CONSUME t.o_xmldecl    }
          { ALT: => @CONSUME t.o_pi         }
          { ALT: => @CONSUME t.o_cdata      }
          { ALT: => @CONSUME t.o_comment    }
          { ALT: => @CONSUME t.o_text       }
          { ALT: => @CONSUME t.stm_text     }
          { ALT: => @SUBRULE @osntag        }
          { ALT: => @SUBRULE @ctag          }
          { ALT: => @CONSUME t.stm_slash2   }
          ]

    #-------------------------------------------------------------------------------------------------------
    @RULE 'osntag', => ### `<a b=c>`, `<a b=c/>`, or `<a b=c/` ###
      @CONSUME t.i_open
      @CONSUME t.i_name
      @OPTION => @SUBRULE @attributes
      @OR [
        { ALT: => @CONSUME t.i_close        }
        { ALT: => @CONSUME t.i_slash_close  }
        { ALT: => @CONSUME t.stm_slash1     }
        ]

    #-------------------------------------------------------------------------------------------------------
    @RULE 'ctag', => ### `</a>` ###
      @CONSUME t.i_slash_open
      @CONSUME t.i_name
      @CONSUME t.i_close

    #-------------------------------------------------------------------------------------------------------
    @RULE 'attributes', =>
      @AT_LEAST_ONE => @SUBRULE @attribute

    #-------------------------------------------------------------------------------------------------------
    @RULE 'attribute', =>
      @CONSUME t.i_name
      @OPTION =>
        @CONSUME t.v_equals
        @CONSUME t.v_value

    #-------------------------------------------------------------------------------------------------------
    this.performSelfAnalysis()

#-----------------------------------------------------------------------------------------------------------
@parser = new Xml_parser()

#-----------------------------------------------------------------------------------------------------------
@cst_from_token = ( tokenization, parser_start ) ->
  @parser.input = tokenization.tokens
  return @parser[ parser_start ]()

#-----------------------------------------------------------------------------------------------------------
@parse = ( tokenization, parser_start ) ->
  ### NOTE put potential reorganizations of results here ###
  cst     = @cst_from_token tokenization, parser_start
  errors  = @parser.errors
  return { cst, errors, }




