
'use strict'




############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr.bind CND
badge                     = 'INTERTEXT/EXPERIMENTS/TEACUP-LIKE-HTML-GENERATION'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
#...........................................................................................................
DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
{ new_datom
  lets
  select }                = DATOM.export()
#...........................................................................................................
types                     = require '../types'
{ isa
  validate
  type_of }               = types
#...........................................................................................................
# INTERTEXT                 = require '../..'
# { HTML }                  = INTERTEXT
# { datoms_as_html
#   raw
#   text
#   script
#   css
#   dhtml }                 = HTML.export()
{ jr }                    = CND
test                      = require 'guy-test'
Multimix                  = require 'multimix'


#-----------------------------------------------------------------------------------------------------------
@walk = ( list ) ->
  idx = -1
  loop
    idx++
    break if idx > list.length - 1
    x     = list[ idx ]
    switch type = type_of x
      when 'null'
        list.splice idx, 1
        idx--
      when 'list'
        @walk x
      when 'function'
        @target = []
        x()
        whisper @target
        list[ idx .. idx ] = @target
        idx--
      else
        info rpr x
  return null

#-----------------------------------------------------------------------------------------------------------
@unwrap = ( x ) ->
  return x unless isa.list x
  return x unless x.length is 1
  return x unless isa.list x[ 0 ]
  return @unwrap x[ 0 ]

#-----------------------------------------------------------------------------------------------------------
@render = ( list ) ->
  @walk list
  return @unwrap list

#-----------------------------------------------------------------------------------------------------------
@h = ( x... ) -> @target.push x; return null

#-----------------------------------------------------------------------------------------------------------
MAIN = @
class Xxx extends Multimix
  @include MAIN, { overwrite: false, }
  # @extend MAIN, { overwrite: false, }

  #---------------------------------------------------------------------------------------------------------
  constructor: ->
    super()
    # @export @target if @target?
    @collector = []
    @target    = @collector
    return @

############################################################################################################
module.exports = XXX = new Xxx()

#-----------------------------------------------------------------------------------------------------------
@[ "XXX demo" ] = ( T, done ) ->
  { h
    render }  = XXX.export()
  #.........................................................................................................
  h null, ->
    h 'pre'
    h 'one', ->
      h 'two', 42
      h 'three', ->
        h 'four'
    h 'post'
  urge rpr XXX.collector
  d = render XXX.collector
  T.eq d, [
    [ 'pre' ],
    [ 'one', [ 'two', 42 ], [ 'three', [ 'four' ] ] ],
    [ 'post' ] ]
  info rpr d
  #.........................................................................................................
  done() if done?


############################################################################################################
if module is require.main then do =>
  test @[ "XXX demo" ]
  # @[ "XXX demo" ]()


# urge @collector; @collector.length = 0


