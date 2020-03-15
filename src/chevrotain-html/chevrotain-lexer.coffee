
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'CHEVROTAIN-HTML-LEXER'
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
{ freeze, }               = Object
{ createToken: CHVRTN_create_token, Lexer, } = require 'chevrotain'


#===========================================================================================================
# A little mini DSL for easier lexer definition.
#-----------------------------------------------------------------------------------------------------------
@tokensDictionary   = tokensDictionary = {}

#-----------------------------------------------------------------------------------------------------------
tok = ( name, pattern, settings ) ->
  settings      = { name, pattern, settings..., }
  if ( switch_mode = settings.switch_mode )?
    delete settings.switch_mode
    settings.pop_mode   = true
    settings.push_mode  = switch_mode
  newTokenType                      = CHVRTN_create_token settings
  tokensDictionary[ settings.name ] = newTokenType
  return newTokenType

#-----------------------------------------------------------------------------------------------------------
o_comment       = tok 'o_comment',        /<!--[\s\S]*?-->/,              { line_breaks: true,            }
o_cdata         = tok 'o_cdata',          /<!\[CDATA\[[\s\S]*?]]>/
o_doctype       = tok 'o_doctype',        /<!DOCTYPE\s+[^>]*>/
o_xmldecl       = tok 'o_xmldecl',        /<\?xml\s+[\s\S]*?\?>/
o_pi            = tok 'o_pi',             /<\?[\s\S]*?\?>/
i_slash_open    = tok 'i_slash_open',     /<\//,                          { push_mode: "inside_mode",     }
i_open          = tok 'i_open',           /</,                            { push_mode: "inside_mode",     }
o_text          = tok 'o_text',           /[^<]+/
i_close         = tok 'i_close',          />/,                            { pop_mode: true,               }
i_special_close = tok 'i_special_close',  /\?>/,                          { pop_mode: true,               }
i_slash_close   = tok 'i_slash_close',    /\/>/,                          { pop_mode: true,               }
stm_slash1      = tok 'stm_slash1',       /\/(?!>)/,                      { push_mode: 'slashtext_mode',  }
stm_slash2      = tok 'stm_slash2',       /\//,                           { switch_mode: "outside_mode",  }
stm_text        = tok 'stm_text',         /[^\/]+/
i_slash         = tok 'i_slash',          /\//
v_equals        = tok 'v_equals',         /\s*=\s*/,                      { push_mode: 'value_mode',      }
v_value         = tok 'v_value',          /"[^"]*"|'[^']*'|[^>\s\/]+/,    { pop_mode: true,               }
i_whitespace    = tok 'i_whitespace',     /[ \t\r\n]/,                    { group: Lexer.SKIPPED,         }
### NOTE this is the most generous definition of an XML name, ever. It basically allows anything except
those few characters that would definitely mess with the rest of the grammar, so tags like `<123>`,
`<foo:bar#baz.gnu bro:go=42>` are totally OK. Consumers are advised to do their own checking to narrow
down available choices or interpret special constructs, as the case may be. The regex below stipulates
that a valid XML name is any sequence of one or more characters, excluding only
* whitespace,
* brackets (`{[(<>)]}`),
* question and exclamation marks (`!?`),
* slashes (`/`),
* quotes (`'` and `"`).
###
i_name          = tok 'i_name',           /[^\s!?=\{\[\(<\/>\)\]\}'"]+/


#-----------------------------------------------------------------------------------------------------------
xmlLexerDefinition =
  defaultMode: 'outside_mode'
  modes:
    #.......................................................................................................
    outside_mode: [
      o_comment
      o_cdata
      o_doctype
      o_xmldecl
      o_pi
      i_slash_open
      i_open
      o_text ]
    #.......................................................................................................
    inside_mode: [
      i_close
      i_special_close
      i_slash_close
      stm_slash1
      i_slash
      v_equals
      i_name
      i_whitespace ]
    #.......................................................................................................
    slashtext_mode: [
      stm_slash2
      stm_text ]
    #.......................................................................................................
    value_mode: [
      v_value ]

#-----------------------------------------------------------------------------------------------------------
@lexer = do =>
  # Reducing the amount of position tracking can provide a small performance boost (<10%)
  # Likely best to keep the full info for better error position reporting and
  # to expose "fuller" ITokens from the Lexer.
  settings =
    positionTracking:           'full'
    ensureOptimizations:        false
    ### TODO: inspect definitions for XML line terminators ###
    lineTerminatorCharacters:   [ '\n', ],
    lineTerminatorsPattern:     /\n|\r\n/g
    errorMessageProvider:
      ### see https://sap.github.io/chevrotain/docs/features/custom_errors.html ###
      buildUnexpectedCharactersMessage: ( source, start, length, line, column ) ->
        text = source[ start ... start + length ]
        return "extraneous characters on line #{line ? '?'} column #{column ? '?'}: #{jr text}"
  return new Lexer xmlLexerDefinition, settings


#-----------------------------------------------------------------------------------------------------------
@tokenize = ( source, lexer_mode = null ) -> @lexer.tokenize source, lexer_mode



