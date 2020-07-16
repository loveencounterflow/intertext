
'use strict'


###

Word wrapping, line justification

###


############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/WRAP'
debug                     = CND.get_logger 'debug',     badge
alert                     = CND.get_logger 'alert',     badge
whisper                   = CND.get_logger 'whisper',   badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
info                      = CND.get_logger 'info',      badge
PATH                      = require 'path'
FS                        = require 'fs'
{ jr, }                   = CND
assign                    = Object.assign
join_path                 = ( P... ) -> PATH.resolve PATH.join P...
#...........................................................................................................
types                     = require './types'
{ isa
  validate
  cast
  type_of }               = types
# SP                        = require 'steampipes'
# { $
#   $drain }                = SP.export()
# DATOM                     = require 'datom'
# { new_datom
#   select }                = DATOM.export()
# INTERTEXT                 = null
# LineBreaker               = null
Multimix                  = require 'multimix'

#-----------------------------------------------------------------------------------------------------------
intersperse = ( list, x ) ->
  ### thx to https://stackoverflow.com/a/37129036/7568091 ###
  is_first = true
  for value in list
    yield x unless is_first
    is_first = false
    yield value
  return null


#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
class Wrap extends Multimix
  _defaults: {}

  #---------------------------------------------------------------------------------------------------------
  constructor: ( settings = null) ->
    super()
    @settings = { @_defaults..., settings..., }
    return @

  #---------------------------------------------------------------------------------------------------------
  justify_monospaced: ( words, line_width, word_widths = null ) ->
    validate.list_of 'nonempty_text', words
    if words.length is 0 then throw new Error "^itx/wrap/justify@448^ expected list with at least 1 element, got empty list"
    validate.positive_integer line_width
    if word_widths?
      validate.list_of 'positive_integer', word_widths
      unless word_widths.length is words.length
        throw new Error "^itx/wrap/justify@334^ length of list word_widths must match length of words list, got list of length #{word_widths.length}"
    else
      { width_of, } = require 'to-width'
      word_widths   = ( width_of word for word in words )
    return ( @_justify_monospaced words, line_width, word_widths ).join ''

  #---------------------------------------------------------------------------------------------------------
  _justify_monospaced: ( words, line_width, word_widths ) ->
    if ( word_count = words.length ) is 1 then return words[ 0 ]
    material_width = ( word_widths.reduce ( ( a, x ) => a + x + 1 ), 0 ) - 1
    if material_width > line_width
      throw new Error "^itx/wrap/justify@997^ material width #{material_width} exceeds line width #{line_width}"
    if word_count is 2
      return [ words[ 0 ], ( ' '.repeat line_width - material_width ), words[ 1 ], ]
    #.......................................................................................................
    R     = [ ( intersperse words, ' ' )... ]
    idxs  = ( idx for idx in [ 0 ... R.length ] when ( idx %% 2 ) is 1 )
    j     = -1
    CND.shuffle idxs
    loop
      break if material_width >= line_width
      j = ( j + 1 ) % idxs.length
      R[ idxs[ j ] ] += ' '
      material_width++
    #.......................................................................................................
    return R


############################################################################################################
module.exports = new Wrap()


############################################################################################################
if module is require.main then do =>



