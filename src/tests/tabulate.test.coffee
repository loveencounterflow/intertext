
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
  INTERTEXT           = require '../..'
  TBL                 = INTERTEXT.TBL
  probes_and_matchers = [
    [
      [ ( Array.from 'abcdefg' ), [ 1e6 .. 1e6 + 7 ], [ undefined, null, Infinity, [ 'text', ], { foo: 'bar', }, ] ]
      [ { text: '┌────────────┬────────────┬────────────┬────────────┬────────────┬────────────┬────────────┐', '$key': '^table' }
        { text: '│0           │1           │2           │3           │4           │5           │6           │', '$key': '^table' }
        { text: '├────────────┼────────────┼────────────┼────────────┼────────────┼────────────┼────────────┤', '$key': '^table' }
        { text: '│a           │b           │c           │d           │e           │f           │g           │', '$key': '^table' }
        { text: '│1000000     │1000001     │1000002     │1000003     │1000004     │1000005     │1000006     │', '$key': '^table' }
        { text: "│○           │●           │Infinity    │[ 'text' ]  │{ foo: 'bar…│○           │○           │", '$key': '^table' }
        { text: '└────────────┴────────────┴────────────┴────────────┴────────────┴────────────┴────────────┘', '$key': '^table' }]
      ]
    ]
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
      pipeline = []
      pipeline.push probe
      pipeline.push TBL.$tabulate { width: 12, }
      pipeline.push $watch ( d ) -> echo d.text
      pipeline.push $drain ( result ) ->
        echo CND.gold INTERTEXT.rpr row for row in result
        resolve result
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
        { key: 3, value: "on\nmultiple\nlines", }
        ]
      [ "┌────────────┬────────────┐",
        "│key         │value       │",
        "├────────────┼────────────┤",
        "│1           │helo        │",
        "│2           │world       │",
        "│3           │on⏎multiple…│",
        "└────────────┴────────────┘" ], ]
    ]
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
      pipeline = []
      pipeline.push probe
      pipeline.push TBL.$tabulate { multiline: false, width: 12, }
      pipeline.push $ ( d, send ) -> send d.text
      pipeline.push $watch ( d ) -> echo d
      pipeline.push $drain ( result ) -> resolve result
      SP.pull pipeline...
  #.........................................................................................................
  done() if done?
  resolve()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "format callback" ] = ( T, done ) -> new Promise ( resolve ) =>
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
      [ { key: 1, type: 'normal', value: 123456789 },
        { key: 2, type: 'normal', value: null },
        { key: 3, type: 'underline', value: 'some text' },
        { key: 4, type: 'normal', value: true },
        { key: 5, type: 'normal', value: false } ],
      [ '┌────────────┬────────────┬────────────┐',
        '│\x1B[38;05;255m\x1B[7m\x1B[1mkey         \x1B[22m\x1B[27m\x1B[0m│\x1B[38;05;255m\x1B[7m\x1B[1mtype        \x1B[22m\x1B[27m\x1B[0m│\x1B[38;05;255m\x1B[7m\x1B[1mvalue       \x1B[22m\x1B[27m\x1B[0m│',
        '├────────────┼────────────┼────────────┤',
        '│\x1B[38;05;255m1           \x1B[0m│\x1B[38;05;27mnormal      \x1B[0m│\x1B[38;05;255m123456789   \x1B[0m│',
        '│\x1B[38;05;255m2           \x1B[0m│\x1B[38;05;27mnormal      \x1B[0m│\x1B[38;05;199m●           \x1B[0m│',
        '│\x1B[4m\x1B[38;05;255m3           \x1B[0m\x1B[24m│\x1B[4m\x1B[38;05;27munderline   \x1B[0m\x1B[24m│\x1B[4m\x1B[38;05;27msome text   \x1B[0m\x1B[24m│',
        '│\x1B[38;05;255m4           \x1B[0m│\x1B[38;05;27mnormal      \x1B[0m│\x1B[38;05;226mtrue        \x1B[0m│',
        '│\x1B[38;05;255m5           \x1B[0m│\x1B[38;05;27mnormal      \x1B[0m│\x1B[38;05;226mfalse       \x1B[0m│',
        '└────────────┴────────────┴────────────┘' ], null ]
    ]
  #.........................................................................................................
  colorize = ( cell_txt, { value, row, is_header, key, idx, } ) =>
    if is_header
      R = CND.white CND.reverse CND.bold cell_txt
    else
      switch type_of value
        when 'boolean'  then  R = CND.yellow  cell_txt
        when 'text'     then  R = CND.blue    cell_txt
        when 'number'   then  R = CND.green   cell_txt
        when 'null'     then  R = CND.pink    cell_txt
        else                  R = CND.white   cell_txt
      R = CND.underline R if row.type is 'underline'
    return R
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
      pipeline = []
      pipeline.push probe
      pipeline.push TBL.$tabulate { width: 12, format: colorize, }
      pipeline.push $ ( d, send ) -> send d.text
      pipeline.push $watch ( d ) -> echo d
      pipeline.push $drain ( result ) -> resolve result
      SP.pull pipeline...
  #.........................................................................................................
  done() if done?
  resolve()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "demo: autowidth" ] = ( T, done ) -> new Promise ( resolve ) =>
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
        { key: 3, value: "on\nmultiple\nlines", }
        ]
      null, ]
    [
      [ { key: 4, value: "helo",  extra: "other",         interesting: true, }
        { key: 5, value: "world", extra: "stuff",         interesting: true, }
        { key: 6, value: "!",     extra: "goes in here",  interesting: true, }
        ]
      null, ]
    [
      [ { key: 4, value: "helo",  extra: "other",         interesting: true, more: 4433, }
        { key: 5, value: "world", extra: "stuff",         interesting: true, more: 3199, }
        { key: 6, value: "!",     extra: "goes in here",  interesting: true, more: 1965, }
        ]
      null, ]
    ]
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
      pipeline = []
      pipeline.push probe
      pipeline.push TBL.$tabulate { multiline: false, }
      pipeline.push $ ( d, send ) -> send d.text
      pipeline.push $watch ( d ) -> echo d
      pipeline.push $drain ( result ) -> resolve null
      SP.pull pipeline...
  #.........................................................................................................
  done() if done?
  resolve()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "widths" ] = ( T, done ) -> new Promise ( resolve ) =>
  TBL                       = ( require '../..' ).TBL
  SP                        = require 'steampipes'
  { $
    $async
    $watch
    $show
    $drain }                = SP.export()
  #...........................................................................................................
  rows  = [
    { key: 4, value: "helo",  extra: "other",         interesting: true, more: 4433, }
    { key: 5, value: "world", extra: "stuff",         interesting: true, more: 3199, }
    { key: 6, value: "!",     extra: "goes in here",  interesting: true, more: 1965, }
    ]
  settings =
    # width:  7
    widths: { key: 3, value: 7, extra: 15, }
  #.........................................................................................................
  doit = ->
    pipeline = []
    pipeline.push rows
    pipeline.push TBL.$tabulate settings
    pipeline.push $ ( d, send ) -> send d.text
    pipeline.push $watch ( d ) -> echo d
    pipeline.push $drain ( result ) -> resolve null
    SP.pull pipeline...
  #.........................................................................................................
  await doit()
  done() if done?
  resolve()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "text representation" ] = ( T, done ) -> new Promise ( resolve ) =>
  TBL                       = ( require '../..' ).TBL
  SP                        = require 'steampipes'
  { $
    $async
    $watch
    $show
    $drain }                = SP.export()
  #...........................................................................................................
  rows  = [
    { description: "U+0000", sample: "x\u{0000}x", }
    { description: "U+0001", sample: "x\u{0001}x", }
    { description: "U+0002", sample: "x\u{0002}x", }
    { description: "U+0003", sample: "x\u{0003}x", }
    { description: "U+0004", sample: "x\u{0004}x", }
    { description: "U+0005", sample: "x\u{0005}x", }
    { description: "U+0006", sample: "x\u{0006}x", }
    { description: "U+0007", sample: "x\u{0007}x", }
    { description: "U+0008", sample: "x\u{0008}x", }
    { description: "U+0009", sample: "x\u{0009}x", }
    { description: "U+000a", sample: "x\u{000a}x", }
    { description: "U+000b", sample: "x\u{000b}x", }
    { description: "U+000c", sample: "x\u{000c}x", }
    { description: "U+000d", sample: "x\u{000d}x", }
    { description: "U+000e", sample: "x\u{000e}x", }
    { description: "U+000f", sample: "x\u{000f}x", }
    { description: "U+0010", sample: "x\u{0010}x", }
    { description: "U+0011", sample: "x\u{0011}x", }
    { description: "U+0012", sample: "x\u{0012}x", }
    { description: "U+0013", sample: "x\u{0013}x", }
    { description: "U+0014", sample: "x\u{0014}x", }
    { description: "U+0015", sample: "x\u{0015}x", }
    { description: "U+0016", sample: "x\u{0016}x", }
    { description: "U+0017", sample: "x\u{0017}x", }
    { description: "U+0018", sample: "x\u{0018}x", }
    { description: "U+0019", sample: "x\u{0019}x", }
    { description: "U+001a", sample: "x\u{001a}x", }
    { description: "U+001b", sample: "x\u{001b}x", }
    { description: "U+001c", sample: "x\u{001c}x", }
    { description: "U+001d", sample: "x\u{001d}x", }
    { description: "U+001e", sample: "x\u{001e}x", }
    { description: "U+001f", sample: "x\u{001f}x", }
    { description: "U+0020", sample: "x\u{0020}x", }
    { description: "newline",     sample: 'x⏎x',     }
    { description: "empty text",  sample: '',         }
    { description: "undefined",   sample: undefined,  }
    { description: "null",        sample: null,       }
    { description: "notanumber",  sample: 4 * 'x',       }
    { description: "lime",        sample: ( CND.lime 'Lime' ),       }
    ]
  #.........................................................................................................
  matcher = [
    "┌────────────┬────────────┐",
    "│description │sample      │",
    "├────────────┼────────────┤",
    "│U+0000      │x␀x         │",
    "│U+0001      │x␁x         │",
    "│U+0002      │x␂x         │",
    "│U+0003      │x␃x         │",
    "│U+0004      │x␄x         │",
    "│U+0005      │x␅x         │",
    "│U+0006      │x␆x         │",
    "│U+0007      │x␇x         │",
    "│U+0008      │x␈x         │",
    "│U+0009      │x␉x         │",
    "│U+000a      │x⏎x         │",
    "│U+000b      │x␋x         │",
    "│U+000c      │x␌x         │",
    "│U+000d      │x␍x         │",
    "│U+000e      │x␎x         │",
    "│U+000f      │x␏x         │",
    "│U+0010      │x␐x         │",
    "│U+0011      │x␑x         │",
    "│U+0012      │x␒x         │",
    "│U+0013      │x␓x         │",
    "│U+0014      │x␔x         │",
    "│U+0015      │x␕x         │",
    "│U+0016      │x␖x         │",
    "│U+0017      │x␗x         │",
    "│U+0018      │x␘x         │",
    "│U+0019      │x␙x         │",
    "│U+001a      │x␚x         │",
    "│U+001b      │x␛x         │",
    "│U+001c      │x␜x         │",
    "│U+001d      │x␝x         │",
    "│U+001e      │x␞x         │",
    "│U+001f      │x␟x         │",
    "│U+0020      │x x         │",
    "│newline     │x⏎x         │",
    "│empty text  │''          │",
    "│undefined   │○           │",
    "│null        │●           │",
    "│notanumber  │NaN         │",
    "│lime        │\u001b[38;05;118mLime\u001b[0m        │",
    "└────────────┴────────────┘"
    ]
  #.........................................................................................................
  result = null
  await do => new Promise ( resolve ) =>
    pipeline = []
    pipeline.push rows
    pipeline.push TBL.$tabulate { width: 12, }
    pipeline.push $ ( d, send ) -> send d.text
    pipeline.push $watch ( d ) -> echo d
    pipeline.push $drain ( result_ ) -> result = result_; resolve()
    SP.pull pipeline...
  #.........................................................................................................
  T.eq result, matcher
  # urge jr result
  done() if done?
  resolve()
  return null




############################################################################################################
if module is require.main then do =>
  # await @_xxx_kw_demo()
  test @
  # test @[ "demo" ]
  # test @[ "multiline text" ]
  # test @[ "text representation" ]
  # test @[ "format callback" ]
  # test @demo
  # for cid in [ 0 .. 32 ]
  #   debug ( cid.toString 16 ).padStart 4, '0'




