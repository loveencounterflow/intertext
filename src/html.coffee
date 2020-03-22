
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/HTML'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
echo                      = CND.echo.bind CND
{ jr, }                   = CND
#...........................................................................................................
DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
{ new_datom
  lets
  freeze
  thaw
  is_frozen
  select }                = DATOM.export()
types                     = require './types'
{ isa
  validate
  # cast
  # declare
  # declare_cast
  # check
  # sad
  # is_sad
  # is_happy
  type_of }               = types
#...........................................................................................................
{ Cupofjoe }              = require 'cupofjoe'
assign                    = Object.assign
excluded_content_parts    = [ '', null, undefined, ]
LEXER                     = require './chevrotain-html/chevrotain-lexer'
PARSER                    = require './chevrotain-html/chevrotain-parser'
GRAMMAR                   = require './chevrotain-html/chevrotain-grammar'


#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
@_escape_text = ( x ) ->
  R           = x
  R           = R.replace /&/g,   '&amp;'
  R           = R.replace /</g,   '&lt;'
  R           = R.replace />/g,   '&gt;'
  return R

#-----------------------------------------------------------------------------------------------------------
@_as_attribute_literal = ( x ) ->
  R           = if isa.text x then x else JSON.stringify x
  must_quote  = not isa._intertext_html_naked_attribute_text R
  R           = @_escape_text R
  R           = R.replace /'/g,   '&#39;'
  R           = R.replace /\n/g,  '&#10;'
  R           = "'" + R + "'" if must_quote
  return R

#-----------------------------------------------------------------------------------------------------------
@_parse_compact_tagname = ( compact_tagname ) ->
  { tagname
    attributes }  = ( compact_tagname.match /^(?<tagname>[^#.]*)(?<attributes>.*)$/ ).groups
  R               = {}
  R.tagname       = tagname unless tagname is ''
  return R if attributes is ''
  for attribute in attributes.split /([#.][^#.]*)/
    continue if attribute is ''
    avalue = attribute[ 1 .. ]
    unless avalue.length > 0
      throw new Error "^intertext/_parse_compact_tagname@1234^ illegal compact tag syntax in #{rpr compact_tagname}"
    if attribute[ 0 ] is '#' then R.id = avalue
    else                          ( R.class ?= [] ).push avalue
  R.class = R.class.join ' ' if R.class?
  return R

#-----------------------------------------------------------------------------------------------------------
@tag = ( compact_tagname, attributes, content... ) ->
  { start, content, end, } = @_tag compact_tagname, attributes, content
  return [ start, content..., end, ] if end?
  return [ start, content..., ]

#-----------------------------------------------------------------------------------------------------------
@_tag = ( compact_tagname, attributes, content, settings ) ->
  validate.nonempty_text compact_tagname
  { tagname, id, class: clasz, }  = @_parse_compact_tagname compact_tagname
  validate.intertext_html_tagname tagname
  use_attributes                  = false
  processed_content               = []
  call_functions                  = settings?.call_functions ? true
  content                         = thaw content if ( Object.isFrozen content )
  #.........................................................................................................
  if attributes?
    if isa.object attributes then use_attributes = true
    else                          content.unshift attributes
  #.........................................................................................................
  if content.length is 0
    sigil   = '^'
    end_tag = null
  #.........................................................................................................
  else
    sigil   = '<'
    end_tag = new_datom ">#{tagname}"
    for part in content
      continue if part in excluded_content_parts
      switch type_of part
        when 'text'     then  processed_content.push new_datom '^text', { text: part, }
        when 'function'
          if call_functions then  processed_content.push x unless ( x = part() ) in excluded_content_parts
          else                    processed_content.push part
        else                  processed_content.push part
  #.........................................................................................................
  if id? or clasz?
    idclass         = {}
    idclass.id      = id    if id?
    idclass.class   = clasz if clasz?
    if use_attributes
      attributes = assign idclass, attributes
    else
      use_attributes  = true
      attributes      = idclass
  #.........................................................................................................
  if use_attributes then  start_tag = new_datom "#{sigil}#{tagname}", attributes
  else                    start_tag = new_datom "#{sigil}#{tagname}"
  #.........................................................................................................
  processed_content = processed_content.flat Infinity
  return { start: start_tag, content: processed_content, end: end_tag, } if end_tag?
  return { start: start_tag, content: processed_content, }

#-----------------------------------------------------------------------------------------------------------
@html_from_datoms   = ( ds... ) -> return ( @_html_from_datom d for d in ds.flat Infinity ).join ''
                                                                  ### TAINT ^^^ ??? ^^^ ###
@$html_from_datoms  = ->
  { $, } = ( require 'steampipes' ).export()
  return $ ( d, send ) =>
    return send @_html_from_datom d unless isa.list d
    send x for x in @html_from_datoms d...
    return null

#-----------------------------------------------------------------------------------------------------------
@_html_from_datom = ( d ) ->
  return @_html_from_datom ( @text d )[ 0 ] if isa.text d ### TAINT ??? ###
  DATOM.types.validate.datom_datom d
  atxt          = ''
  sigil         = d.$key[ 0 ]
  tagname       = d.$key[ 1 .. ]
  is_empty_tag  = isa._intertext_html_empty_element_tagname tagname
  x_key         = null
  #.........................................................................................................
  ### TAINT simplistic solution; namespace might already be taken? ###
  if sigil in '[~]'
    switch sigil
      when '[' then sigil = '<'
      when '~' then sigil = '^'
      when ']' then sigil = '>'
    [ x_key, tagname, ] = [ tagname, 'x-sys', ]
  #.........................................................................................................
  return ( @_escape_text d.text ? '' )      if ( sigil is '^' ) and ( tagname is 'text'     )
  return (               d.text ? '' )      if ( sigil is '^' ) and ( tagname is 'raw'      )
  return "<!DOCTYPE #{d.$value ? 'html'}>"  if ( sigil is '^' ) and ( tagname is 'doctype'  )
  return "</#{tagname}>"                    if sigil is '>'
  #.........................................................................................................
  ### NOTE sorting atxt by keys to make result predictable: ###
  if isa.object d.$value then  src = d.$value
  else                          src = d
  atxt += " x-key=#{@_as_attribute_literal x_key}" if x_key?
  for key in ( Object.keys src ).sort()
    continue if key.startsWith '$'
    if ( value = src[ key ] ) is true then  atxt += " #{key}"
    else                                    atxt += " #{key}=#{@_as_attribute_literal value}"
  #.........................................................................................................
  ### TAINT make self-closing elements configurable, depend on HTML5 type ###
  slash     = if ( sigil is '<' ) or is_empty_tag then '' else "</#{tagname}>"
  x_sys_key = if x_key? then "<x-sys-key>#{x_key}</x-sys-key>" else ''
  return "<#{tagname}>#{slash}#{x_sys_key}" if atxt is ''
  return "<#{tagname}#{atxt}>#{x_sys_key}#{slash}"



#===========================================================================================================
# HTML SPECIALS
#-----------------------------------------------------------------------------------------------------------
@raw = ( text ) ->
  unless ( arity = arguments.length ) is 1
    throw new Error "^intertext/raw@1801^ expected 1 argument, got #{arity}"
  validate.text text
  return [ ( new_datom '^raw', { text, } ), ]

#-----------------------------------------------------------------------------------------------------------
@text = ( text ) ->
  unless ( arity = arguments.length ) is 1
    throw new Error "^intertext/text@2368^ expected 1 argument, got #{arity}"
  validate.text text
  return [ ( new_datom '^text', { text, } ), ]

#-----------------------------------------------------------------------------------------------------------
@css = ( href ) ->
  ### Creates a list with one datom representing a stylesheet link: `<link rel=stylesheet
  href="../reset.css"/>`
  ###
  unless ( arity = arguments.length ) is 1
    throw new Error "^intertext/css@2935^ expected 1 argument, got #{arity}"
  validate.nonempty_text href
  return [ ( new_datom '^link', { rel: 'stylesheet', href, } ), ]

#-----------------------------------------------------------------------------------------------------------
@script = ( x ) ->
  unless ( arity = arguments.length ) is 1
    throw new Error "^intertext/script@3502^ expected 1 argument, got #{arity}"
  return switch type = type_of x
    when 'text'     then @_script_src     x
    when 'function' then @_script_literal x
  throw new Error "^intertext/script@4069^ expected a text or a function, got a #{type}"

#-----------------------------------------------------------------------------------------------------------
@_script_src = ( src ) ->
  ### Creates a list with one datom representing a script tag: `<script type="text/javascript"
  src="../jquery-3.4.1.js">`
  ###
  validate.nonempty_text src
  return [ ( new_datom '^script', { src, } ), ]

#-----------------------------------------------------------------------------------------------------------
@_script_literal = ( f ) ->
  ### Creates a list with three datoms representing a script tag with embedded JavaScript source text:
  ```
  <script type="text/javascript">
    var a, b;
    a = 42;
    b = a * 2;
    </script>`
  ###
  return [ ( new_datom '<script' ), ( @_as_iife f ), ( new_datom '>script' ), ]

#-----------------------------------------------------------------------------------------------------------
@_as_iife = ( f ) ->
  R = "(#{f.toString()})();"
  return ( @raw R )[ 0 ]


#===========================================================================================================
# PARSING
#-----------------------------------------------------------------------------------------------------------
@datoms_from_html = ( html, settings ) ->
  defaults      = { lexer_mode: 'outside_mode', parser_start: 'document', }
  settings      = { defaults..., settings..., }
  tokenization  = LEXER.tokenize html, settings.lexer_mode
  parsification = PARSER.parse tokenization, settings.parser_start
  R             =
    source:         html
    cst:            parsification.cst
    lexer_mode:     settings.lexer_mode
    parser_start:   settings.parser_start
    errors:
      lexer:          tokenization.errors
      parser:         parsification.errors
  return GRAMMAR.extract_tokens R

#-----------------------------------------------------------------------------------------------------------
@$datoms_from_html = ->
  { $, } = ( require 'steampipes' ).export()
  return $ ( buffer_or_text, send ) =>
    send d for d in @datoms_from_html buffer_or_text
    return null


#===========================================================================================================
# CUP OF HTML
#-----------------------------------------------------------------------------------------------------------
MAIN = @ ### TAINT won't work with configured instances of HTML ###

class @Cupofhtml extends Cupofjoe
  # @include CUPOFHTML, { overwrite: false, }
  # @extend MAIN, { overwrite: false, }

  #---------------------------------------------------------------------------------------------------------
  constructor: ( settings = null) ->
    super { { flatten: true, }..., settings..., }
    return @

  #---------------------------------------------------------------------------------------------------------
  tag: ( tagname, content... ) ->
    return @cram content...      unless tagname?
    ### TAINT allow extended syntax, attributes ###
    return @cram new_datom "^#{tagname}" if content.length is 0
    return @cram ( new_datom "<#{tagname}" ), content..., ( new_datom ">#{tagname}" )

  #---------------------------------------------------------------------------------------------------------
  text:     ( P... ) -> @cram MAIN.text     P...
  raw:      ( P... ) -> @cram MAIN.raw      P...
  script:   ( P... ) -> @cram MAIN.script   P...
  css:      ( P... ) -> @cram MAIN.css      P...



