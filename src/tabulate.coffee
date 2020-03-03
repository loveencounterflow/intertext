



############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/TBL'
# log                       = CND.get_logger 'plain',     badge
# info                      = CND.get_logger 'info',      badge
# whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
# echo                      = CND.echo.bind CND
#...........................................................................................................
{ assign
  jr }                    = CND
types                     = require './types'
{ isa
  validate
  cast
  last_of
  type_of }               = types
SP                        = require 'steampipes'
{ $
  $async
  $watch
  $show
  $drain }                = SP.export()
{ jr, }                   = CND
DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
{ new_datom
  wrap_datom
  lets
  freeze
  select }                = DATOM.export()
{ to_width, width_of, }   = require 'to-width'



#-----------------------------------------------------------------------------------------------------------
@$tabulate = ( settings = {} ) ->
  S = _new_state settings
  #.........................................................................................................
  pipeline = [
    $as_event           S
    $set_widths_etc     S
    $dividers_top       S
    $dividers_bottom    S
    $as_row             S
    $cleanup            S
    ]
  #.........................................................................................................
  return SP.pull pipeline...

#-----------------------------------------------------------------------------------------------------------
@$show_table = ( settings ) ->
  throw new Error "not implemented"

#-----------------------------------------------------------------------------------------------------------
_new_state = ( settings ) ->
  S = {}
  ### TAINT use intertype ###
  # validate_keys "settings", "one or more out of", ( Object.keys settings ), keys_toplevel
  #.........................................................................................................
  settings           ?=       {}
  S.width             =       settings[ 'width'       ] ? null
  S.alignment         =       settings[ 'alignment'   ] ? 'left'
  S.fit               =       settings[ 'fit'         ] ? null
  S.ellipsis          =       settings[ 'ellipsis'    ] ? '…'
  S.pad               =       settings[ 'pad'         ] ? ''
  S.overflow          =       settings[ 'overflow'    ] ? 'show'
  S.alignment         =       settings[ 'alignment'   ] ? 'left'
  S.multiline         =       settings[ 'multiline'   ] ? false
  S.format            =       settings[ 'format'      ] ? null
  #.........................................................................................................
  S.widths            = copy  settings[ 'widths'      ] ? []
  S.alignments        =       settings[ 'alignments'  ] ? []
  S.headings          =       settings[ 'headings'    ] ? yes
  S.keys              =       settings[ 'keys'        ] ? null
  S.box               = copy  settings[ 'box'         ] ? copy boxes[ 'plain' ]
  #.........................................................................................................
  S.pad               = ( ' '.repeat S.pad ) if CND.isa_number S.pad
  #.........................................................................................................
  S.box               = box_style = boxes[ S.box ] if CND.isa_text S.box
  throw new Error "unknown box style #{rpr box_style}" unless S.box?
  #.........................................................................................................
  S.box.left          =         S.box.vs + S.pad
  S.box.center        = S.pad + S.box.vs + S.pad
  S.box.right         = S.pad + S.box.vs
  S.box.left_width    = width_of S.box.left
  S.box.center_width  = width_of S.box.center
  S.box.right_width   = width_of S.box.right
  #.........................................................................................................
  ### TAINT use intertype ###
  # validate_keys "alignment", "one of", [ S.alignment, ], values_alignment
  # validate_keys "overflow",  "one of", [ S.overflow,  ], values_overflow
  if settings.format? and ( type = type_of settings.format ) isnt 'function'
    throw new Error "expected function for format, got a #{type}"
  #.........................................................................................................
  if S.overflow isnt 'show' then throw new Error "setting 'overflow' not yet supported"
  if S.fit?                 then throw new Error "setting 'fit' not yet supported"
  #.........................................................................................................
  ### TAINT use intertype ###
  ### TAINT check widths etc. are non-zero integers ###
  ### TAINT check values in headings, widths, keys (?) ###
  #.........................................................................................................
  return S

#-----------------------------------------------------------------------------------------------------------
### TAINT use intertype ###
keys_toplevel     = [
  'alignment'
  'alignments'
  'box'
  'default'
  'ellipsis'
  'fit'
  'headings'
  'keys'
  'overflow'
  'pad'
  'width'
  'widths'
  ]
values_overflow   = [ 'show',  'hide', ]
values_alignment  = [ 'left',  'right', 'center', ]

#-----------------------------------------------------------------------------------------------------------
$set_widths_etc = ( S ) ->
  is_first = true
  return $ ( d, send ) ->
    return send d unless is_first
    return send d unless select d, '^data'
    is_first = false
    { data, } = d
    #...................................................................................................
    unless S.keys?
      if      isa.list    data  then S.keys = ( idx for _, idx  in data )
      else if isa.object  data  then S.keys = ( key for key     of data )
      else throw new Error "^intertext/tabulate/set_widths_etc@1^ expected a list or an object, got a #{CND.type_of data}"
    S.headings = S.keys if S.headings is true
    #...................................................................................................
    unless S.width?
      { columns: terminal_width, } = ( require '..' ).get_terminal_size()
      ### TAINT correction varies with border style ###
      S.width = Math.max 10, ( Math.floor terminal_width / S.keys.length ) - 4
    #...................................................................................................
    if S.widths?      then  S.widths[ idx ]      ?= S.width for idx in [ 0 ... S.keys.length ]
    else                    S.widths              = ( S.width for key in S.keys )
    #...................................................................................................
    if S.alignments?  then  S.alignments[ idx ]  ?= S.alignment for idx in [ 0 ... S.keys.length ]
    else                    S.alignments          = ( S.alignment for key in S.keys )
    #...................................................................................................
    return send d

#-----------------------------------------------------------------------------------------------------------
as_row = ( S, data, keys = null, is_header = false ) =>
  R           = []
  if keys? then keys_and_idxs = ( [ key, idx, ] for key, idx in keys                  )
  else          keys_and_idxs = ( [ idx, idx, ] for      idx in [ 0 ... data.length ] )
  unless S.multiline is false
    throw new Error "^intertype/tabulate/as_row@2^ setting multiline #{rpr S.multiline} not supported"
  for [ key, idx, ] in keys_and_idxs
    value     = data[ key ]
    text      = as_text S, value
    width     = S.widths[ idx ]
    align     = S.alignments[ idx ]
    ellipsis  = S.ellipsis
    text      = to_width text, width, { align, ellipsis, }
    text      = S.format text, { value, is_header, key, idx, } if S.format?
    R.push text
  #.......................................................................................................
  return S.box.left + ( R.join S.box.center ) + S.box.right

#-----------------------------------------------------------------------------------------------------------
$as_row = ( S ) ->
  return $ ( d, send ) ->
    return send d unless select d, '^data'
    { data, } = d
    text      = as_row S, data, S.keys, false
    is_header = false
    return send new_datom '^table', { text, }
    send d

#-----------------------------------------------------------------------------------------------------------
get_divider = ( S, position ) ->
  switch position
    when 'top'
      left    = S.box.lt
      center  = S.box.ct
      right   = S.box.rt
    when 'heading'
      left    = S.box.lm
      center  = S.box.cm
      right   = S.box.rm
    when 'mid'
      left    = S.box.lm
      center  = S.box.cm
      right   = S.box.rm
    when 'bottom'
      left    = S.box.lb
      center  = S.box.cb
      right   = S.box.rb
    else throw new Error "unknown position #{rpr position}"
  #.........................................................................................................
  last_idx  = S.widths.length - 1
  R         = []
  #.........................................................................................................
  ### TAINT simplified calculation; assumes single-width glyphs and symmetric padding etc. ###
  for width, idx in S.widths
    column = []
    if idx is 0
      column.push left
      count = ( S.box.left_width - 1 )           + width + ( ( S.box.center_width - 1 ) / 2 )
    else if idx is last_idx
      column.push center
      count = ( ( S.box.center_width - 1 ) / 2 ) + width + ( S.box.right_width - 1 )
    else
      column.push center
      count = ( ( S.box.center_width - 1 ) / 2 ) + width + ( ( S.box.center_width - 1 ) / 2 )
    column.push S.box.hs.repeat count
    column.push right if idx is last_idx
    R.push column.join ''
  #.........................................................................................................
  return R.join ''

# #-----------------------------------------------------------------------------------------------------------
# $dividers = ( S ) ->
#   # return D.new_stream pipeline: [ ( $dividers_top S ), ( $dividers_mid S ), ( $dividers_bottom S ), ]
#   return D.new_stream pipeline: [ ( $dividers_top S ), ( $dividers_bottom S ), ]

#...........................................................................................................
$dividers_top = ( S ) ->
  is_first = true
  return $ ( d, send ) ->
    return send d unless is_first
    is_first = false
    send new_datom '^table', { text: ( get_divider S, 'top' ), }
    #.......................................................................................................
    unless S.headings in [ null, false, ]
      send new_datom '^table', { text: ( as_row       S, S.headings, null, true ), }
      send new_datom '^table', { text: ( get_divider  S, 'heading'              ), }
    #.......................................................................................................
    send d

#-----------------------------------------------------------------------------------------------------------
$dividers_bottom = ( S ) ->
  return SP.window { width: 2, fallback: null, }, $ ( de, send ) ->
    [ d, e, ] = de
    return null unless d?
    send d
    unless e?
      send new_datom '^table', { text: ( get_divider S, 'bottom' ), }
    return null

#-----------------------------------------------------------------------------------------------------------
$cleanup = ( S ) -> SP.$filter ( d ) -> select d, '^table'

#-----------------------------------------------------------------------------------------------------------
boxes =
  plain:
    lt:   '┌'
    ct:   '┬'
    rt:   '┐'
    lm:   '├'
    cm:   '┼'
    rm:   '┤'
    lb:   '└'
    cb:   '┴'
    rb:   '┘'
    vs:   '│'
    hs:   '─'
  round:
    lt:   '╭'
    ct:   '┬'
    rt:   '╮'
    lm:   '├'
    cm:   '┼'
    rm:   '┤'
    lb:   '╰'
    cb:   '┴'
    rb:   '╯'
    vs:   '│'
    hs:   '─'


#===========================================================================================================
# HELPERS
#-----------------------------------------------------------------------------------------------------------
$as_event = ( S ) -> $ ( data, send ) -> send new_datom '^data', { data, }

#-----------------------------------------------------------------------------------------------------------
as_text = ( S, x ) ->
  return '○'        if x is undefined
  return '●'        if x is null
  return "''"       if x is ''
  type = type_of x
  return 'NaN'      if type is 'nan'
  return rpr x      if type is 'infinity'
  return jr x       if type in [ 'object', 'list', 'number', ]
  return jr x unless type is 'text'
  x = x.replace /\n/g, '⏎'
  x = x.replace /[\x00-\x1a\x1c-\x1f]/g, ( $0 ) -> String.fromCodePoint ( $0.codePointAt 0 ) + 0x2400
  x = x.replace /\x1b(?!\[)/g, '␛'
  return x
  # switch
  #   when 'text'
  #     return    x if S.multiline
  #     return jr x
  #     return    x unless ( x is '' ) or ( /\s/.test x )
  #   ### other types, number formatting go here ###
  # return rpr x

#-----------------------------------------------------------------------------------------------------------
copy      = ( x ) ->
  return Object.assign [], x if isa.list    x
  return Object.assign {}, x if isa.object  x
  return x



############################################################################################################
if module is require.main then do =>





