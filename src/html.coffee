
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
@datom_as_html = ( d ) =>
  DATOM.types.validate.datom_datom d
  atxt        = ''
  sigil       = d.$key[ 0 ]
  tagname     = d.$key[ 1 .. ]
  x_key       = null
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
  slash     = if sigil is '<' then '' else "</#{tagname}>"
  x_sys_key = if x_key? then "<x-sys-key>#{x_key}</x-sys-key>" else ''
  return "<#{tagname}>#{slash}#{x_sys_key}" if atxt is ''
  return "<#{tagname}#{atxt}>#{x_sys_key}#{slash}"


#===========================================================================================================
# PARSING
#-----------------------------------------------------------------------------------------------------------
# @new_parse_method = ( settings ) ->
#   validate.parse_html_settings settings = { types.defaults.parse_html_settings..., settings..., }
@_new_parse_method = ( settings ) ->
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
    return R.push new_datom '>' + name unless data?
    has_keys = false
    for key, value of data
      has_keys    = true
      data[ key ] = true if value is ''
    return R.push new_datom '<' + name unless has_keys
    return R.push new_datom '<' + name, data
  parser.on 'error', ( error ) -> throw error
  # parser.on 'end', -> R.push new_datom '^stop'
  #.........................................................................................................
  return ( html ) =>
    R = []
    parser.write html
    parser.flushText()
    parser.reset()
    return R

#-----------------------------------------------------------------------------------------------------------
@html_as_datoms = @_new_parse_method()

#-----------------------------------------------------------------------------------------------------------
find_next_tag = ( text, prv_idx = 0 ) ->
  idx_0 = text.indexOf '<', prv_idx
  idx_1 = text.indexOf '>', prv_idx
  if ( idx_0 < 0 )
    return [ null, null, ] if ( idx_1 < 0 )
    throw new Error "Syntax error: closing but no opening bracket"
  throw new Error "Syntax error: opening but no closing bracket"                if ( idx_1 < 0 )
  throw new Error "Syntax error: closing before opening bracket"                if ( idx_1 < idx_0 )
  throw new Error "Syntax error: closing bracket too close to opening bracket"  if ( idx_1 < idx_0 + 2 )
  throw new Error "Syntax error: whitespace not allowed here"                   if /\s/.test text[ idx_0 + 1 ]
  idx_2 = text.indexOf '<', idx_0 + 1
  throw new Error "Syntax error: additional opening bracket"                    if ( 0 < idx_2 < idx_1 )
  return [ idx_0, idx_1, ]

#-----------------------------------------------------------------------------------------------------------
@mkts_html_as_datoms = ( text ) ->
  R         = []
  prv_idx   = 0
  prv_idx_1 = -1
  #.........................................................................................................
  loop
    #.......................................................................................................
    try
      [ idx_0, idx_1, ] = find_next_tag text, prv_idx
    catch error
      throw error unless /Syntax error/.test error.message
      source = text[ prv_idx .. ]
      R.push new_datom '~error', {
        message:  "#{error.message}: #{jr source}",
        type:     'mkts-syntax-html',
        source:   source, }
      return R
    #.......................................................................................................
    if idx_0 > prv_idx_1 + 1
      R.push new_datom '^text', { text: text[ prv_idx_1 + 1 ... idx_0 ], }
    break unless idx_0?
    tags = @html_as_datoms text[ idx_0 .. idx_1 ]
    if text[ idx_1 - 1 ] is '/'
      R.push d = lets tags[ 0 ], ( d ) -> d.$key = '^' + d.$key[ 1 .. ]
    else
      R.push tags...
    prv_idx_1 = idx_1
    prv_idx   = idx_1 + 1
  #.........................................................................................................
  # debug '7776^', rpr { prv_idx, prv_idx_1, idx_0, idx_1, length: text.length, }
  if prv_idx < text.length
      R.push new_datom '^text', { text: text[ prv_idx_1 + 1 .. ], }
  return R


############################################################################################################
if module is require.main then do => # await do =>
  help 'ok'

