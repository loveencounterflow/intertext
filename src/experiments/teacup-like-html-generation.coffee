
# cannot 'use strict'


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
INTERTEXT                 = require '../..'
{ HTML }                  = INTERTEXT
{ datoms_as_html
  raw
  text
  script
  css
  dhtml }                 = HTML.export()
{ jr }                    = CND


#-----------------------------------------------------------------------------------------------------------
demo_1 = ->
  c       = []
  target  = c
  render  = ( x... ) -> return x
  h       = ( x... ) -> target.push x; return null
  #.........................................................................................................
  render h 'one', ->
    h 'two', 42
    h 'three', ->
      h 'four'
  #.........................................................................................................
  urge c
  target  = c[ 0 ]
  g       = target.pop()
  g()
  urge c
  #.........................................................................................................
  walk = ( list ) ->
    for x, idx in list
      if isa.list x
        walk x
      if isa.function x
        list[ idx ] = target = []
        x()
      else
        info rpr x
    return null
  #.........................................................................................................
  walk c
  urge jr c
  info CND.equals c, [["one",["two",42],["three",[["four"]]]]]

#-----------------------------------------------------------------------------------------------------------
demo_2 = ->
  c       = []
  target  = c
  h       = ( x... ) -> target.push x; return null
  #.........................................................................................................
  h 'one', ->
    h 'two', 42
    h 'three', ->
      h 'four'
  #.........................................................................................................
  walk = ( list ) ->
    idx = -1
    loop
      idx++
      break if idx > list.length - 1
      x = list[ idx ]
      if isa.list x
        walk x
        continue
      if isa.function x
        target = []
        x()
        whisper target
        list[ idx .. idx ] = target
        idx--
        continue
      info rpr x
    return null
  unwrap = ( x ) ->
    return x unless isa.list x
    return x unless x.length is 1
    return x unless isa.list x[ 0 ]
    return x[ 0 ]
  render = ( list ) ->
    walk list
    return unwrap list
  #.........................................................................................................
  urge rpr c
  d = render c
  info CND.truth CND.equals c, [ [ 'one', [ 'two', 42 ], [ 'three', [ 'four' ] ] ] ]
  info CND.truth CND.equals d,   [ 'one', [ 'two', 42 ], [ 'three', [ 'four' ] ] ]
  info rpr d
  #.........................................................................................................
  return null

#-----------------------------------------------------------------------------------------------------------
demo_3 = ->
  c       = []
  target  = c
  h       = ( x... ) -> target.push x; return null
  #.........................................................................................................
  h null, ->
    h 'pre'
    h 'one', ->
      h 'two', 42
      h 'three', ->
        h 'four'
    h 'post'
  #.........................................................................................................
  walk = ( list ) ->
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
          walk x
        when 'function'
          target = []
          x()
          whisper target
          list[ idx .. idx ] = target
          idx--
        else
          info rpr x
    return null
  unwrap = ( x ) ->
    return x unless isa.list x
    return x unless x.length is 1
    return x unless isa.list x[ 0 ]
    return unwrap x[ 0 ]
  render = ( list ) ->
    walk list
    return unwrap list
  #.........................................................................................................
  urge rpr c
  d = render c
  info CND.truth CND.equals d, [
    [ 'pre' ],
    [ 'one', [ 'two', 42 ], [ 'three', [ 'four' ] ] ],
    [ 'post' ] ]
  info rpr d
  #.........................................................................................................
  return null


############################################################################################################
if module is require.main then do =>
  # demo_1()
  # demo_2()
  demo_3()


# urge c; c.length = 0


