

'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/CUPOFHTML'
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
MAIN                      = @
DATOM                     = require 'datom'
Multimix                  = require 'multimix'
types                     = require './types'
{ isa
  validate
  cast
  type_of }               = types
#...........................................................................................................
_defaults = { flatten: true, DATOM: null, newlines: true, }


#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
class @_Targeted_collection extends Multimix
  constructor: ( target ) ->
    super()
    @_ = target


#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
class @_Tags extends @_Targeted_collection
  address:      ( P... ) => @_.tag 'address',     { $blk: true, }, P...
  article:      ( P... ) => @_.tag 'article',     { $blk: true, }, P...
  aside:        ( P... ) => @_.tag 'aside',       { $blk: true, }, P...
  blockquote:   ( P... ) => @_.tag 'blockquote',  { $blk: true, }, P...
  dd:           ( P... ) => @_.tag 'dd',          { $blk: true, }, P...
  details:      ( P... ) => @_.tag 'details',     { $blk: true, }, P...
  dialog:       ( P... ) => @_.tag 'dialog',      { $blk: true, }, P...
  div:          ( P... ) => @_.tag 'div',         { $blk: true, }, P...
  dl:           ( P... ) => @_.tag 'dl',          { $blk: true, }, P...
  dt:           ( P... ) => @_.tag 'dt',          { $blk: true, }, P...
  fieldset:     ( P... ) => @_.tag 'fieldset',    { $blk: true, }, P...
  figcaption:   ( P... ) => @_.tag 'figcaption',  { $blk: true, }, P...
  figure:       ( P... ) => @_.tag 'figure',      { $blk: true, }, P...
  footer:       ( P... ) => @_.tag 'footer',      { $blk: true, }, P...
  form:         ( P... ) => @_.tag 'form',        { $blk: true, }, P...
  h1:           ( P... ) => @_.tag 'h1',          { $blk: true, }, P...
  h2:           ( P... ) => @_.tag 'h2',          { $blk: true, }, P...
  h3:           ( P... ) => @_.tag 'h3',          { $blk: true, }, P...
  h4:           ( P... ) => @_.tag 'h4',          { $blk: true, }, P...
  h5:           ( P... ) => @_.tag 'h5',          { $blk: true, }, P...
  h6:           ( P... ) => @_.tag 'h6',          { $blk: true, }, P...
  header:       ( P... ) => @_.tag 'header',      { $blk: true, }, P...
  hgroup:       ( P... ) => @_.tag 'hgroup',      { $blk: true, }, P...
  hr:           ( P... ) => @_.tag 'hr',          { $blk: true, }, P...
  li:           ( P... ) => @_.tag 'li',          { $blk: true, }, P...
  main:         ( P... ) => @_.tag 'main',        { $blk: true, }, P...
  nav:          ( P... ) => @_.tag 'nav',         { $blk: true, }, P...
  ol:           ( P... ) => @_.tag 'ol',          { $blk: true, }, P...
  p:            ( P... ) => @_.tag 'p',           { $blk: true, }, P...
  pre:          ( P... ) => @_.tag 'pre',         { $blk: true, }, P...
  section:      ( P... ) => @_.tag 'section',     { $blk: true, }, P...
  table:        ( P... ) => @_.tag 'table',       { $blk: true, }, P...
  ul:           ( P... ) => @_.tag 'ul',          { $blk: true, }, P...
  #.........................................................................................................
  a:            ( P... ) => @_.tag 'a',           P...
  abbr:         ( P... ) => @_.tag 'abbr',        P...
  acronym:      ( P... ) => @_.tag 'acronym',     P...
  applet:       ( P... ) => @_.tag 'applet',      P...
  area:         ( P... ) => @_.tag 'area',        P...
  audio:        ( P... ) => @_.tag 'audio',       P...
  b:            ( P... ) => @_.tag 'b',           P...
  base:         ( P... ) => @_.tag 'base',        P...
  basefont:     ( P... ) => @_.tag 'basefont',    P...
  bdi:          ( P... ) => @_.tag 'bdi',         P...
  bdo:          ( P... ) => @_.tag 'bdo',         P...
  big:          ( P... ) => @_.tag 'big',         P...
  body:         ( P... ) => @_.tag 'body',        P...
  br:           ( P... ) => @_.tag 'br',          P...
  button:       ( P... ) => @_.tag 'button',      P...
  canvas:       ( P... ) => @_.tag 'canvas',      P...
  caption:      ( P... ) => @_.tag 'caption',     P...
  center:       ( P... ) => @_.tag 'center',      P...
  cite:         ( P... ) => @_.tag 'cite',        P...
  code:         ( P... ) => @_.tag 'code',        P...
  col:          ( P... ) => @_.tag 'col',         P...
  colgroup:     ( P... ) => @_.tag 'colgroup',    P...
  data:         ( P... ) => @_.tag 'data',        P...
  datalist:     ( P... ) => @_.tag 'datalist',    P...
  del:          ( P... ) => @_.tag 'del',         P...
  dfn:          ( P... ) => @_.tag 'dfn',         P...
  em:           ( P... ) => @_.tag 'em',          P...
  embed:        ( P... ) => @_.tag 'embed',       P...
  font:         ( P... ) => @_.tag 'font',        P...
  frame:        ( P... ) => @_.tag 'frame',       P...
  frameset:     ( P... ) => @_.tag 'frameset',    P...
  head:         ( P... ) => @_.tag 'head',        P...
  html:         ( P... ) => @_.tag 'html',        P...
  i:            ( P... ) => @_.tag 'i',           P...
  iframe:       ( P... ) => @_.tag 'iframe',      P...
  img:          ( P... ) => @_.tag 'img',         P...
  input:        ( P... ) => @_.tag 'input',       P...
  ins:          ( P... ) => @_.tag 'ins',         P...
  kbd:          ( P... ) => @_.tag 'kbd',         P...
  keygen:       ( P... ) => @_.tag 'keygen',      P...
  label:        ( P... ) => @_.tag 'label',       P...
  legend:       ( P... ) => @_.tag 'legend',      P...
  link:         ( P... ) => @_.tag 'link',        P...
  map:          ( P... ) => @_.tag 'map',         P...
  mark:         ( P... ) => @_.tag 'mark',        P...
  menu:         ( P... ) => @_.tag 'menu',        P...
  menuitem:     ( P... ) => @_.tag 'menuitem',    P...
  meta:         ( P... ) => @_.tag 'meta',        P...
  meter:        ( P... ) => @_.tag 'meter',       P...
  noscript:     ( P... ) => @_.tag 'noscript',    P...
  object:       ( P... ) => @_.tag 'object',      P...
  optgroup:     ( P... ) => @_.tag 'optgroup',    P...
  option:       ( P... ) => @_.tag 'option',      P...
  output:       ( P... ) => @_.tag 'output',      P...
  param:        ( P... ) => @_.tag 'param',       P...
  progress:     ( P... ) => @_.tag 'progress',    P...
  q:            ( P... ) => @_.tag 'q',           P...
  rb:           ( P... ) => @_.tag 'rb',          P...
  rp:           ( P... ) => @_.tag 'rp',          P...
  rt:           ( P... ) => @_.tag 'rt',          P...
  rtc:          ( P... ) => @_.tag 'rtc',         P...
  ruby:         ( P... ) => @_.tag 'ruby',        P...
  s:            ( P... ) => @_.tag 's',           P...
  samp:         ( P... ) => @_.tag 'samp',        P...
  script:       ( P... ) => @_.tag 'script',      P...
  select:       ( P... ) => @_.tag 'select',      P...
  small:        ( P... ) => @_.tag 'small',       P...
  source:       ( P... ) => @_.tag 'source',      P...
  span:         ( P... ) => @_.tag 'span',        P...
  strike:       ( P... ) => @_.tag 'strike',      P...
  strong:       ( P... ) => @_.tag 'strong',      P...
  style:        ( P... ) => @_.tag 'style',       P...
  sub:          ( P... ) => @_.tag 'sub',         P...
  summary:      ( P... ) => @_.tag 'summary',     P...
  sup:          ( P... ) => @_.tag 'sup',         P...
  tbody:        ( P... ) => @_.tag 'tbody',       P...
  td:           ( P... ) => @_.tag 'td',          P...
  template:     ( P... ) => @_.tag 'template',    P...
  textarea:     ( P... ) => @_.tag 'textarea',    P...
  tfoot:        ( P... ) => @_.tag 'tfoot',       P...
  th:           ( P... ) => @_.tag 'th',          P...
  thead:        ( P... ) => @_.tag 'thead',       P...
  time:         ( P... ) => @_.tag 'time',        P...
  title:        ( P... ) => @_.tag 'title',       P...
  tr:           ( P... ) => @_.tag 'tr',          P...
  track:        ( P... ) => @_.tag 'track',       P...
  u:            ( P... ) => @_.tag 'u',           P...
  var:          ( P... ) => @_.tag 'var',         P...
  video:        ( P... ) => @_.tag 'video',       P...
  wbr:          ( P... ) => @_.tag 'wbr',         P...


#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
class @_Specials extends @_Targeted_collection
  doctype:      ( type = 'html' ) => @_._cram @_raw 'doctype', type
  # img:          ( P... ) => XXXX @_.tag '!–', P...

  #---------------------------------------------------------------------------------------------------------
  raw:      ( P... ) => validate.list_of 'text', P; @_raw 'raw',  P...
  text:     ( P... ) => validate.list_of 'text', P; @_raw 'text', P...
  comment:  ( P... ) => validate.list_of 'text', P; @_raw 'raw',  "<!-- #{P.join()} -->"
  newline:  ( P... ) => validate.list_of 'text', P; @_raw 'raw',  "\n"

  #---------------------------------------------------------------------------------------------------------
  _raw: ( name, P... ) => @_._cram @_.DATOM.new_datom "^#{name}", { text: ( P.join '' ), $: 'ð1', }

  #---------------------------------------------------------------------------------------------------------
  link_css: ( href ) ->
    ### `<link rel=stylesheet href="../reset.css"/>` ###
    unless ( arity = arguments.length ) is 1
      throw new Error "^intertext/html/link_css@2935^ expected 1 argument, got #{arity}"
    debug '^3334^', href
    validate.nonempty_text href
    return @_._cram @_.DATOM.new_datom '^link', { rel: 'stylesheet', href, }

  #---------------------------------------------------------------------------------------------------------
  script: ( x ) ->
    unless ( arity = arguments.length ) is 1
      throw new Error "^intertext//html/link_js@3502^ expected 1 argument, got #{arity}"
    return switch type = type_of x
      when 'text'     then @_script_src     x
      when 'function' then @_script_literal x
    throw new Error "^intertext/script@4069^ expected a text or a function, got a #{type}"

  #---------------------------------------------------------------------------------------------------------
  _script_src: ( src ) ->
    ### `<script type="text/javascript" src="../jquery-3.4.1.js">` ###
    validate.nonempty_text src
    @_.cram 'script', { src, }

  #---------------------------------------------------------------------------------------------------------
  _script_literal: ( f ) ->
    ### `<script type="text/javascript"> var a, b; ...;</script>` ###
    @_.cram 'script', => @raw "(#{f.toString()})();"

############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################

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
@$html_from_datoms  = ->
  { $, } = ( require 'steampipes' ).export()
  return $ ( d, send ) =>
    ds = if ( isa.list d ) then d else [ d, ]
    for d in ds
      send @_html_from_datom { newlines: false, }, d
    return null

#-----------------------------------------------------------------------------------------------------------
@_html_from_datom = ( settings, d ) ->
  return @_html_from_datom ( @text d )[ 0 ] if isa.text d ### TAINT ??? ###
  DATOM.types.validate.datom_datom d
  atxt          = ''
  sigil         = d.$key[ 0 ]
  tagname       = d.$key[ 1 .. ]
  is_empty_tag  = isa._intertext_html_empty_element_tagname tagname
  x_key         = null
  is_block_tag  = d.$blk ? false
  if settings.newlines
    bnl = if is_block_tag then '\n\n' else ''
    xnl = '\n'
  else
    bnl = ''
    xnl = ''
  #.........................................................................................................
  ### TAINT simplistic solution; namespace might already be taken? ###
  if sigil in '[~]'
    switch sigil
      when '[' then sigil = '<'
      when '~' then sigil = '^'
      when ']' then sigil = '>'
    [ x_key, tagname, ] = [ tagname, 'x-sys', ]
  #.........................................................................................................
  return ( @_escape_text d.text ? '' )            if ( sigil is '^' ) and ( tagname is 'text'     )
  return (               d.text ? '' )            if ( sigil is '^' ) and ( tagname is 'raw'      )
  return "<!DOCTYPE #{d.$value ? 'html'}>#{xnl}"  if ( sigil is '^' ) and ( tagname is 'doctype'  )
  return "</#{tagname}>#{bnl}"                    if sigil is '>'
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
  slash     = if ( sigil is '<' ) or is_empty_tag then '' else "</#{tagname}>#{bnl}"
  x_sys_key = if x_key? then "<x-sys-key>#{x_key}</x-sys-key>" else ''
  return "<#{tagname}>#{slash}#{x_sys_key}" if atxt is ''
  return "<#{tagname}#{atxt}>#{x_sys_key}#{slash}"





############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################

#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
class @Cupofhtml extends DATOM.Cupofdatom
  # @include CUPOFHTML, { overwrite: false, }
  # @extend MAIN, { overwrite: false, }
  _defaults:      _defaults
  last_expansion: null

  #---------------------------------------------------------------------------------------------------------
  constructor: ( settings = null) ->
    super { _defaults..., settings..., }
    @H = new MAIN._Tags     @
    @S = new MAIN._Specials @
    return @

  #---------------------------------------------------------------------------------------------------------
  expand: -> return @last_expansion = super()

  #---------------------------------------------------------------------------------------------------------
  new_tag: ( name, attributes ) ->
    f           = ( P... ) -> @_.tag name, attributes, P...
    @H[ name ]  = f.bind @H
    return null

  #---------------------------------------------------------------------------------------------------------
  tag: ( name, content... ) ->
    validate.intertext_html_tagname name if name isnt null
    @cram name, content...

  #---------------------------------------------------------------------------------------------------------
  as_html: -> return ( MAIN._html_from_datom @.settings, d for d in @expand() ).join ''




