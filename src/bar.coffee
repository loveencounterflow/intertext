



'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/HYPHENATION'
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
  cast
  type_of }               = types


#-----------------------------------------------------------------------------------------------------------
@percentage_bar = ( n ) ->
  if n is null or n <= 0  then return '             '
  if n >= 100             then return '█████████████'
  n = ( Math.round n / 100 * 104 )
  R = '█'.repeat n // 8
  switch n %% 8
    when 0 then R += ' '
    when 1 then R += '▏'
    when 2 then R += '▎'
    when 3 then R += '▍'
    when 4 then R += '▌'
    when 5 then R += '▋'
    when 6 then R += '▊'
    when 7 then R += '▉'
  return R.padEnd 13

#-----------------------------------------------------------------------------------------------------------
@hollow_percentage_bar = ( n ) ->
  if n is null or n <= 0  then return '             '
  # if n >= 100             then return '░░░░░░░░░░░░░'
  if n >= 100             then return '▓▓▓▓▓▓▓▓▓▓▓▓▓'
  n = ( Math.round n / 100 * 104 )
  # R = '░'.repeat n // 8
  R = '▓'.repeat n // 8
  switch n %% 8
    when 0 then R += ' '
    when 1 then R += '▏'
    when 2 then R += '▎'
    when 3 then R += '▍'
    when 4 then R += '▌'
    when 5 then R += '▋'
    when 6 then R += '▊'
    when 7 then R += '▉'
    # when 8 then R += '█'
  return R.padEnd 13


############################################################################################################
if module is require.main then do =>
  # await @demo()
  # await @demo_inserts()
  t0 = Date.now()
  sleep   = ( dts ) -> new Promise ( done ) => setTimeout done, dts * 1000
  for n in [ 0 .. 10 ]
    s = CND.random_integer 10, 100
    # await sleep s / 1000
    await sleep 50 / 1000
    t = ( Date.now() - t0 ) %% 100
    t0 = t
    info ( "#{t.toFixed 5}".padStart 20 ), '│' + ( CND.reverse @percentage_bar t ) + '│' + ( CND.reverse @hollow_percentage_bar t ) + '│'
  return null







