
'use strict'

############################################################################################################
CND                       = require 'cnd'
badge                     = 'INTERTEXT/TESTS/BASICS'
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
test                      = require 'guy-test'


#===========================================================================================================
# TESTS
#-----------------------------------------------------------------------------------------------------------
@[ "BASICS rpr" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  { rpr }                   = INTERTEXT.export()
  #.........................................................................................................
  probes_and_matchers = [
    ["foo","'foo'",null]
    [["foo"],"[ 'foo' ]",null]
    [{ this: 42, and: true, that: [ 1, 2, null, undefined, ]},"{ this: 42, and: true, that: [ 1, 2, null, undefined ] }",null]
    [undefined,"undefined",null]
    [Infinity,"Infinity",null]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
      result  = rpr probe
      resolve result
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "BASICS camelize" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  { camelize }              = INTERTEXT.export()
  #.........................................................................................................
  probes_and_matchers = [
    [ '',             '',           ]
    [ '-',            '',           ]
    [ '--',           '',           ]
    [ '-a-',          'A',          ]
    [ '-a',           'A',          ]
    [ 'a-',           'a',          ]
    [ 'helo',         'helo',       ]
    [ 'helo-world',   'heloWorld',  ]
    [ 'HELO-WORLD',   'HELOWORLD',  ]
    [ 'µ-DOM',        'µDOM',       ]
    [ 'danish-øre',   'danishØre',  ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
      result = camelize probe
      resolve result
  #.........................................................................................................
  done()
  return null



############################################################################################################
if module is require.main then do => # await do =>
  # debug ( k for k of ( require '../..' ).HTML ).sort().join ' '
  # await @_demo()
  # test @
  test @[ "BASICS camelize" ]
  # test @[ "HTML.datoms_from_html (dubious)" ]
  # test @[ "HTML.datoms_from_html (2)" ]
  # test @[ "HTML.html_from_datoms (singular tags)" ]
  # test @[ "HTML Cupofhtml (1)" ]
  # test @[ "HTML Cupofhtml (2)" ]
  # test @[ "HTML._parse_compact_tagname" ]
