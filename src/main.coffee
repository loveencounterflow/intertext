
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

###
#...........................................................................................................
_format                   = require 'number-format.js'
format_float              = ( x ) -> _format '#,##0.000', x
format_integer            = ( x ) -> _format '#,##0.',    x
format_as_percentage      = ( x ) -> _format '#,##0.00',  x * 100
###


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
    @HTML   = require './html'
    @MKTS   = require './mkts'
    @HYPH   = require './hyphenation'
    @SLABS  = require './slabs'
    @export target if target?
    return @

module.exports = INTERTEXT = new Intertext()


############################################################################################################
if module is require.main then do =>
  null


