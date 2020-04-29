
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/TESTS/UCD'
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


#===========================================================================================================
# TESTS
#-----------------------------------------------------------------------------------------------------------
@[ "INTERTEXT.UCD.get_block_list" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  debug INTERTEXT.UCD.get_block_list()
  # probes_and_matchers = []
  # for [ probe, matcher, error, ] in probes_and_matchers
  #   await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
  #     resolve INTERTEXT.SLABS.slabs_from_text probe
  #.........................................................................................................
  done()
  return null



############################################################################################################
if module is require.main then do =>
  test @
  # help 'ok'
  # test @[ "demo" ]
