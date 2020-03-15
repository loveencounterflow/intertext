
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


#===========================================================================================================
# DEMO
#-----------------------------------------------------------------------------------------------------------
@DEMO = {}

#-----------------------------------------------------------------------------------------------------------
@DEMO.parse = ( lexer_mode, parser_start, source ) ->
  echo CND.white CND.reverse CND.bold ( jr source ).padEnd 108, ' '
  tokenization  = LEXER.tokenize source, lexer_mode
  @show_tokens source, tokenization
  parsification = PARSER.parse tokenization, parser_start
  R =
    source:         source
    cst:            parsification.cst
    lexer_mode:     lexer_mode
    parser_start:   parser_start
    errors:
      lexer:          tokenization.errors
      parser:         parsification.errors
  @show_tree R
  for token in GRAMMAR.extract_tokens R
    if token.$stamped                 then  color = CND.grey
    else if token.$key is '^unknown'  then  color = CND.red
    else if token.$key is '^text'     then  color = CND.white
    else if token.$key is '^error'    then  color = ( P... ) -> CND.red CND.reverse CND.bold P...
    else                                    color = CND.orange
    echo color jr token
  echo CND.grey CND.reverse CND.bold ( jr source ).padEnd 108, ' '
  return R

#-----------------------------------------------------------------------------------------------------------
@DEMO.show_tree = ( parsification ) ->
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
@DEMO._show_tree = ( source, tree, level = 0 ) ->
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
@DEMO.show_tokens = ( source, tokenization ) ->
  tokens = [ tokenization.tokens..., ].sort ( a, b ) -> return a.startOffset - b.startOffset
  for token in tokens
    echo CND.blue jr GRAMMAR.distill_token token
  return null


############################################################################################################
if module is require.main then do =>
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<a>before<tag>text</tag>after</a>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """before<py/ma3ke4dang1/<oyaji/馬克當/<a><b/></c></d>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """before <![CDATA[\none\ntwo\n]]>after"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """before <![CDATA[x]]>after"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """before <![CDATA[x]]>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """before <![CDATA[]]>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<!DOCTYPE html>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<?xml something something?>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<?xml something something>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<?dodat blah?>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """before <otag a1=41 a2=42>after"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """before <ntag a1=41 a2=42/stm_text/ after"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """before <ntag a1=v1 a2=v2/stm_text/ after"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """before <otag a1=v1 a2=v2>after"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<br><tag a1 a2=v2 a3 = v3>some text</tag>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<br><tag a1 a2=v2 p3:a3 = v3>some text</tag>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<br><tag#c5 a1 a2=v2 p3:a3 = v3>some text</tag>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<A></B>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """<STAG/>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'ctag',     """</CTAG>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """<NTAG/"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """BEFORE <NTAG/STM_TEXT/ AFTER"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<a><!-- COMMENT HERE --><b>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """<UNFINISHED"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """<?=)(//&%%$§$§"!"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """<>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """<!>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """<![CDATA["""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """>"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """< ="""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """<a b= >"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """foo bar<a b= >"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'osntag',   """foo bar<c><a b= >"""
  { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """foo bar<c><a b= >"""
  # { cst, errors, } = @DEMO.parse 'outside_mode',    'document', """<otag>"""
  # { cst, errors, } = @DEMO.parse 'outside_mode', 'document', """<a b="c"></a><b></b>"""
  # { cst, errors, } = @DEMO.parse 'inside_mode', 'attribute', """b="c\""""
  # { cst, errors, } = @DEMO.parse 'inside_mode', 'attributes', ''
  # { cst, errors, } = @DEMO.parse 'inside_mode', 'attributes', """b="c" d='e' f"""
  # { cst, errors, } = @DEMO.parse 'outside_mode', 'otag', """<a b="c" d='e' f="g" h i j>"""
  # { cst, errors, } = @DEMO.parse 'inside_mode', 'what', """one two three"""
  # { cst, errors, } = @DEMO.parse 'otag', """<a>"""


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


###


