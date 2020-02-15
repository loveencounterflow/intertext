
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


# #-----------------------------------------------------------------------------------------------------------
# get_nesting_level = ( list ) ->
#   validate.list list
#   return _get_nesting_level list, -1, -1
# _get_nesting_level = ( list, level, max_nesting_level ) ->
#   level            += 1
#   max_nesting_level = Math.max max_nesting_level, level
#   for x in list
#     continue unless isa.list x
#     max_nesting_level = Math.max max_nesting_level, _get_nesting_level x, level, max_nesting_level
#   return max_nesting_level
# urge '^897^', get_nesting_level []
# urge '^897^', get_nesting_level [ 1, ]
# urge '^897^', get_nesting_level [[]]
# urge '^897^', get_nesting_level [ [ 4, ], ]
# urge '^897^', get_nesting_level [[[]]]
# urge '^897^', get_nesting_level [ 1, [ 2, 4, [ 5, ], [ 6, ], ], ]


#-----------------------------------------------------------------------------------------------------------
@expand = ( list ) ->
  @_expand list
  return @_unwrap list

#-----------------------------------------------------------------------------------------------------------
@_expand = ( list ) ->
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
        @_expand x
      when 'function'
        @target = []
        x()
        list[ idx .. idx ] = @target
        idx--
  return null

#-----------------------------------------------------------------------------------------------------------
@_unwrap = ( x ) ->
  return x unless isa.list x
  return x unless x.length is 1
  return x unless isa.list x[ 0 ]
  return @_unwrap x[ 0 ]

#-----------------------------------------------------------------------------------------------------------
@cram = ( x... ) -> @target.push x; return null

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
@[ "XXX demo 1" ] = ( T, done ) ->
  { cram
    expand }  = XXX.export()
  #.........................................................................................................
  cram null, ->
    cram 'pre'
    cram 'one', ->
      cram 'two', 42
      cram 'three', ->
        cram 'four', ->
          cram 'five', ->
            cram 'six'
    cram 'post'
  # urge rpr XXX.collector
  ds = expand XXX.collector
  # urge '^4443^', ds
  T.eq ds, [
    [ 'pre' ],
    [
      'one',
      [ 'two', 42 ],
      [
        'three',
        [ 'four', [ 'five', [ 'six' ] ] ]
      ]
    ],
    [ 'post' ]
  ]
  info rpr ds
  #.........................................................................................................
  done() if done?

#-----------------------------------------------------------------------------------------------------------
@[ "XXX demo 2" ] = ( T, done ) ->
  { cram
    expand }  = XXX.export()
  #.........................................................................................................
  h = ( tagname, content... ) ->
    if content.length is 0
      d = new_datom "^#{tagname}"
      return cram d, content...
    d1 = new_datom "<#{tagname}"
    d2 = new_datom ">#{tagname}"
    return cram d1, content..., d2
  #.........................................................................................................
  cram null, ->
    h 'pre'
    h 'one', ->
      h 'two', ( new_datom '^text', text: '42' )
      h 'three', ->
        h 'four', ->
          h 'five', ->
            h 'six', ->
              cram ( new_datom '^text', text: 'bottom' )
    h 'post'
  urge rpr XXX.collector
  ds = expand XXX.collector
  info rpr ds
  urge html = ( require '../..' ).HTML.datoms_as_html ds
  T.eq html, "<pre></pre><one><two>42</two><three><four><five><six>bottom</six></five></four></three></one><post></post>"
  T.eq ds, [
    [ { '$key': '^pre' } ],
    [ { '$key': '<one' },
      [ { '$key': '<two' },
        { text: '42', '$key': '^text' },
        { '$key': '>two' } ],
      [ { '$key': '<three' },
        [ { '$key': '<four' },
          [ { '$key': '<five' },
            [ { '$key': '<six' },
              [ { text: 'bottom', '$key': '^text' } ],
              { '$key': '>six' } ],
            { '$key': '>five' } ],
          { '$key': '>four' } ],
        { '$key': '>three' } ],
      { '$key': '>one' } ],
    [ { '$key': '^post' } ] ]
  #.........................................................................................................
  done() if done?



############################################################################################################
if module is require.main then do =>
  # test @[ "XXX demo 1" ]
  test @[ "XXX demo 2" ]
  # @[ "XXX demo" ]()

# urge @collector; @collector.length = 0


