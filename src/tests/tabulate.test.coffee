
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/TESTS/TABULATE'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
echo                      = CND.echo.bind CND
{ is_empty
  copy
  assign
  jr }                    = CND
# PATH                      = require 'path'
# FS                        = require 'fs'
#...........................................................................................................
test                      = require 'guy-test'
#...........................................................................................................
types                     = ( require '../..' ).types
{ isa
  validate
  cast
  last_of
  type_of }               = types




#-----------------------------------------------------------------------------------------------------------
@_xxx_kw_demo = -> new Promise ( resolve ) =>
  SP                        = require 'steampipes'
  { $
    $async
    $watch
    $show
    $drain }                = SP.export()
  TBL                       = ( require '../..' ).TBL
  source                    = [ ( Array.from 'abcdefg' ), [ 1e6 .. 1e6 + 7 ], ]
  #.........................................................................................................
  pipeline = []
  pipeline.push source
  pipeline.push TBL.$tabulate()
  pipeline.push $watch ( d ) -> echo d.text
  pipeline.push $drain ( result ) -> resolve result
  SP.pull pipeline...
  resolve()
  return null


#-----------------------------------------------------------------------------------------------------------
@demo = ( T, done ) -> new Promise ( resolve ) =>
  SP                        = require 'steampipes'
  { $
    $async
    $watch
    $show
    $drain }                = SP.export()
  #...........................................................................................................
  TBL                 = ( require '../..' ).TBL
  probes_and_matchers = [
    [
      [ ( Array.from 'abcdefg' ), [ 1e6 .. 1e6 + 7 ], ]
      [ {"text":"┌──────────────┬──────────────┬──────────────┬──────────────┬──────────────┬──────────────┬──────────────┐","$key":"^table"},
        {"text":"│ 0            │ 1            │ 2            │ 3            │ 4            │ 5            │ 6            │","$key":"^table"},
        {"text":"├──────────────┼──────────────┼──────────────┼──────────────┼──────────────┼──────────────┼──────────────┤","$key":"^table"},
        {"text":"│ a            │ b            │ c            │ d            │ e            │ f            │ g            │","$key":"^table"},
        {"text":"│ 1000000      │ 1000001      │ 1000002      │ 1000003      │ 1000004      │ 1000005      │ 1000006      │","$key":"^table"},
        {"text":"└──────────────┴──────────────┴──────────────┴──────────────┴──────────────┴──────────────┴──────────────┘","$key":"^table"},
        ], ]
    ]
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
      pipeline = []
      pipeline.push probe
      pipeline.push TBL.$tabulate()
      pipeline.push $watch ( d ) -> echo d.text
      pipeline.push $drain ( result ) -> resolve result
      SP.pull pipeline...
  #.........................................................................................................
  done() if done?
  resolve()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "multiline text" ] = ( T, done ) -> new Promise ( resolve ) =>
  SP                        = require 'steampipes'
  { $
    $async
    $watch
    $show
    $drain }                = SP.export()
  #...........................................................................................................
  TBL                 = ( require '../..' ).TBL
  probes_and_matchers = [
    [
      [ { key: 1, value: "helo", }
        { key: 2, value: "world", }
        { key: 2, value: "on\nmultiple\nlines", }
        ]
      undefined ]
    ]
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
      pipeline = []
      pipeline.push probe
      pipeline.push TBL.$tabulate { multiline: false, }
      pipeline.push $watch ( d ) -> echo d.text
      pipeline.push $drain ( result ) -> resolve undefined # result
      SP.pull pipeline...
  #.........................................................................................................
  done() if done?
  resolve()
  return null




############################################################################################################
if module is require.main then do =>
  # await @_xxx_kw_demo()
  test @
  # test @[ "demo" ]

