



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
  S.width             =       settings[ 'width'       ] ? 12
  S.alignment         =       settings[ 'alignment'   ] ? 'left'
  ###
  process.stdout.columns
  ###
  S.fit               =       settings[ 'fit'         ] ? null
  S.ellipsis          =       settings[ 'ellipsis'    ] ? '…'
  S.pad               =       settings[ 'pad'         ] ? ' '
  S.overflow          =       settings[ 'overflow'    ] ? 'show'
  S.alignment         =       settings[ 'alignment'   ] ? 'left'
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
      else throw new Error "expected a list or a POD, got a #{CND.type_of data}"
    S.headings = S.keys if S.headings is true
    #...................................................................................................
    if S.widths?      then  S.widths[ idx ]      ?= S.width for idx in [ 0 ... S.keys.length ]
    else                    S.widths              = ( S.width for key in S.keys )
    #...................................................................................................
    if S.alignments?  then  S.alignments[ idx ]  ?= S.alignment for idx in [ 0 ... S.keys.length ]
    else                    S.alignments          = ( S.alignment for key in S.keys )
    #...................................................................................................
    return send d

#-----------------------------------------------------------------------------------------------------------
as_row = ( S, data, keys = null ) =>
  R = []
  if keys? then keys_and_idxs = ( [ key, idx, ] for key, idx in keys                  )
  else          keys_and_idxs = ( [ idx, idx, ] for      idx in [ 0 ... data.length ] )
  for [ key, idx, ] in keys_and_idxs
    text      = as_text data[ key ]
    width     = S.widths[ idx ]
    align     = S.alignments[ idx ]
    ellipsis  = S.ellipsis
    R.push to_width text, width, { align, ellipsis, }
  #.......................................................................................................
  return S.box.left + ( R.join S.box.center ) + S.box.right

#-----------------------------------------------------------------------------------------------------------
$as_row = ( S ) ->
  return $ ( d, send ) ->
    return send d unless select d, '^data'
    { data, } = d
    text      = as_row S, d.data, S.keys
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
      send new_datom '^table', { text: ( as_row       S, S.headings ), }
      send new_datom '^table', { text: ( get_divider  S, 'heading'  ), }
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
as_text   = ( x ) -> if ( CND.isa_text x ) then x else rpr x
copy      = ( x ) ->
  return Object.assign [], x if isa.list    x
  return Object.assign {}, x if isa.object  x
  return x



############################################################################################################
if module is require.main then do =>




