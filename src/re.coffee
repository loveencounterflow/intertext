#!node

CND                       = require 'cnd'
badge                     = 'INTERTEXT/RE'
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
types                     = require './types'
{ isa
  validate
  type_of  }              = types
{ to_width, width_of, }   = require 'to-width'
Multimix                  = require 'multimix'


#-----------------------------------------------------------------------------------------------------------
class Re extends Multimix
  _defaults: {}

  #---------------------------------------------------------------------------------------------------------
  constructor: ( settings = null) ->
    super()
    @settings = { @_defaults..., settings..., }
    return @

  #---------------------------------------------------------------------------------------------------------
  @escape: ( text ) ->
    ### Given a `text`, return the same with all regular expression metacharacters properly escaped. Escaped
    characters are `[]{}()*+?-.,\^$|#` plus whitespace. ###
    #.......................................................................................................
    return text.replace /[-[\]{}()*+?.,\\\/^$|#\s]/g, "\\$&"

  #---------------------------------------------------------------------------------------------------------
  @re_from_text: ( text, flags = null ) ->
    return new RegExp ( @escape text ), flags ? 'g'



############################################################################################################
module.exports = new Re()


############################################################################################################
if module is require.main then do =>


