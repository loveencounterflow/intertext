
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/TESTS/SLABS'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
echo                      = CND.echo.bind CND
{ jr, }                   = CND
#...........................................................................................................
DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
{ new_datom
  lets
  select }                = DATOM.export()
types                     = require '../types'
{ isa
  validate
  # cast
  # declare
  # declare_cast
  # check
  # sad
  # is_sad
  # is_happy
  type_of }               = types
#...........................................................................................................
test                      = require 'guy-test'
INTERTEXT                 = require '../..'


#===========================================================================================================
# TESTS
#-----------------------------------------------------------------------------------------------------------
@[ "INTERTEXT.SLABS.slabs_from_text" ] = ( T, done ) ->
  probes_and_matchers = [
    ["",{"slabs":[],"ends":""},null]
    ["a very fine day",{"slabs":["a","very","fine","day"],"ends":"___x"},null]
    ["a cro­mu­lent so­lu­tion",{"slabs":["a","cro","mu","lent","so","lu","tion"],"ends":"_||_||x"},null]
    ["䷾Letterpress printing",{"slabs":["䷾Letterpress","printing"],"ends":"_x"},null]
    ["ベルリンBerlin",{"slabs":["ベ","ル","リ","ン","Berlin"],"ends":"xxxxx"},null]
    ["其法用膠泥刻字、薄如錢唇",{"slabs":["其","法","用","膠","泥","刻","字、","薄","如","錢","唇"],"ends":"xxxxxxxxxxx"},null]
    ["over-guess­ti­mate",{"slabs":["over-","guess","ti","mate"],"ends":"x||x"},null]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      # debug '^44453^', INTERTEXT.HYPH.new_hyphenator()
      # debug '^44453^', INTERTEXT.HYPH.reveal_hyphens INTERTEXT.HYPH.new_hyphenator() 'fantastic'
      # debug '^777801^', INTERTEXT.SLABS.slabs_from_text probe
      resolve INTERTEXT.SLABS.slabs_from_text probe
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "INTERTEXT.SLABS.assemble (1)" ] = ( T, done ) ->
  probes_and_matchers = [
    ["","",null]
    ["a very fine day","a very fine day",null]
    ["a cro\xadmu\xadlent so\xadlu\xadtion","a cromulent solution",null]
    ["䷾Letterpress printing","䷾Letterpress printing",null]
    ["ベルリンBerlin","ベルリンBerlin",null]
    ["其法用膠泥刻字、薄如錢唇","其法用膠泥刻字、薄如錢唇",null]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      resolve INTERTEXT.SLABS.assemble INTERTEXT.SLABS.slabs_from_text probe
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "INTERTEXT.SLABS.assemble (2)" ] = ( T, done ) ->
  probes_and_matchers = [
    ["","",null]
    ["a very fine day","fine day",null]
    ["a cro­mu­lent so­lu­tion","mulent solu-",null]
    ["䷾Letterpress printing","",null]
    ["ベルリンBerlin","リンBerlin",null]
    ["其法用膠泥刻字、薄如錢唇","用膠泥刻",null]
    ["over-guess\xadti\xadmate","timate",null]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      slb = INTERTEXT.SLABS.slabs_from_text probe
      resolve INTERTEXT.SLABS.assemble slb, 2, 5
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "INTERTEXT.SLABS.assemble (3)" ] = ( T, done ) ->
  probe   = "a very fine day for a cro\xadmu\xadlent so\xadlu\xadtion"
  matcher = [
    "a"
    "a very"
    "a very fine"
    "a very fine day"
    "a very fine day for"
    "a very fine day for a"
    "a very fine day for a cro-"
    "a very fine day for a cromu-"
    "a very fine day for a cromulent"
    "a very fine day for a cromulent so-"
    "a very fine day for a cromulent solu-"
    "a very fine day for a cromulent solution"
    ]
  slb     = INTERTEXT.SLABS.slabs_from_text probe
  info slb
  result  = ( INTERTEXT.SLABS.assemble slb, 0, idx for idx in [ 0 ... slb.slabs.length ] )
  for line, idx in result
    echo ( CND.white line.padEnd 50 ), idx, line.length
  idx_1 = 11
  for idx_2 in [ idx_1 ... slb.slabs.length ]
    line = INTERTEXT.SLABS.assemble slb, idx_1, idx_2
    idx_1_txt = ( "#{idx_1}".padEnd 5 )
    idx_2_txt = ( "#{idx_2}".padEnd 5 )
    echo ( CND.yellow line.padEnd 50 ), idx_1_txt, idx_2_txt, line.length
  help jr result
  T.eq result, matcher
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "INTERTEXT.SLABS.assemble (4)" ] = ( T, done ) ->
  probe   = "over-guess\xadti\xadmate"
  matcher = [
    "over-"
    "over-guess-"
    "over-guessti-"
    "over-guesstimate"
    ]
  slb     = INTERTEXT.SLABS.slabs_from_text probe
  result  = ( INTERTEXT.SLABS.assemble slb, 0, idx for idx in [ 0 ... slb.slabs.length ] )
  help jr result
  T.eq result, matcher
  done()
  return null



############################################################################################################
if module is require.main then do => # await do =>
  # await @_demo()
  test @
  help 'ok'
  # test @[ "demo" ]
