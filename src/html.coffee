
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
assign                    = Object.assign


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
@parse_compact_tagname = ( compact_tagname ) ->
  { tagname
    attributes }  = ( compact_tagname.match /^(?<tagname>[^#.]*)(?<attributes>.*)$/ ).groups
  R               = {}
  R.tagname       = tagname unless tagname is ''
  return R if attributes is ''
  for attribute in attributes.split /([#.][^#.]*)/
    continue if attribute is ''
    avalue = attribute[ 1 .. ]
    unless avalue.length > 0
      throw new Error "^intertext/parse_compact_tagname@4422^ illegal compact tag syntax in #{rpr compact_tagname}"
    if attribute[ 0 ] is '#' then R.id = avalue
    else                          ( R.class ?= [] ).push avalue
  R.class = R.class.join ' ' if R.class?
  return R

#-----------------------------------------------------------------------------------------------------------
@h = ( compact_tagname, attributes, content... ) ->
  validate.nonempty_text compact_tagname
  { tagname, id, class: clasz, }  = @parse_compact_tagname compact_tagname
  validate.intertext_html_tagname tagname
  use_attributes                  = false
  if attributes?
    if isa.object attributes then use_attributes = true
    else                          content.unshift attributes
  if content.length is 0
    sigil   = '^'
    end_tag = null
  else
    sigil   = '<'
    end_tag = { $key: ">#{tagname}", }
    for part, idx in content
      content[ idx ] = { $key: '^text', text: ( @_escape_text part ), } if isa.text part
  start_tag       = { $key: "#{sigil}#{tagname}", }
  start_tag.id    = id    if id?
  start_tag.class = clasz if clasz?
  assign start_tag, attributes if use_attributes
  R               = [ start_tag, content..., ]
  R.push end_tag if end_tag?
  return R.flat Infinity

#-----------------------------------------------------------------------------------------------------------
@datoms_as_html = ( ds ) ->
  validate.list ds
  return ( @datom_as_html d for d in ds ).join ''

#-----------------------------------------------------------------------------------------------------------
@datom_as_html = ( d ) ->
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

#-----------------------------------------------------------------------------------------------------------
@$datom_as_html = ->
  { $, } = ( require 'steampipes' ).export()
  return $ ( d, send ) =>
    send @datom_as_html d
    return null


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
@$html_as_datoms = ->
  { $, } = ( require 'steampipes' ).export()
  return $ ( buffer_or_text, send ) =>
    send d for d in @html_as_datoms buffer_or_text
    return null


############################################################################################################
if module is require.main then do => # await do =>
  help 'ok'


###


--------------------------------------------------------------------------------
from https://github.com/goodeggs/teacup/blob/master/src/teacup.coffee
elements =
  # Valid HTML 5 elements requiring a closing tag.
  # Note: the `var` element is out for obvious reasons, please use `tag 'var'`.
  regular: 'a abbr address article aside audio b bdi bdo blockquote body button
 canvas caption cite code colgroup datalist dd del details dfn div dl dt em
 fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
 html i iframe ins kbd label legend li map mark menu meter nav noscript object
 ol optgroup option output p pre progress q rp rt ruby s samp section
 select small span strong sub summary sup table tbody td textarea tfoot
 th thead time title tr u ul video'

  raw: 'style'

  script: 'script'

  # Valid self-closing HTML 5 elements.
  void: 'area base br col command embed hr img input keygen link meta param
 source track wbr'

  obsolete: 'applet acronym bgsound dir frameset noframes isindex listing
 nextid noembed plaintext rb strike xmp big blink center font marquee multicol
 nobr spacer tt'

  obsolete_void: 'basefont frame'
--------------------------------------------------------------------------------

# #-----------------------------------------------------------------------------------------------------------
# @html5_block_level_tagnames = new Set """address article aside blockquote dd details dialog div dl dt
# fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 header hgroup hr li main nav ol p pre section table
# td th ul""".split /\s+/

# #-----------------------------------------------------------------------------------------------------------
# @_new_datom = ( name, data, text ) ->
#   return new_datom '^text', { text, } if text?
#   #.........................................................................................................
#   is_block = @html5_block_level_tagnames.has name
#   unless data?
#     return new_datom '>' + name unless is_block
#     return new_datom '>' + name, { is_block, }
#   #.........................................................................................................
#   has_keys = false
#   for key, value of data
#     has_keys    = true
#     data[ key ] = true if value is ''
#   #.........................................................................................................
#   unless has_keys
#     return new_datom '<' + name unless is_block
#     return new_datom '<' + name, { is_block, }
#   #.........................................................................................................
#   return new_datom '<' + name, { data, } unless is_block
#   return new_datom '<' + name, { data, is_block, }

#-----------------------------------------------------------------------------------------------------------
# @_new_parse_method = ( piecemeal ) ->
#   R       = null
#   parser  = new HtmlParser { preserveWS: true, }
#   #.........................................................................................................
#   parser.on 'data', ( { name, data, text, } ) => R.push @_new_datom name, data, text
#   parser.on 'error', ( error ) -> throw error
#   # parser.on 'end', -> R.push new_datom '^stop'
#   #.........................................................................................................
#   R = ( html ) =>
#     R = []
#     parser.write html
#     unless piecemeal
#       parser.flushText()
#       parser.reset()
#     return R
#   #.........................................................................................................
#   R.flush = -> parser.flushText()
#   R.reset = -> parser.reset()
#   return R

#-----------------------------------------------------------------------------------------------------------
class Htmlparser extends Multimix
  # @extend   object_with_class_properties
  @include L

  #---------------------------------------------------------------------------------------------------------
  constructor: ( @settings = null ) ->
    super()

###