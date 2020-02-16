
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
HtmlParser                = require 'atlas-html-stream'
assign                    = Object.assign
excluded_content_parts    = [ '', null, undefined, ]


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

# #-----------------------------------------------------------------------------------------------------------
# @datoms_as_nlhtml = ( ds... ) ->
#   R = ''
#   for d in ds.flat Infinity
#     html    = @_datom_as_html d
#     sigil   = d.$key[ 0 ]
#     tagname = d.$key[ 1 .. ]
#     R      += '\n' if sigil is '<' and isa._intertext_html_block_level_tagname tagname
#     R      += html
#     # R      += '\n' if
#   return R

#-----------------------------------------------------------------------------------------------------------
@html_from_datoms   = ( ds... ) -> return ( @_datom_as_html d for d in ds.flat Infinity ).join ''
@$html_from_datoms  = ->
  { $, } = ( require 'steampipes' ).export()
  return $ ( d, send ) =>
    return send @_datom_as_html d unless isa.list d
    send x for x in @html_from_datoms d...
    return null

#-----------------------------------------------------------------------------------------------------------
@_datom_as_html = ( d ) ->
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
# @new_parse_method = ( settings ) ->
#   validate.parse_html_settings settings = { types.defaults.parse_html_settings..., settings..., }
@_new_parse_method = ( settings ) ->
  ### NOTE strangely, throwing an error from inside the `data` handler seems to throw off the parser;
  even when both `parser.flushText()` and `parser.reset()` were called prior to throwing the error, all
  subsequent parsing calls will return empty lists. We therefore construct a new parser instance for
  each call to `datoms_from_html()`. ###
  R         = null
  parser    = new HtmlParser { preserveWS: true, }
  #.........................................................................................................
  parser.on 'data', ( { name, data, text, } ) =>
    name = name.toLowerCase() if name?
    #.......................................................................................................
    if name is '!doctype'
      $value = 'html'
      for key of data
        $value = key
        break
      return R.push new_datom '^doctype', $value
    #.......................................................................................................
    return R.push new_datom '^text', { text, } if text?
    is_empty_tag = isa._intertext_html_empty_element_tagname name
    # debug '^7787^', { name, data, text, is_empty_tag, }
    unless data?
      return if is_empty_tag
        # throw new Error "^intertext/_new_parse_method@6069^ found closing tag, but HTML5 <#{name}> is an empty tag"
      return R.push new_datom '>' + name
    has_keys = false
    for key, value of data
      has_keys    = true
      data[ key ] = true if value is ''
    sigil = if is_empty_tag then '^' else '<'
    return R.push new_datom sigil + name unless has_keys
    return R.push new_datom sigil + name, data
  parser.on 'error', ( error ) -> throw error
  # parser.on 'end', -> R.push new_datom '^stop'
  #.........................................................................................................
  return ( html ) =>
    # urge '^7787^', jr html
    R = []
    parser.write html
    parser.flushText()
    # parser.reset()      # call if parser is to be reused
    return R

#-----------------------------------------------------------------------------------------------------------
@datoms_from_html = ( html ) -> @_new_parse_method() html

#-----------------------------------------------------------------------------------------------------------
@$datoms_from_html = ->
  { $, } = ( require 'steampipes' ).export()
  return $ ( buffer_or_text, send ) =>
    send d for d in @datoms_from_html buffer_or_text
    return null






