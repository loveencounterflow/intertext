
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'CHEVROTAIN-API'
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
LEXER                     = require './chevrotain-lexer'
PARSER                    = require './chevrotain-parser'
GRAMMAR                   = require './chevrotain-grammar'
{ lets
  freeze }                = ( new ( require 'datom' ).Datom { dirty: false, } ).export()
{ isa }                   = require '../types'


#-----------------------------------------------------------------------------------------------------------
@parse = ( html, settings ) ->
  echo CND.white CND.reverse CND.bold ( jr html ).padEnd 108, ' '
  defaults      = { lexer_mode: 'outside_mode', parser_start: 'document', }
  settings      = { defaults..., settings..., }
  tokenization  = LEXER.tokenize html, settings.lexer_mode
  @show_tokens html, tokenization
  parsification = PARSER.parse tokenization, settings.parser_start
  R             =
    source:         html
    cst:            parsification.cst
    lexer_mode:     settings.lexer_mode
    parser_start:   settings.parser_start
    errors:
      lexer:          tokenization.errors
      parser:         parsification.errors
  @show_tree R
  for token in ( tokens = GRAMMAR.extract_tokens R )
    if token.$stamped                 then  color = CND.grey
    else if token.$key is '^unknown'  then  color = CND.red
    else if token.$key is '^text'     then  color = CND.white
    else if token.$key is '^error'    then  color = ( P... ) -> CND.red CND.reverse CND.bold P...
    else                                    color = CND.orange
    echo color jr token
  @show_condensed_tokens tokens
  echo CND.grey CND.reverse CND.bold ( jr html ).padEnd 108, ' '
  return R

#-----------------------------------------------------------------------------------------------------------
@show_tree = ( parsification ) ->
  { source
    cst
    errors }  = parsification
  @_show_tree source, cst
  error_count = errors.lexer.length + errors.parser.length
  if error_count > 0
    warn 'lexer:',  jr error for error in errors.lexer
    warn 'parser:', jr error for error in errors.parser
  return null

#-----------------------------------------------------------------------------------------------------------
lft = ( x ) -> x.toString().padEnd 15, ' '
@_show_tree = ( source, tree, level = 0 ) ->
  ### terminals: ["image","startOffset","endOffset",...
  non-terminals: ["name","children","location"] ###
  # whisper jr ( k for k of tree )
  return null unless tree?
  indent = '  '.repeat level
  #.........................................................................................................
  unless tree.children?
    { name
      start
      stop
      text } = GRAMMAR.distill_token tree
    echo "#{indent}#{CND.blue lft name} #{CND.grey lft jr [ start, stop, ]} #{CND.yellow jr text}"
    return null
  #.........................................................................................................
  { start
    stop }  = GRAMMAR.distill_token tree.location
  text      = source[ start ... stop ]
  echo "#{indent}#{CND.lime lft tree.name} #{CND.grey lft jr [ start, stop, ]} #{CND.yellow jr text}"
  for key, tokens of tree.children
    for token in tokens
      @_show_tree source, token, level + 1
  return null

#-----------------------------------------------------------------------------------------------------------
@show_tokens = ( source, tokenization ) ->
  tokens = [ tokenization.tokens..., ].sort ( a, b ) -> return a.startOffset - b.startOffset
  for token in tokens
    echo CND.blue jr GRAMMAR.distill_token token
  return null

#-----------------------------------------------------------------------------------------------------------
as_text = ( x ) ->
  return jr x if isa.object x
  return jr x if isa.list   x
  return x.toString()

#-----------------------------------------------------------------------------------------------------------
@condense_token = ( token ) ->
  keys    = ( Object.keys token ).sort()
  keys    = keys.filter ( x ) -> x not in [ 'message', ]
  values  = ( ( as_text token[ k ] ) for k in keys )
  return values.join '-'

#-----------------------------------------------------------------------------------------------------------
@condense_tokens = ( tokens ) -> ( ( @condense_token t ) for t in tokens when t.$key isnt '^report' ).join '#'

#-----------------------------------------------------------------------------------------------------------
@show_condensed_tokens = ( tokens ) ->
  for token in tokens
    help @condense_token token
  info @condense_tokens tokens
  return null


############################################################################################################
if module is require.main then do =>
  @parse """<a>before<tag>text</tag>after</a>"""
  @parse """before<py/ma3ke4dang1/<oyaji/馬克當/<a><b/></c></d>"""
  @parse """before <![CDATA[\none\ntwo\n]]>after"""
  @parse """before <![CDATA[x]]>after"""
  @parse """before <![CDATA[x]]>"""
  @parse """before <![CDATA[]]>"""
  @parse """<!DOCTYPE html>"""
  @parse """<?xml something something?>"""
  @parse """<?xml something something>"""
  @parse """<?dodat blah?>"""
  @parse """before <otag a1=41 a2=42>after"""
  @parse """before <ntag a1=41 a2=42/stm_text/ after"""
  @parse """before <ntag a1=v1 a2=v2/stm_text/ after"""
  @parse """before <otag a1=v1 a2=v2>after"""
  @parse """<br><tag a1 a2=v2 a3 = v3>some text</tag>"""
  @parse """<br><tag a1 a2=v2 p3:a3 = v3>some text</tag>"""
  @parse """<br><tag#c5 a1 a2=v2 p3:a3 = v3>some text</tag>"""
  @parse """<A></B>"""
  @parse """<STAG/>""",                   { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """</CTAG>""",                   { lexer_mode: 'outside_mode', parser_start: 'ctag',   }
  @parse """<NTAG/""",                    { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """<a><!-- COMMENT HERE --><b>"""
  echo CND.blue CND.reverse '  /'.repeat 36
  echo CND.blue CND.reverse ' / '.repeat 36
  echo CND.blue CND.reverse '/  '.repeat 36
  @parse """<UNFINISHED""",               { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """<?=)(//&%%$§$§"!""",          { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """<>""",                        { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """<!>""",                       { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """<![CDATA[""",                 { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """>""",                         { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """< =""",                       { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """<a b= >""",                   { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """foo bar<a b= >""",            { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """foo bar<c><a b= >""",         { lexer_mode: 'outside_mode', parser_start: 'osntag', }
  @parse """foo bar<c><a b= >"""
  @parse "< >"
  @parse "< x >"
  @parse "<>"
  @parse "<"
  @parse "<tag"
  @parse "if <math> a > b </math> then"
  @parse "if <math> a < b </math> then"
  @parse ">"
  @parse "&"
  @parse "&amp;"
  @parse "<tag a='<'>"
  @parse """BEFORE <NTAG/STM_TEXT/ AFTER"""



###

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

###


