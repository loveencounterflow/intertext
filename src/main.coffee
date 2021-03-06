
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT'
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
FS                        = require 'fs'
PATH                      = require 'path'
Multimix                  = require 'multimix'
{ assign
  jr }                    = CND
@types                    = require './types'
{ isa
  validate
  cast
  type_of }               = @types
Multimix                  = require 'multimix'
{ inspect }               = require 'util'

###
#...........................................................................................................
_format                   = require 'number-format.js'
format_float              = ( x ) -> _format '#,##0.000', x
format_integer            = ( x ) -> _format '#,##0.',    x
format_as_percentage      = ( x ) -> _format '#,##0.00',  x * 100
###

#-----------------------------------------------------------------------------------------------------------
class Html extends Multimix
  @include require './html'

#-----------------------------------------------------------------------------------------------------------
class Cupofhtml extends Multimix
  @include require './cupofhtml'

#-----------------------------------------------------------------------------------------------------------
class Hyph extends Multimix
  @include require './hyphenation'

#-----------------------------------------------------------------------------------------------------------
class Ucd extends Multimix
  @include require './ucd'

#-----------------------------------------------------------------------------------------------------------
class Patterns extends Multimix
  @include require './_patterns'

#-----------------------------------------------------------------------------------------------------------
class Tbl extends Multimix
  @include require './tabulate'

#-----------------------------------------------------------------------------------------------------------
@get_terminal_size = -> ( require 'term-size' )()

#-----------------------------------------------------------------------------------------------------------
@rpr = ( P... ) ->
  return ( ( inspect x, @rpr_settings ) for x in P ).join ' '

#-----------------------------------------------------------------------------------------------------------
@camelize = ( text ) ->
  ### thx to https://github.com/lodash/lodash/blob/master/camelCase.js ###
  words = text.split '-'
  for idx in [ 1 ... words.length ] by +1
    word = words[ idx ]
    continue if word is ''
    words[ idx ] = word[ 0 ].toUpperCase() + word[ 1 .. ]
  return words.join ''


#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
MAIN = @
class Intertext extends Multimix
  @include MAIN,                              { overwrite: false, }
  # @extend MAIN, { overwrite: false, }

  #---------------------------------------------------------------------------------------------------------
  constructor: ( target = null ) ->
    super()
    @HTML         = new Html()
    @CUPOFHTML    = new Cupofhtml()
    @HYPH         = new Hyph()
    @UCD          = new Ucd()
    @_PATTERNS    = new Patterns()
    @TBL          = new Tbl()
    @SLABS        = require './slabs'
    @DIFF         = require './diff'
    @RE           = require './re'
    @WRAP         = require './wordwrap'
    @rpr_settings =
      depth:          Infinity
      maxArrayLength: Infinity
      breakLength:    Infinity
      compact:        true
    @export target if target?
    return @

module.exports = INTERTEXT = new Intertext()


############################################################################################################
if module is require.main then do =>
  null


