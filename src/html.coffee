
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
      throw new Error "^intertext/parse_compact_tagname@1234^ illegal compact tag syntax in #{rpr compact_tagname}"
    if attribute[ 0 ] is '#' then R.id = avalue
    else                          ( R.class ?= [] ).push avalue
  R.class = R.class.join ' ' if R.class?
  return R

#-----------------------------------------------------------------------------------------------------------
@dhtml = ( compact_tagname, attributes, content... ) ->
  { start, content, end, } = @_dhtml compact_tagname, attributes, content
  return [ start, content..., end, ] if end?
  return [ start, content..., ]

#-----------------------------------------------------------------------------------------------------------
@_dhtml = ( compact_tagname, attributes, content, settings ) ->
  validate.nonempty_text compact_tagname
  { tagname, id, class: clasz, }  = @parse_compact_tagname compact_tagname
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
# @new_dhtml_writer = ->
#   dhtml = ( compact_tagname, attributes, content... ) =>
#     # XXX = @_dhtml compact_tagname, attributes, content, { call_functions: false, }
#     dhtml.collector.push new_datom '~ff', { $value: [ compact_tagname, attributes, content, ], }
#     return null
#   #.........................................................................................................
#   dhtml.text = ( text ) =>
#     dhtml.collector.push new_datom '^text', { text, }
#     return null
#   #.........................................................................................................
#   dhtml.as_html   = =>
#   dhtml.expand = =>
#     R                       = []
#     xxx                     = dhtml.collector[ .. ]
#     dhtml.collector.length  = 0
#     debug '^2223^', 'xxx', CND.blue xxx
#     for d in xxx
#       if select d, '~ff'
#         # R[ R.length .. ] = @_dhtml d.$value...
#         help '^7776^', "_dhtml call:    ", @_dhtml d.$value...
#         urge '^7776^', "dhtml.collector:", dhtml.collector
#       else
#         R.push d
#     # debug '^2223^', CND.yellow xxx
#     # debug '^2223^', CND.orange dhtml.collector
#     # debug '^2223^', CND.lime R
#     # { collector, } =  dhtml
#     # dhtml.collector = []
#     @datoms_as_html dhtml.collector
#     dhtml.collector.length = 0
#   #.........................................................................................................
#   dhtml.collector = []
#   return dhtml

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