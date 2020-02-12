
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/TESTS/HTML'
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
{ HTML, }                 = INTERTEXT


#===========================================================================================================
# TESTS
#-----------------------------------------------------------------------------------------------------------
@[ "must quote attribute value" ] = ( T, done ) ->
  probes_and_matchers = [
    [ "",           true,   null, ]
    [ "\"",         true,   null, ]
    [ "'",          true,   null, ]
    [ "<",          true,   null, ]
    [ "<>",         true,   null, ]
    [ "foo",        false,  null, ]
    [ "foo bar",    true,   null, ]
    [ "foo\nbar",   true,   null, ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      must_quote = not isa.intertext_html_naked_attribute_value probe
      resolve must_quote
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "DATOM.HTML._as_attribute_literal" ] = ( T, done ) ->
  probes_and_matchers = [
    [ "",           "''",                       null, ]
    [ '"',          '\'"\'',                    null, ]
    [ "'",          "'&#39;'",                  null, ]
    [ "<",          "'&lt;'",                   null, ]
    [ "<>",         "'&lt;&gt;'",               null, ]
    [ "foo",        "foo",                      null, ]
    [ "foo bar",    "'foo bar'",                null, ]
    [ "foo\nbar",   "'foo&#10;bar'",            null, ]
    [ "'<>'",       "'&#39;&lt;&gt;&#39;'",     null, ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      resolve HTML._as_attribute_literal probe
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "isa.intertext_html_tagname (1)" ] = ( T, done ) ->
  probes_and_matchers = [
    [ "",             false,  null, ]
    [ "\"",           false,  null, ]
    [ "'",            false,  null, ]
    [ "<",            false,  null, ]
    [ "<>",           false,  null, ]
    [ "foo bar",      false,  null, ]
    [ "foo\nbar",     false,  null, ]
    [ "foo",          true,   null, ]
    [ "此は何ですか", true,   null, ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      resolve isa.intertext_html_tagname probe
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "isa.intertext_html_tagname (2)" ] = ( T, done ) ->
  probes = """a abbr acronym address applet area article aside audio b base basefont bdi bdo bgsound big
  blink blockquote body br button canvas caption center cite code col colgroup command datalist dd del
  details dfn dialog dir div dl dt em embed fieldset figcaption figure font footer form frame frameset h1 h2
  h3 h4 h5 h6 head header hgroup hr html i iframe img input ins isindex kbd keygen label legend li link
  listing main map mark marquee menu meta meter multicol nav nextid nobr noembed noframes noscript object ol
  optgroup option output p param plaintext pre progress q rb rp rt ruby s samp script section select small
  source spacer span strike strong sub summary sup table tbody td textarea tfoot th thead time title tr
  track tt u ul video wbr xmp
  foo:bar foo-bar Foo-bar
  """.split /\s+/
  for probe in probes
    await T.perform probe, true, null, -> return new Promise ( resolve, reject ) ->
      resolve isa.intertext_html_tagname probe
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datom_as_html (singular tags)" ] = ( T, done ) ->
  probes_and_matchers = [
    [ [ '^foo', ],                                    "<foo></foo>",                                       ]
    [ [ '^foo', { height: 42,               }, ],     "<foo height=42></foo>",                             ]
    [ [ '^foo', { class: 'plain',           }, ],     "<foo class=plain></foo>",                           ]
    [ [ '^foo', { class: 'plain hilite',    }, ],     "<foo class='plain hilite'></foo>",                  ]
    [ [ '^foo', { editable: true,           }, ],     "<foo editable></foo>",                              ]
    [ [ '^foo', { empty: '',                }, ],     "<foo empty=''></foo>",                              ]
    [ [ '^foo', { specials: '<\n\'"&>',     }, ],     "<foo specials='&lt;&#10;&#39;\"&amp;&gt;'></foo>",  ]
    [ [ '^something', { one: 1, two: 2,     }, ],     "<something one=1 two=2></something>",               ]
    [ [ '^something', { z: 'Z', a: 'A',     }, ],     "<something a=A z=Z></something>",                   ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      d = new_datom probe...
      resolve HTML.datom_as_html d
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datom_as_html (closing tags)" ] = ( T, done ) ->
  probes_and_matchers = [
    [ [ '>foo', ],                                    "</foo>",           ]
    [ [ '>foo', { height: 42,               }, ],     "</foo>",           ]
    [ [ '>foo', { class: 'plain',           }, ],     "</foo>",           ]
    [ [ '>foo', { class: 'plain hilite',    }, ],     "</foo>",           ]
    [ [ '>foo', { editable: true,           }, ],     "</foo>",           ]
    [ [ '>foo', { empty: '',                }, ],     "</foo>",           ]
    [ [ '>foo', { specials: '<\n\'"&>',     }, ],     "</foo>",           ]
    [ [ '>something', { one: 1, two: 2,     }, ],     "</something>",     ]
    [ [ '>something', { z: 'Z', a: 'A',     }, ],     "</something>",     ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      d = new_datom probe...
      resolve HTML.datom_as_html d
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datom_as_html (opening tags)" ] = ( T, done ) ->
  probes_and_matchers = [
    [ [ '<foo', ],                                    "<foo>",                                        ]
    [ [ '<foo', { height: 42,               }, ],     "<foo height=42>",                              ]
    [ [ '<foo', { class: 'plain',           }, ],     "<foo class=plain>",                            ]
    [ [ '<foo', { class: 'plain hilite',    }, ],     "<foo class='plain hilite'>",                   ]
    [ [ '<foo', { editable: true,           }, ],     "<foo editable>",                               ]
    [ [ '<foo', { empty: '',                }, ],     "<foo empty=''>",                               ]
    [ [ '<foo', { specials: '<\n\'"&>',     }, ],     "<foo specials='&lt;&#10;&#39;\"&amp;&gt;'>",   ]
    [ [ '<something', { one: 1, two: 2,     }, ],     "<something one=1 two=2>",                      ]
    [ [ '<something', { z: 'Z', a: 'A',     }, ],     "<something a=A z=Z>",                          ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      d = new_datom probe...
      resolve HTML.datom_as_html d
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datom_as_html (texts)" ] = ( T, done ) ->
  probes_and_matchers = [
    [ [ '^text', ],                                    "",                            ]
    [ [ '^text', { height: 42,               }, ],     "",                            ]
    [ [ '^text', { text: '<me & you>\n',     }, ],     "&lt;me &amp; you&gt;\n",      ]
    [ [ '<text', { z: 'Z', a: 'A',           }, ],     "<text a=A z=Z>",              ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      d = new_datom probe...
      resolve HTML.datom_as_html d
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datom_as_html (opening tags w/ $value)" ] = ( T, done ) ->
  probes_and_matchers = [
    [ [ '<foo', ],                                    "<foo>",                                        ]
    [ [ '<foo', { ignored: 'xxx', $value: { height: 42,              }, }, ], "<foo height=42>",                              ]
    [ [ '<foo', { ignored: 'xxx', $value: { class: 'plain',          }, }, ], "<foo class=plain>",                            ]
    [ [ '<foo', { ignored: 'xxx', $value: { class: 'plain hilite',   }, }, ], "<foo class='plain hilite'>",                   ]
    [ [ '<foo', { ignored: 'xxx', $value: { editable: true,          }, }, ], "<foo editable>",                               ]
    [ [ '<foo', { ignored: 'xxx', $value: { empty: '',               }, }, ], "<foo empty=''>",                               ]
    [ [ '<foo', { ignored: 'xxx', $value: { specials: '<\n\'"&>',    }, }, ], "<foo specials='&lt;&#10;&#39;\"&amp;&gt;'>",   ]
    [ [ '<something', { ignored: 'xxx', $value: { one: 1, two: 2,    }, }, ], "<something one=1 two=2>",                      ]
    [ [ '<something', { ignored: 'xxx', $value: { z: 'Z', a: 'A',    }, }, ], "<something a=A z=Z>",                          ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      d = new_datom probe...
      resolve HTML.datom_as_html d
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datom_as_html (system tags)" ] = ( T, done ) ->
  probes_and_matchers = [
    [["~foo"],"<x-sys x-key=foo><x-sys-key>foo</x-sys-key></x-sys>",null]
    [["~foo",{"height":42}],"<x-sys x-key=foo height=42><x-sys-key>foo</x-sys-key></x-sys>",null]
    [["[foo",{"class":"plain"}],"<x-sys x-key=foo class=plain><x-sys-key>foo</x-sys-key>",null]
    [["[foo",{"class":"plain hilite"}],"<x-sys x-key=foo class='plain hilite'><x-sys-key>foo</x-sys-key>",null]
    [["]foo",{"editable":true}],"</x-sys>",null]
    [["]foo",{"empty":""}],"</x-sys>",null]
    [["~foo",{"specials":"<\n'\"&>"}],"<x-sys x-key=foo specials='&lt;&#10;&#39;\"&amp;&gt;'><x-sys-key>foo</x-sys-key></x-sys>",null]
    [["~something",{"one":1,"two":2}],"<x-sys x-key=something one=1 two=2><x-sys-key>something</x-sys-key></x-sys>",null]
    [["~something",{"z":"Z","a":"A"}],"<x-sys x-key=something a=A z=Z><x-sys-key>something</x-sys-key></x-sys>",null]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      d = new_datom probe...
      resolve HTML.datom_as_html d
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datom_as_html (raw pseudo-tag)" ] = ( T, done ) ->
  probes_and_matchers = [
    [ [ '^raw', ],                                    "",                                       ]
    [ [ '^raw', { height: 42,               }, ],     "",                                       ]
    [ [ '^raw', { text: '<\n\'"&>',           }, ],   '<\n\'"&>',                               ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      d = new_datom probe...
      resolve HTML.datom_as_html d
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datom_as_html (doctype)" ] = ( T, done ) ->
  probes_and_matchers = [
    [ [ '^doctype', ],                  "<!DOCTYPE html>",        ]
    [ [ '^doctype', { height: 42, }, ], "<!DOCTYPE html>",        ]
    [ [ '^doctype', "obvious", ],       "<!DOCTYPE obvious>",     ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      d = new_datom probe...
      resolve HTML.datom_as_html d
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.html_as_datoms (1)" ] = ( T, done ) ->
  probes_and_matchers = [
    ["<!DOCTYPE html>",[{"$value":"html","$key":"^doctype"}],null]
    ["<!DOCTYPE obvious>",[{"$value":"obvious","$key":"^doctype"}],null]
    ["<p contenteditable>",[{"contenteditable":true,"$key":"<p"}],null]
    ["<img width=200>",[{"width":"200","$key":"<img"}],null]
    ["<foo/>",[{"$key":"<foo"},{"$key":">foo"}],null]
    ["<foo></foo>",[{"$key":"<foo"},{"$key":">foo"}],null]
    ["<p>here and<br>there",[{"$key":"<p"},{"text":"here and","$key":"^text"},{"$key":"<br"},{"text":"there","$key":"^text"}],null]
    ["<p>here and<br>there</p>",[{"$key":"<p"},{"text":"here and","$key":"^text"},{"$key":"<br"},{"text":"there","$key":"^text"},{"$key":">p"}],null]
    ["<p>here and<br>there</p>",[{"$key":"<p"},{"text":"here and","$key":"^text"},{"$key":"<br"},{"text":"there","$key":"^text"},{"$key":">p"}],null]
    ["<p>here and<br/>there</p>",[{"$key":"<p"},{"text":"here and","$key":"^text"},{"$key":"<br"},{"$key":">br"},{"text":"there","$key":"^text"},{"$key":">p"}],null]
    ["just some plain text",[{"$key":"^text","text":"just some plain text"},],null]
    ["<p>one<p>two",[{"$key":"<p"},{"text":"one","$key":"^text"},{"$key":"<p"},{"text":"two","$key":"^text"}],null]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      resolve HTML.html_as_datoms probe
  #.........................................................................................................
  done()
  return null

###
#-----------------------------------------------------------------------------------------------------------
probes_and_matchers = [
  ["<!DOCTYPE html>",[{"data":{"html":true},"$key":"<!DOCTYPE"}],null]
  ["<title>MKTS</title>",[{"$key":"<title"},{"text":"MKTS","$key":"^text"},{"$key":">title"}],null]
  ["<document/>",[{"$key":"<document"},{"$key":">document"}],null]
  ["<foo bar baz=42>",[{"data":{"bar":true,"baz":"42"},"$key":"<foo"}],null]
  ["<br/>",[{"$key":"<br"},{"$key":">br"}],null]
  ["</thing>",[{"$key":">thing"}],null]
  ["</foo>",[{"$key":">foo"}],null]
  ["</document>",[{"$key":">document"}],null]
  ["<title>MKTS</title>",[{"$key":"<title"},{"text":"MKTS","$key":"^text"},{"$key":">title"}],null]
  ["<p foo bar=42>omg</p>",[{"data":{"foo":true,"bar":"42"},"is_block":true,"$key":"<p"},{"text":"omg","$key":"^text"},{"is_block":true,"$key":">p"}],null]
  ["<document/><foo bar baz=42>something<br/>else</thing></foo>",[{"$key":"<document"},{"$key":">document"},{"data":{"bar":true,"baz":"42"},"$key":"<foo"},{"text":"something","$key":"^text"},{"$key":"<br"},{"$key":">br"},{"text":"else","$key":"^text"},{"$key":">thing"},{"$key":">foo"}],null]
  ["<!DOCTYPE html><html lang=en><head><title>x</title></head><p data-x='<'>helo</p></html>",[{"data":{"html":true},"$key":"<!DOCTYPE"},{"data":{"lang":"en"},"$key":"<html"},{"$key":"<head"},{"$key":"<title"},{"text":"x","$key":"^text"},{"$key":">title"},{"$key":">head"},{"data":{"data-x":"<"},"is_block":true,"$key":"<p"},{"text":"helo","$key":"^text"},{"is_block":true,"$key":">p"},{"$key":">html"}],null]
  ["<p foo bar=42><em>Yaffir stood high</em></p>",[{"data":{"foo":true,"bar":"42"},"is_block":true,"$key":"<p"},{"$key":"<em"},{"text":"Yaffir stood high","$key":"^text"},{"$key":">em"},{"is_block":true,"$key":">p"}],null]
  ["<p foo bar=42><em><xxxxxxxxxxxxxxxxxxx>Yaffir stood high</p>",[{"data":{"foo":true,"bar":"42"},"is_block":true,"$key":"<p"},{"$key":"<em"},{"$key":"<xxxxxxxxxxxxxxxxxxx"},{"text":"Yaffir stood high","$key":"^text"},{"is_block":true,"$key":">p"}],null]
  ["<p föö bär=42><em>Yaffir stood high</p>",[{"data":{"föö":true,"bär":"42"},"is_block":true,"$key":"<p"},{"$key":"<em"},{"text":"Yaffir stood high","$key":"^text"},{"is_block":true,"$key":">p"}],null]
  ["<document 文=zh/><foo bar baz=42>something<br/>else</thing></foo>",[{"data":{"文":"zh"},"$key":"<document"},{"$key":">document"},{"data":{"bar":true,"baz":"42"},"$key":"<foo"},{"text":"something","$key":"^text"},{"$key":"<br"},{"$key":">br"},{"text":"else","$key":"^text"},{"$key":">thing"},{"$key":">foo"}],null]
  ["<p foo bar=<>yeah</p>",[{"data":{"foo":true,"bar":"<"},"is_block":true,"$key":"<p"},{"text":"yeah","$key":"^text"},{"is_block":true,"$key":">p"}],null]
  ["<p foo bar='<'>yeah</p>",[{"data":{"foo":true,"bar":"<"},"is_block":true,"$key":"<p"},{"text":"yeah","$key":"^text"},{"is_block":true,"$key":">p"}],null]
  ["<p foo bar='&lt;'>yeah</p>",[{"data":{"foo":true,"bar":"&lt;"},"is_block":true,"$key":"<p"},{"text":"yeah","$key":"^text"},{"is_block":true,"$key":">p"}],null]
  ["<<<<<",[{"text":"<<<<","$key":"^text"}],null]
  ["something",[{"text":"something","$key":"^text"}],null]
  ["else",[{"text":"else","$key":"^text"}],null]
  ["<p>dangling",[{"is_block":true,"$key":"<p"},{"text":"dangling","$key":"^text"}],null]
  ["𦇻𦑛𦖵𦩮𦫦𧞈",[{"text":"𦇻𦑛𦖵𦩮𦫦𧞈","$key":"^text"}],null]
  ]

#-----------------------------------------------------------------------------------------------------------
show = ( html, datoms ) ->
  help CND.red html
  for d in datoms
    if d.text?
      info d.$key, ( CND.white jr d.text )
    else
      if d.data? # and ( Object.keys d.data ).length > 0
        info d.$key, ( CND.yellow jr d.data )
      else
        info d.$key
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "parse html to list (onepiece)" ] = ( T, done ) ->
  SP = require '../..'
  T.eq ( type_of SP.HTML.new_onepiece_parser ), 'function'
  parse = SP.HTML.new_onepiece_parser()
  #.........................................................................................................
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      html    = probe
      result  = parse html
      # show html, result
      resolve result
      return null
  #.........................................................................................................
  done()
  return null

###


#-----------------------------------------------------------------------------------------------------------
@[ "HTML.html_as_datoms (dubious)" ] = ( T, done ) ->
  probes_and_matchers = [
    ### TAINT these edge cases should be solved by an appropriate (MKTScript) pre-processor; NB that in
    MKTScript stray pointy brackets in ordinary text (but not in `<code>` blocks) are forbidden and must
    be escaped as entities wherever they appear in attribute values; these rules, however, do not
    necessarily apply when parsing general HTML sources. ###
    ###
    ["< >",[{"text":"< >","$key":"^text"}],null]          # !!! silent failure
    ["< x >",[{"text":"< x >","$key":"^text"}],null]      # !!! silent failure
    ["<>",[{"text":"<>","$key":"^text"}],null]            # !!! silent failure
    ["<",[{"text":"<","$key":"^text"}],null]              # !!! silent failure
    ["<tag",[{"text":"<tag","$key":"^text"}],null]        # !!! silent failure
    ###
    ["if <math> a > b </math> then",[{"text":"if ","$key":"^text"},{"$key":"<math"},{"text":" a > b ","$key":"^text"},{"$key":">math"},{"text":" then","$key":"^text"}],null]
    [">",[{"text":">","$key":"^text"}],null]
    ["&",[{"text":"&","$key":"^text"}],null]
    ["&amp;",[{"text":"&amp;","$key":"^text"}],null]
    ["<tag a='<'>",[{"a":"<","$key":"<tag"}],null]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      resolve HTML.html_as_datoms probe
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.html_as_datoms (2)" ] = ( T, done ) ->
  probes_and_matchers = [
    ["<!DOCTYPE html>","<!DOCTYPE html>",null]
    ["<!DOCTYPE obvious>","<!DOCTYPE obvious>",null]
    ["<p contenteditable>","<p contenteditable>",null]
    ["<img width=200>","<img width=200>",null]
    ["<dang z=Z a=A>","<dang a=A z=Z>",null]
    ["<foo/>","<foo>|</foo>",null]
    ["<foo></foo>","<foo>|</foo>",null]
    ["<p>here and<br>there","<p>|here and|<br>|there",null]
    ["<p>here and<br>there</p>","<p>|here and|<br>|there|</p>",null]
    ["<p>here and<br/>there</p>","<p>|here and|<br>|</br>|there|</p>",null]
    ["just some plain text","just some plain text",null]
    ["<p>one<p>two","<p>|one|<p>|two",null]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      resolve ( HTML.datom_as_html d for d in  HTML.html_as_datoms probe ).join '|'
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.$html_as_datoms" ] = ( T, done ) ->
  SP                        = require 'steampipes'
  # SP                        = require '../../apps/steampipes'
  { $
    $async
    $drain
    $watch
    $show  }                = SP.export()
  #.........................................................................................................
  probe         = """
    <p>A <em>concise</em> introduction to the things discussed below.</p>
    """
  matcher = [{"$key":"<p"},{"text":"A ","$key":"^text"},{"$key":"<em"},{"text":"concise","$key":"^text"},{"$key":">em"},{"text":" introduction to the things discussed below.","$key":"^text"},{"$key":">p"}]
  #.........................................................................................................
  pipeline      = []
  pipeline.push [ ( Buffer.from probe ), ]
  pipeline.push SP.$split()
  pipeline.push HTML.$html_as_datoms()
  pipeline.push $show()
  pipeline.push $drain ( result ) =>
    help jr result
    T.eq result, matcher
    done()
  SP.pull pipeline...
  #.........................................................................................................
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.parse_compact_tagname" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  { parse_compact_tagname
    h }                     = INTERTEXT.HTML.export()
  #.........................................................................................................
  probes_and_matchers = [
    ["foo-bar",{"tagname":"foo-bar"},null]
    ["foo-bar#c55",{"tagname":"foo-bar","id":"c55"},null]
    ["foo-bar.blah.beep",{"tagname":"foo-bar","class":"blah beep"},null]
    ["foo-bar#c55.blah.beep",{"tagname":"foo-bar","id":"c55","class":"blah beep"},null]
    ["#c55",{id:"c55"}]
    [".blah.beep",{"class":"blah beep"}]
    ["...#",null,"illegal compact tag syntax"]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      resolve parse_compact_tagname probe
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.dhtml" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  { parse_compact_tagname
    dhtml }                 = INTERTEXT.HTML.export()
  #.........................................................................................................
  probes_and_matchers = [
    [["div"],[{"$key":"^div"}],null]
    [["div#x32"],[{"$key":"^div","id":"x32"}],null]
    [["div.foo"],[{"$key":"^div","class":"foo"}],null]
    [["div#x32.foo"],[{"$key":"^div","id":"x32","class":"foo"}],null]
    [["div#x32",{"alt":"nice guy"}],[{"$key":"^div","id":"x32","alt":"nice guy"}],null]
    [["div#x32",{"alt":"nice guy"}," a > b & b > c => a > c"],[{"id":"x32","alt":"nice guy","$key":"<div"},{"text":" a > b & b > c => a > c","$key":"^text"},{"$key":">div"}],null]
    [["foo-bar"],[{"$key":"^foo-bar"}],null]
    [["foo-bar#c55"],[{"$key":"^foo-bar","id":"c55"}],null]
    [["foo-bar.blah.beep"],[{"$key":"^foo-bar","class":"blah beep"}],null]
    [["foo-bar#c55.blah.beep"],[{"$key":"^foo-bar","id":"c55","class":"blah beep"}],null]
    [["div#sidebar.green", { id: 'd3', class: "orange"}, ],[{"id":"d3","class":"orange","$key":"^div"}],null]
    [["#c55"],null,"not a valid intertext_html_tagname"]
    [[".blah.beep"],null,"not a valid intertext_html_tagname"]
    [["...#"],null,"illegal compact tag syntax"]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      # urge h probe...
      resolve dhtml probe...
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datoms_as_html (1)" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  { datoms_as_html
    dhtml }                 = INTERTEXT.HTML.export()
  #.........................................................................................................
  probes_and_matchers = [
    [["div"],"<div></div>",null]
    [["div#x32"],"<div id=x32></div>",null]
    [["div.foo"],"<div class=foo></div>",null]
    [["div#x32.foo"],"<div class=foo id=x32></div>",null]
    [["div#x32",{"alt":"nice guy"}],"<div alt='nice guy' id=x32></div>",null]
    [["div#x32",{"alt":"nice guy"}," a > b & b > c => a > c"],"<div alt='nice guy' id=x32> a &gt; b &amp; b &gt; c =&gt; a &gt; c</div>",null]
    [["foo-bar"],"<foo-bar></foo-bar>",null]
    [["foo-bar#c55"],"<foo-bar id=c55></foo-bar>",null]
    [["foo-bar.blah.beep"],"<foo-bar class='blah beep'></foo-bar>",null]
    [["foo-bar#c55.blah.beep"],"<foo-bar class='blah beep' id=c55></foo-bar>",null]
    [["#c55"],null,"not a valid intertext_html_tagname"]
    [[".blah.beep"],null,"not a valid intertext_html_tagname"]
    [["...#"],null,"illegal compact tag syntax"]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      # urge datoms_as_html dhtml probe...
      resolve datoms_as_html dhtml probe...
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datoms_as_html (2)" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  { datoms_as_html
    dhtml }                 = INTERTEXT.HTML.export()
  #.........................................................................................................
  urge ds = dhtml 'article#c2', { editable: true, }, ( dhtml 'h1', "A truly curious Coincidence" )
  T.eq ds, [
    { '$key': '<article', id: 'c2', editable: true },
    { '$key': '<h1' },
    { '$key': '^text', text: 'A truly curious Coincidence' },
    { '$key': '>h1' }
    { '$key': '>article' }
    ]
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML.datoms_as_html (3)" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  { datoms_as_html
    dhtml }                 = INTERTEXT.HTML.export()
  #.........................................................................................................
  urge ds = dhtml 'article#c2', { editable: true, },
    dhtml 'h1', "A truly curious Coincidence"
    dhtml 'p.noindent', ( dhtml 'em', "Seriously," ), " he said, ", ( dhtml 'em', "we'd better start cooking now." )
  #.........................................................................................................
  whisper jr datoms_as_html ds
  T.eq ( datoms_as_html ds ), "<article editable id=c2><h1>A truly curious Coincidence</h1><p class=noindent><em>Seriously,</em> he said, <em>we'd better start cooking now.</em></p></article>"
  T.eq ds, [
    { '$key': '<article', id: 'c2', editable: true },
    { '$key': '<h1' },
    { '$key': '^text', text: 'A truly curious Coincidence' },
    { '$key': '>h1' },
    { '$key': '<p', class: 'noindent' },
    { '$key': '<em' },
    { '$key': '^text', text: 'Seriously,' },
    { '$key': '>em' },
    { '$key': '^text', text: ' he said, ' },
    { '$key': '<em' },
    { '$key': '^text', text: "we'd better start cooking now." },
    { '$key': '>em' },
    { '$key': '>p' },
    { '$key': '>article' }
    ]
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "_HTML.datoms_as_html (4)" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  { datoms_as_html
    datom_as_html
    new_dhtml_writer }      = INTERTEXT.HTML.export()
  #.........................................................................................................
  dhtml = new_dhtml_writer()
  # debug '^2223^', dhtml.text "R&B"
  # debug '^2223^', dhtml
  debug '^7778^', INTERTEXT.HTML.dhtml 'one', ( INTERTEXT.HTML.dhtml 'two', 'here' )
  debug '^7778^', datoms_as_html INTERTEXT.HTML.dhtml 'one', ( INTERTEXT.HTML.dhtml 'two', 'here' )
  whisper '^7778^', '------------------------------------------'
  dhtml 'one', ( dhtml 'between' ), ->
    dhtml 'two', 'here'
      # dhtml 'three' # , ->
  # dhtml 'article#c2', { editable: true, }, ->
  #   dhtml 'h1', "A truly curious Coincidence"
  #   dhtml 'p.noindent', ->
  #     dhtml 'em', "Seriously,"
  #     dhtml.text " he said, "
  #     dhtml 'em', "we'd better start cooking now."
  #.........................................................................................................
  info dhtml.expand()
  #.........................................................................................................
  done() if done?
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML specials" ] = ( T, done ) ->
  INTERTEXT                 = require '../..'
  { datoms_as_html
    dhtml }                 = INTERTEXT.HTML.export()
  #.........................................................................................................
  probes_and_matchers = [
    [["script",( -> square = ( ( x ) -> x ** 2 ); console.log square 42 )],[[{"$key":"<script"},{"text":"(function() {\n            var square;\n            square = (function(x) {\n              return x ** 2;\n            });\n            return console.log(square(42));\n          })();","$key":"^raw"},{"$key":">script"}],"<script>(function() {\n            var square;\n            square = (function(x) {\n              return x ** 2;\n            });\n            return console.log(square(42));\n          })();</script>"],null]
    [["script","path to app.js"],[[{"src":"path to app.js","$key":"^script"}],"<script src='path to app.js'></script>"],null]
    [["css","path/to/styles.css"],[[{"rel":"stylesheet","href":"path/to/styles.css","$key":"^link"}],"<link href=path/to/styles.css rel=stylesheet></link>"],null]
    [["text","a b c < & >"],[[{"text":"a b c < & >","$key":"^text"}],"a b c &lt; &amp; &gt;"],null]
    [["raw","a b c < & >"],[[{"text":"a b c < & >","$key":"^raw"}],"a b c < & >"],null]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      [ key, P..., ] = probe
      result  = INTERTEXT.HTML[ key ] P...
      result  = [ result, ( datoms_as_html result ), ]
      resolve result
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML demo" ] = ( T, done ) ->
  text = """<!DOCTYPE html>
  <h1><strong>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>

  <p id=p227>However, the egg only got larger and larger, and <em>more and more human</em>:<br>

  when she had come within a few yards of it, she saw that it had eyes and a nose and mouth; and when she
  had come close to it, she saw clearly that it was <name ref=hd556>HUMPTY DUMPTY</name> himself. ‘It can’t
  be anybody else!’ she said to herself.<br/>

  ‘I’m as certain of it, as if his name were written all over his face.’

  """
  for d in datoms = HTML.html_as_datoms text
    echo jr d
  echo '-'.repeat 108
  echo ( HTML.datom_as_html d for d in datoms ).join ''
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "HTML demo (buffer)" ] = ( T, done ) ->
  text    = """<!DOCTYPE html>
  <h1><strong>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>"""
  buffer  = Buffer.from text
  debug '^80009^', buffer
  for d in datoms = HTML.html_as_datoms buffer
    echo jr d
  echo '-'.repeat 108
  echo ( HTML.datom_as_html d for d in datoms ).join ''
  #.........................................................................................................
  done()
  return null


############################################################################################################
if module is require.main then do => # await do =>
  # await @_demo()
  test @
  # test @[ "HTML.parse_compact_tagname" ]
  # test @[ "HTML.dhtml" ]
  # test @[ "isa.intertext_html_tagname (2)" ]
  # test @[ "HTML.datoms_as_html (4)" ]
  # @[ "HTML.datoms_as_html (4)" ]()
  # test @[ "HTML specials" ]
  help 'ok'






