
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/MKTS'
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
HTML                      = null

#-----------------------------------------------------------------------------------------------------------
@datom_as_html  = ( P... ) => ( HTML ?= ( require '..' ).HTML ).datom_as_html  P...
@$datom_as_html = ( P... ) => ( HTML ?= ( require '..' ).HTML ).$datom_as_html P...


#===========================================================================================================
# PARSING
#-----------------------------------------------------------------------------------------------------------
@_find_next_tag = ( text, prv_idx = 0 ) ->
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
@_analyze_mkts_compact_syntax = ( datoms ) ->
  ###
  compact syntax for MKTScript HTMLish tags:

  `<div#c432.foo.bar>...</div>` => `<div id=c432 class='foo bar'>...</div>`
  `<p.noindent>...</p>` => `<p class=noindent>...</p>`

  positional arguments (not yet implemented):
  `<columns=2>` => `<columns count=2/>` => `<columns count=2></columns>` ?=> `<mkts-columns count=2></mkts-columns>`
  `<multiply =2 =3>` (???)

  NB Svelte uses capitalized names, allows self-closing tags(!): `<Mytag/>`

  ###
  for d, idx in datoms
    { $key, attributes, } = ( d.$key.match /^(?<$key>[^#.]+)(?<attributes>.*)$/ ).groups
    continue if attributes is ''
    update = { $key, }
    for attribute in attributes.split /([#.][^#.]+)/
      continue if attribute is ''
      avalue          = attribute[ 1 .. ]
      if attribute[ 0 ] is '#' then update.id = avalue
      else                          ( update.class ?= [] ).push avalue
    # debug '^3388^', attributes
    update.class = update.class.join ' ' if update.class?
    datoms[ idx ] = lets d, ( d ) -> assign d, update
  return datoms

#-----------------------------------------------------------------------------------------------------------
@html_as_datoms = ( text ) ->
  R         = []
  prv_idx   = 0
  prv_idx_1 = -1
  HTML     ?= ( require '..' ).HTML
  #.........................................................................................................
  loop
    #.......................................................................................................
    try
      [ idx_0, idx_1, ] = @_find_next_tag text, prv_idx
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
      R.push new_datom '^text', { text: text[ prv_idx_1 + 1 ... idx_0 ].toString(), }
    break unless idx_0?
    tags = @_analyze_mkts_compact_syntax HTML.html_as_datoms text[ idx_0 .. idx_1 ]
    if text[ idx_1 - 1 ] is '/'
      R.push d = lets tags[ 0 ], ( d ) -> d.$key = '^' + d.$key[ 1 .. ]
    else
      R.push tags...
    prv_idx_1 = idx_1
    prv_idx   = idx_1 + 1
  #.........................................................................................................
  # debug '7776^', rpr { prv_idx, prv_idx_1, idx_0, idx_1, length: text.length, }
  if prv_idx < text.length
      R.push new_datom '^text', { text: text[ prv_idx_1 + 1 .. ].toString(), }
  return R

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