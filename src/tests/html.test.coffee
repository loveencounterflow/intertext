
# 'use strict'

# ############################################################################################################
# CND                       = require 'cnd'
# rpr                       = CND.rpr
# badge                     = 'INTERTEXT/TESTS/HTML'
# log                       = CND.get_logger 'plain',     badge
# info                      = CND.get_logger 'info',      badge
# whisper                   = CND.get_logger 'whisper',   badge
# alert                     = CND.get_logger 'alert',     badge
# debug                     = CND.get_logger 'debug',     badge
# warn                      = CND.get_logger 'warn',      badge
# help                      = CND.get_logger 'help',      badge
# urge                      = CND.get_logger 'urge',      badge
# echo                      = CND.echo.bind CND
# { jr, }                   = CND
# #...........................................................................................................
# test                      = require 'guy-test'


# #===========================================================================================================
# # TESTS
# #-----------------------------------------------------------------------------------------------------------
# @[ "must quote attribute value" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   types                     = require '../types'
#   { isa
#     validate
#     type_of }               = INTERTEXT.types
#   probes_and_matchers = [
#     [ "",           true,   null, ]
#     [ "\"",         true,   null, ]
#     [ "'",          true,   null, ]
#     [ "<",          true,   null, ]
#     [ "<>",         true,   null, ]
#     [ "foo",        false,  null, ]
#     [ "foo bar",    true,   null, ]
#     [ "foo\nbar",   true,   null, ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       must_quote = not isa.intertext_html_naked_attribute_value probe
#       resolve must_quote
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "DATOM.HTML._as_attribute_literal" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     [ "",           "''",                       null, ]
#     [ '"',          '\'"\'',                    null, ]
#     [ "'",          "'&#39;'",                  null, ]
#     [ "<",          "'&lt;'",                   null, ]
#     [ "<>",         "'&lt;&gt;'",               null, ]
#     [ "foo",        "foo",                      null, ]
#     [ "foo bar",    "'foo bar'",                null, ]
#     [ "foo\nbar",   "'foo&#10;bar'",            null, ]
#     [ "'<>'",       "'&#39;&lt;&gt;&#39;'",     null, ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       resolve HTML._as_attribute_literal probe
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "isa.intertext_html_tagname (1)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   types                     = require '../types'
#   { isa
#     validate
#     type_of }               = INTERTEXT.types
#   probes_and_matchers = [
#     [ "",             false,  null, ]
#     [ "\"",           false,  null, ]
#     [ "'",            false,  null, ]
#     [ "<",            false,  null, ]
#     [ "<>",           false,  null, ]
#     [ "foo bar",      false,  null, ]
#     [ "foo\nbar",     false,  null, ]
#     [ "foo",          true,   null, ]
#     [ "此は何ですか", true,   null, ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       resolve isa.intertext_html_tagname probe
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "isa.intertext_html_tagname (2)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   types                     = require '../types'
#   { isa
#     validate
#     type_of }               = INTERTEXT.types
#   probes = """a abbr acronym address applet area article aside audio b base basefont bdi bdo bgsound big
#   blink blockquote body br button canvas caption center cite code col colgroup command datalist dd del
#   details dfn dialog dir div dl dt em embed fieldset figcaption figure font footer form frame frameset h1 h2
#   h3 h4 h5 h6 head header hgroup hr html i iframe img input ins isindex kbd keygen label legend li link
#   listing main map mark marquee menu meta meter multicol nav nextid nobr noembed noframes noscript object ol
#   optgroup option output p param plaintext pre progress q rb rp rt ruby s samp script section select small
#   source spacer span strike strong sub summary sup table tbody td textarea tfoot th thead time title tr
#   track tt u ul video wbr xmp
#   foo:bar foo-bar Foo-bar
#   """.split /\s+/
#   for probe in probes
#     await T.perform probe, true, null, -> new Promise ( resolve ) ->
#       resolve isa.intertext_html_tagname probe
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (singular tags)" ] = ( T, done ) ->
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     [ [ '^foo', ],                                    "<foo></foo>",                                       ]
#     [ [ '^foo', { height: 42,               }, ],     "<foo height=42></foo>",                             ]
#     [ [ '^foo', { class: 'plain',           }, ],     "<foo class=plain></foo>",                           ]
#     [ [ '^foo', { class: 'plain hilite',    }, ],     "<foo class='plain hilite'></foo>",                  ]
#     [ [ '^foo', { editable: true,           }, ],     "<foo editable></foo>",                              ]
#     [ [ '^foo', { empty: '',                }, ],     "<foo empty=''></foo>",                              ]
#     [ [ '^foo', { specials: '<\n\'"&>',     }, ],     "<foo specials='&lt;&#10;&#39;\"&amp;&gt;'></foo>",  ]
#     [ [ '^something', { one: 1, two: 2,     }, ],     "<something one=1 two=2></something>",               ]
#     [ [ '^something', { z: 'Z', a: 'A',     }, ],     "<something a=A z=Z></something>",                   ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       d = new_datom probe...
#       resolve HTML.html_from_datoms d
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (closing tags)" ] = ( T, done ) ->
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     [ [ '>foo', ],                                    "</foo>",           ]
#     [ [ '>foo', { height: 42,               }, ],     "</foo>",           ]
#     [ [ '>foo', { class: 'plain',           }, ],     "</foo>",           ]
#     [ [ '>foo', { class: 'plain hilite',    }, ],     "</foo>",           ]
#     [ [ '>foo', { editable: true,           }, ],     "</foo>",           ]
#     [ [ '>foo', { empty: '',                }, ],     "</foo>",           ]
#     [ [ '>foo', { specials: '<\n\'"&>',     }, ],     "</foo>",           ]
#     [ [ '>something', { one: 1, two: 2,     }, ],     "</something>",     ]
#     [ [ '>something', { z: 'Z', a: 'A',     }, ],     "</something>",     ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       d = new_datom probe...
#       resolve HTML.html_from_datoms d
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (opening tags)" ] = ( T, done ) ->
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     [ [ '<foo', ],                                    "<foo>",                                        ]
#     [ [ '<foo', { height: 42,               }, ],     "<foo height=42>",                              ]
#     [ [ '<foo', { class: 'plain',           }, ],     "<foo class=plain>",                            ]
#     [ [ '<foo', { class: 'plain hilite',    }, ],     "<foo class='plain hilite'>",                   ]
#     [ [ '<foo', { editable: true,           }, ],     "<foo editable>",                               ]
#     [ [ '<foo', { empty: '',                }, ],     "<foo empty=''>",                               ]
#     [ [ '<foo', { specials: '<\n\'"&>',     }, ],     "<foo specials='&lt;&#10;&#39;\"&amp;&gt;'>",   ]
#     [ [ '<something', { one: 1, two: 2,     }, ],     "<something one=1 two=2>",                      ]
#     [ [ '<something', { z: 'Z', a: 'A',     }, ],     "<something a=A z=Z>",                          ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       d = new_datom probe...
#       resolve HTML.html_from_datoms d
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (texts)" ] = ( T, done ) ->
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     [ [ '^text', ],                                    "",                            ]
#     [ [ '^text', { height: 42,               }, ],     "",                            ]
#     [ [ '^text', { text: '<me & you>\n',     }, ],     "&lt;me &amp; you&gt;\n",      ]
#     [ [ '<text', { z: 'Z', a: 'A',           }, ],     "<text a=A z=Z>",              ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       d = new_datom probe...
#       resolve HTML.html_from_datoms d
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (opening tags w/ $value)" ] = ( T, done ) ->
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     [ [ '<foo', ],                                    "<foo>",                                        ]
#     [ [ '<foo', { ignored: 'xxx', $value: { height: 42,              }, }, ], "<foo height=42>",                              ]
#     [ [ '<foo', { ignored: 'xxx', $value: { class: 'plain',          }, }, ], "<foo class=plain>",                            ]
#     [ [ '<foo', { ignored: 'xxx', $value: { class: 'plain hilite',   }, }, ], "<foo class='plain hilite'>",                   ]
#     [ [ '<foo', { ignored: 'xxx', $value: { editable: true,          }, }, ], "<foo editable>",                               ]
#     [ [ '<foo', { ignored: 'xxx', $value: { empty: '',               }, }, ], "<foo empty=''>",                               ]
#     [ [ '<foo', { ignored: 'xxx', $value: { specials: '<\n\'"&>',    }, }, ], "<foo specials='&lt;&#10;&#39;\"&amp;&gt;'>",   ]
#     [ [ '<something', { ignored: 'xxx', $value: { one: 1, two: 2,    }, }, ], "<something one=1 two=2>",                      ]
#     [ [ '<something', { ignored: 'xxx', $value: { z: 'Z', a: 'A',    }, }, ], "<something a=A z=Z>",                          ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       d = new_datom probe...
#       resolve HTML.html_from_datoms d
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (system tags)" ] = ( T, done ) ->
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     [["~foo"],"<x-sys x-key=foo><x-sys-key>foo</x-sys-key></x-sys>",null]
#     [["~foo",{"height":42}],"<x-sys x-key=foo height=42><x-sys-key>foo</x-sys-key></x-sys>",null]
#     [["[foo",{"class":"plain"}],"<x-sys x-key=foo class=plain><x-sys-key>foo</x-sys-key>",null]
#     [["[foo",{"class":"plain hilite"}],"<x-sys x-key=foo class='plain hilite'><x-sys-key>foo</x-sys-key>",null]
#     [["]foo",{"editable":true}],"</x-sys>",null]
#     [["]foo",{"empty":""}],"</x-sys>",null]
#     [["~foo",{"specials":"<\n'\"&>"}],"<x-sys x-key=foo specials='&lt;&#10;&#39;\"&amp;&gt;'><x-sys-key>foo</x-sys-key></x-sys>",null]
#     [["~something",{"one":1,"two":2}],"<x-sys x-key=something one=1 two=2><x-sys-key>something</x-sys-key></x-sys>",null]
#     [["~something",{"z":"Z","a":"A"}],"<x-sys x-key=something a=A z=Z><x-sys-key>something</x-sys-key></x-sys>",null]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       d = new_datom probe...
#       resolve HTML.html_from_datoms d
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (raw pseudo-tag)" ] = ( T, done ) ->
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     [ [ '^raw', ],                                    "",                                       ]
#     [ [ '^raw', { height: 42,               }, ],     "",                                       ]
#     [ [ '^raw', { text: '<\n\'"&>',           }, ],   '<\n\'"&>',                               ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       d = new_datom probe...
#       resolve HTML.html_from_datoms d
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (doctype)" ] = ( T, done ) ->
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     [ [ '^doctype', ],                  "<!DOCTYPE html>",        ]
#     [ [ '^doctype', { height: 42, }, ], "<!DOCTYPE html>",        ]
#     [ [ '^doctype', "obvious", ],       "<!DOCTYPE obvious>",     ]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       d = new_datom probe...
#       resolve HTML.html_from_datoms d
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.datoms_from_html (1)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     ["<!DOCTYPE html>",[{"$key":"^report","source":"<!DOCTYPE html>","errors":[]},{"$key":"^DOCTYPE","text":"<!DOCTYPE html>","start":0,"stop":15,"escaped":true}],null]
#     ["<!DOCTYPE obvious>",[{"$key":"^report","source":"<!DOCTYPE obvious>","errors":[]},{"$key":"^DOCTYPE","text":"<!DOCTYPE obvious>","start":0,"stop":18,"escaped":true}],null]
#     ["<img width=200>",[{"$key":"^report","source":"<img width=200>","errors":[]},{"$key":"<tag","name":"img","type":"otag","text":"<img width=200>","start":0,"stop":15,"atrs":{"width":"200"}}],null]
#     ["<foo/>",[{"$key":"^report","source":"<foo/>","errors":[]},{"$key":"<tag","name":"foo","type":"stag","text":"<foo/>","start":0,"stop":6}],null]
#     ["<foo></foo>",[{"$key":"^report","source":"<foo></foo>","errors":[]},{"$key":"<tag","name":"foo","type":"otag","text":"<foo>","start":0,"stop":5},{"$key":">tag","name":"foo","type":"ctag","text":"</foo>","start":5,"stop":11}],null]
#     ["<p>here and<br></br>there</p>",[{"$key":"^report","source":"<p>here and<br></br>there</p>","errors":[]},{"$key":"<tag","name":"p","type":"otag","text":"<p>","start":0,"stop":3},{"$key":"^text","text":"here and","start":3,"stop":11},{"$key":"<tag","name":"br","type":"otag","text":"<br>","start":11,"stop":15},{"$key":">tag","name":"br","type":"ctag","text":"</br>","start":15,"stop":20},{"$key":"^text","text":"there","start":20,"stop":25},{"$key":">tag","name":"p","type":"ctag","text":"</p>","start":25,"stop":29}],null]
#     ["<p>here and<br>there",[{"$key":"^report","source":"<p>here and<br>there","errors":[]},{"$key":"<tag","name":"p","type":"otag","text":"<p>","start":0,"stop":3},{"$key":"^text","text":"here and","start":3,"stop":11},{"$key":"<tag","name":"br","type":"otag","text":"<br>","start":11,"stop":15},{"$key":"^text","text":"there","start":15,"stop":20}],null]
#     ["<p>here and<br>there</p>",[{"$key":"^report","source":"<p>here and<br>there</p>","errors":[]},{"$key":"<tag","name":"p","type":"otag","text":"<p>","start":0,"stop":3},{"$key":"^text","text":"here and","start":3,"stop":11},{"$key":"<tag","name":"br","type":"otag","text":"<br>","start":11,"stop":15},{"$key":"^text","text":"there","start":15,"stop":20},{"$key":">tag","name":"p","type":"ctag","text":"</p>","start":20,"stop":24}],null]
#     ["<p>here and<br x=42/>there</p>",[{"$key":"^report","source":"<p>here and<br x=42/>there</p>","errors":[]},{"$key":"<tag","name":"p","type":"otag","text":"<p>","start":0,"stop":3},{"$key":"^text","text":"here and","start":3,"stop":11},{"$key":"<tag","name":"br","type":"stag","text":"<br x=42/>","start":11,"stop":21,"atrs":{"x":"42"}},{"$key":"^text","text":"there","start":21,"stop":26},{"$key":">tag","name":"p","type":"ctag","text":"</p>","start":26,"stop":30}],null]
#     ["<p>here and<br/>there</p>",[{"$key":"^report","source":"<p>here and<br/>there</p>","errors":[]},{"$key":"<tag","name":"p","type":"otag","text":"<p>","start":0,"stop":3},{"$key":"^text","text":"here and","start":3,"stop":11},{"$key":"<tag","name":"br","type":"stag","text":"<br/>","start":11,"stop":16},{"$key":"^text","text":"there","start":16,"stop":21},{"$key":">tag","name":"p","type":"ctag","text":"</p>","start":21,"stop":25}],null]
#     ["just some plain text",[{"$key":"^report","source":"just some plain text","errors":[]},{"$key":"^text","text":"just some plain text","start":0,"stop":20}],null]
#     ["<p>one<p>two",[{"$key":"^report","source":"<p>one<p>two","errors":[]},{"$key":"<tag","name":"p","type":"otag","text":"<p>","start":0,"stop":3},{"$key":"^text","text":"one","start":3,"stop":6},{"$key":"<tag","name":"p","type":"otag","text":"<p>","start":6,"stop":9},{"$key":"^text","text":"two","start":9,"stop":12}],null]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       resolve HTML.datoms_from_html probe
#   #.........................................................................................................
#   done()
#   return null

# ###
# #-----------------------------------------------------------------------------------------------------------
# probes_and_matchers = [
#   ["<!DOCTYPE html>",[{"data":{"html":true},"$key":"<!DOCTYPE"}],null]
#   ["<title>MKTS</title>",[{"$key":"<title"},{"text":"MKTS","$key":"^text"},{"$key":">title"}],null]
#   ["<document/>",[{"$key":"<document"},{"$key":">document"}],null]
#   ["<foo bar baz=42>",[{"data":{"bar":true,"baz":"42"},"$key":"<foo"}],null]
#   ["<br/>",[{"$key":"^br"}],null]
#   ["</thing>",[{"$key":">thing"}],null]
#   ["</foo>",[{"$key":">foo"}],null]
#   ["</document>",[{"$key":">document"}],null]
#   ["<title>MKTS</title>",[{"$key":"<title"},{"text":"MKTS","$key":"^text"},{"$key":">title"}],null]
#   ["<p foo bar=42>omg</p>",[{"data":{"foo":true,"bar":"42"},"is_block":true,"$key":"<p"},{"text":"omg","$key":"^text"},{"is_block":true,"$key":">p"}],null]
#   ["<document/><foo bar baz=42>something<br/>else</thing></foo>",[{"$key":"<document"},{"$key":">document"},{"data":{"bar":true,"baz":"42"},"$key":"<foo"},{"text":"something","$key":"^text"},{"$key":"^br"},{"text":"else","$key":"^text"},{"$key":">thing"},{"$key":">foo"}],null]
#   ["<!DOCTYPE html><html lang=en><head><title>x</title></head><p data-x='<'>helo</p></html>",[{"data":{"html":true},"$key":"<!DOCTYPE"},{"data":{"lang":"en"},"$key":"<html"},{"$key":"<head"},{"$key":"<title"},{"text":"x","$key":"^text"},{"$key":">title"},{"$key":">head"},{"data":{"data-x":"<"},"is_block":true,"$key":"<p"},{"text":"helo","$key":"^text"},{"is_block":true,"$key":">p"},{"$key":">html"}],null]
#   ["<p foo bar=42><em>Yaffir stood high</em></p>",[{"data":{"foo":true,"bar":"42"},"is_block":true,"$key":"<p"},{"$key":"<em"},{"text":"Yaffir stood high","$key":"^text"},{"$key":">em"},{"is_block":true,"$key":">p"}],null]
#   ["<p foo bar=42><em><xxxxxxxxxxxxxxxxxxx>Yaffir stood high</p>",[{"data":{"foo":true,"bar":"42"},"is_block":true,"$key":"<p"},{"$key":"<em"},{"$key":"<xxxxxxxxxxxxxxxxxxx"},{"text":"Yaffir stood high","$key":"^text"},{"is_block":true,"$key":">p"}],null]
#   ["<p föö bär=42><em>Yaffir stood high</p>",[{"data":{"föö":true,"bär":"42"},"is_block":true,"$key":"<p"},{"$key":"<em"},{"text":"Yaffir stood high","$key":"^text"},{"is_block":true,"$key":">p"}],null]
#   ["<document 文=zh/><foo bar baz=42>something<br/>else</thing></foo>",[{"data":{"文":"zh"},"$key":"<document"},{"$key":">document"},{"data":{"bar":true,"baz":"42"},"$key":"<foo"},{"text":"something","$key":"^text"},{"$key":"^br"},{"text":"else","$key":"^text"},{"$key":">thing"},{"$key":">foo"}],null]
#   ["<p foo bar=<>yeah</p>",[{"data":{"foo":true,"bar":"<"},"is_block":true,"$key":"<p"},{"text":"yeah","$key":"^text"},{"is_block":true,"$key":">p"}],null]
#   ["<p foo bar='<'>yeah</p>",[{"data":{"foo":true,"bar":"<"},"is_block":true,"$key":"<p"},{"text":"yeah","$key":"^text"},{"is_block":true,"$key":">p"}],null]
#   ["<p foo bar='&lt;'>yeah</p>",[{"data":{"foo":true,"bar":"&lt;"},"is_block":true,"$key":"<p"},{"text":"yeah","$key":"^text"},{"is_block":true,"$key":">p"}],null]
#   ["<<<<<",[{"text":"<<<<","$key":"^text"}],null]
#   ["something",[{"text":"something","$key":"^text"}],null]
#   ["else",[{"text":"else","$key":"^text"}],null]
#   ["<p>dangling",[{"is_block":true,"$key":"<p"},{"text":"dangling","$key":"^text"}],null]
#   ["𦇻𦑛𦖵𦩮𦫦𧞈",[{"text":"𦇻𦑛𦖵𦩮𦫦𧞈","$key":"^text"}],null]
#   ]

# ###


# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.datoms_from_html (dubious)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   DEMO                      = require '../chevrotain-html/demo'
#   probes_and_matchers = [
#     ["< >","^error-MismatchedTokenException-mismatch-parser-2-2->",null]
#     ["< x >","<tag-x-0-5-< x >-otag",null]
#     ["<>","^error-MismatchedTokenException-mismatch-parser-1-1->",null]
#     ["<","^error-MismatchedTokenException-mismatch-parser-0-0-<",null]
#     ["<tag","^error-NoViableAltException-missing-parser-1-3-tag",null]
#     ["if <math> a > b </math> then","^text-0-3-if #<tag-math-3-9-<math>-otag#^text-9-16- a > b #>tag-math-16-23-</math>-ctag#^text-23-28- then",null]
#     [">","^text-0-1->",null]
#     ["&","^text-0-1-&",null]
#     ["&amp;","^text-0-5-&amp;",null]
#     ["<tag a='<'>","<tag-{\"a\":\"'<'\"}-tag-0-11-<tag a='<'>-otag",null]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       resolve DEMO.condense_tokens HTML.datoms_from_html probe
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.datoms_from_html (2)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   probes_and_matchers = [
#     ["<!DOCTYPE html>","<!DOCTYPE html>",null]
#     # ["<!DOCTYPE obvious>","<!DOCTYPE obvious>",null]
#     # ["<p contenteditable>","<p contenteditable>",null]
#     # ["<dang z=Z a=A>","<dang a=A z=Z>",null]
#     # ["<foo/>","<foo>|</foo>",null]
#     # ["<foo></foo>","<foo>|</foo>",null]
#     # ["just some plain text","just some plain text",null]
#     # ["<p>one<p>two","<p>|one|<p>|two",null]
#     # ["<p>here and</br>there","<p>|here and|there",null]
#     # ["<img width=200>","<img width=200>",null]
#     # ["<p>here and<br>there","<p>|here and|<br>|there",null]
#     # ["<p>here and<br>there</p>","<p>|here and|<br>|there|</p>",null]
#     # ["<p>here and<br/>there</p>","<p>|here and|<br>|there|</p>",null]
#       # @parse """bare value: <t a=v>"""
#       # @parse """bare value: <t a=v'w>"""
#       # @parse """bare value: <t a=v"w>"""
#       # @parse """squot value: <t a='v'>"""
#       # @parse """dquot value: <t a="v">"""
#       # @parse """squot value: <t a='"v"'>"""
#       # @parse """dquot value: <t a="'v'">"""
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       debug '^30^', datoms  = HTML.datoms_from_html probe
#       urge '^30^',  html    = HTML.html_from_datoms datoms
#       resolve ( HTML.html_from_datoms d for d in HTML.datoms_from_html probe ).join '|'
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.$datoms_from_html" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   SP                        = require 'steampipes'
#   # SP                        = require '../../apps/steampipes'
#   { $
#     $async
#     $drain
#     $watch
#     $show  }                = SP.export()
#   #.........................................................................................................
#   probe         = """
#     <p>A <em>concise</em> introduction to the things discussed below.</p>
#     """
#   matcher = [{"$key":"<p"},{"text":"A ","$key":"^text"},{"$key":"<em"},{"text":"concise","$key":"^text"},{"$key":">em"},{"text":" introduction to the things discussed below.","$key":"^text"},{"$key":">p"}]
#   #.........................................................................................................
#   pipeline      = []
#   pipeline.push [ ( Buffer.from probe ), ]
#   pipeline.push SP.$split()
#   pipeline.push HTML.$datoms_from_html()
#   pipeline.push $show()
#   pipeline.push $drain ( result ) =>
#     help jr result
#     T.eq result, matcher
#     done()
#   SP.pull pipeline...
#   #.........................................................................................................
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML._parse_compact_tagname" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { _parse_compact_tagname
#     h }                     = INTERTEXT.HTML.export()
#   #.........................................................................................................
#   probes_and_matchers = [
#     ["foo-bar",{"tagname":"foo-bar"},null]
#     ["foo-bar#c55",{"tagname":"foo-bar","id":"c55"},null]
#     ["foo-bar.blah.beep",{"tagname":"foo-bar","class":"blah beep"},null]
#     ["foo-bar#c55.blah.beep",{"tagname":"foo-bar","id":"c55","class":"blah beep"},null]
#     ["#c55",{id:"c55"}]
#     [".blah.beep",{"class":"blah beep"}]
#     ["...#",null,"illegal compact tag syntax"]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       resolve _parse_compact_tagname probe
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.tag" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { _parse_compact_tagname
#     tag }                 = INTERTEXT.HTML.export()
#   #.........................................................................................................
#   probes_and_matchers = [
#     [["div"],[{"$key":"^div"}],null]
#     [["div#x32"],[{"$key":"^div","id":"x32"}],null]
#     [["div.foo"],[{"$key":"^div","class":"foo"}],null]
#     [["div#x32.foo"],[{"$key":"^div","id":"x32","class":"foo"}],null]
#     [["div#x32",{"alt":"nice guy"}],[{"$key":"^div","id":"x32","alt":"nice guy"}],null]
#     [["div#x32",{"alt":"nice guy"}," a > b & b > c => a > c"],[{"id":"x32","alt":"nice guy","$key":"<div"},{"text":" a > b & b > c => a > c","$key":"^text"},{"$key":">div"}],null]
#     [["foo-bar"],[{"$key":"^foo-bar"}],null]
#     [["foo-bar#c55"],[{"$key":"^foo-bar","id":"c55"}],null]
#     [["foo-bar.blah.beep"],[{"$key":"^foo-bar","class":"blah beep"}],null]
#     [["foo-bar#c55.blah.beep"],[{"$key":"^foo-bar","id":"c55","class":"blah beep"}],null]
#     [["div#sidebar.green", { id: 'd3', class: "orange"}, ],[{"id":"d3","class":"orange","$key":"^div"}],null]
#     [["#c55"],null,"not a valid intertext_html_tagname"]
#     [[".blah.beep"],null,"not a valid intertext_html_tagname"]
#     [["...#"],null,"illegal compact tag syntax"]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       # urge h probe...
#       resolve tag probe...
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (1)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { html_from_datoms
#     tag }                 = INTERTEXT.HTML.export()
#   #.........................................................................................................
#   probes_and_matchers = [
#     [["div"],"<div></div>",null]
#     [["div#x32"],"<div id=x32></div>",null]
#     [["div.foo"],"<div class=foo></div>",null]
#     [["div#x32.foo"],"<div class=foo id=x32></div>",null]
#     [["div#x32",{"alt":"nice guy"}],"<div alt='nice guy' id=x32></div>",null]
#     [["div#x32",{"alt":"nice guy"}," a > b & b > c => a > c"],"<div alt='nice guy' id=x32> a &gt; b &amp; b &gt; c =&gt; a &gt; c</div>",null]
#     [["foo-bar"],"<foo-bar></foo-bar>",null]
#     [["foo-bar#c55"],"<foo-bar id=c55></foo-bar>",null]
#     [["foo-bar.blah.beep"],"<foo-bar class='blah beep'></foo-bar>",null]
#     [["foo-bar#c55.blah.beep"],"<foo-bar class='blah beep' id=c55></foo-bar>",null]
#     [["#c55"],null,"not a valid intertext_html_tagname"]
#     [[".blah.beep"],null,"not a valid intertext_html_tagname"]
#     [["...#"],null,"illegal compact tag syntax"]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       # urge html_from_datoms tag probe...
#       resolve html_from_datoms tag probe...
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (2)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { html_from_datoms
#     tag }                 = INTERTEXT.HTML.export()
#   #.........................................................................................................
#   urge ds = tag 'article#c2', { editable: true, }, ( tag 'h1', "A truly curious Coincidence" )
#   T.eq ds, [
#     { '$key': '<article', id: 'c2', editable: true },
#     { '$key': '<h1' },
#     { '$key': '^text', text: 'A truly curious Coincidence' },
#     { '$key': '>h1' }
#     { '$key': '>article' }
#     ]
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML.html_from_datoms (3)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { html_from_datoms
#     tag }                 = INTERTEXT.HTML.export()
#   #.........................................................................................................
#   urge ds = tag 'article#c2', { editable: true, },
#     tag 'h1', "A truly curious Coincidence"
#     tag 'p.noindent', ( tag 'em', "Seriously," ), " he said, ", ( tag 'em', "we'd better start cooking now." )
#   #.........................................................................................................
#   whisper jr html_from_datoms ds
#   T.eq ( html_from_datoms ds ), "<article editable id=c2><h1>A truly curious Coincidence</h1><p class=noindent><em>Seriously,</em> he said, <em>we'd better start cooking now.</em></p></article>"
#   T.eq ds, [
#     { '$key': '<article', id: 'c2', editable: true },
#     { '$key': '<h1' },
#     { '$key': '^text', text: 'A truly curious Coincidence' },
#     { '$key': '>h1' },
#     { '$key': '<p', class: 'noindent' },
#     { '$key': '<em' },
#     { '$key': '^text', text: 'Seriously,' },
#     { '$key': '>em' },
#     { '$key': '^text', text: ' he said, ' },
#     { '$key': '<em' },
#     { '$key': '^text', text: "we'd better start cooking now." },
#     { '$key': '>em' },
#     { '$key': '>p' },
#     { '$key': '>article' }
#     ]
#   #.........................................................................................................
#   done()
#   return null

# # #-----------------------------------------------------------------------------------------------------------
# # @[ "HTML.datoms_as_nlhtml (1)" ] = ( T, done ) ->
# #   INTERTEXT                 = require '../..'
# #   { datoms_as_nlhtml
# #     datoms_from_html }        = INTERTEXT.HTML.export()
# #   #.........................................................................................................
# #   urge jr ds = datoms_from_html """
# #     <h1>A Star is Born</h1><p class=noindent>Stars are born when hydrogen amasses.</p><p>When they are <em>big</em> enough, nuclear fusion starts.</p>
# #     """
# #   #.........................................................................................................
# #   help datoms_as_nlhtml ds
# #   done()
# #   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML specials" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { html_from_datoms
#     tag }                 = INTERTEXT.HTML.export()
#   #.........................................................................................................
#   probes_and_matchers = [
#     [["script",( -> square = ( ( x ) -> x ** 2 ); console.log square 42 )],[[{"$key":"<script"},{"text":"(function() {\n            var square;\n            square = (function(x) {\n              return x ** 2;\n            });\n            return console.log(square(42));\n          })();","$key":"^raw"},{"$key":">script"}],"<script>(function() {\n            var square;\n            square = (function(x) {\n              return x ** 2;\n            });\n            return console.log(square(42));\n          })();</script>"],null]
#     [["script","path to app.js"],[[{"src":"path to app.js","$key":"^script"}],"<script src='path to app.js'></script>"],null]
#     [["css","path/to/styles.css"],[[{"rel":"stylesheet","href":"path/to/styles.css","$key":"^link"}],"<link href=path/to/styles.css rel=stylesheet>"],null]
#     [["text","a b c < & >"],[[{"text":"a b c < & >","$key":"^text"}],"a b c &lt; &amp; &gt;"],null]
#     [["raw","a b c < & >"],[[{"text":"a b c < & >","$key":"^raw"}],"a b c < & >"],null]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> new Promise ( resolve ) ->
#       [ key, P..., ] = probe
#       result  = INTERTEXT.HTML[ key ] P...
#       result  = [ result, ( html_from_datoms result ), ]
#       resolve result
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML demo" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   text = """<!DOCTYPE html>
#   <h1><strong>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>

#   <p id=p227>However, the egg only got larger and larger, and <em>more and more human</em>:<br>

#   when she had come within a few yards of it, she saw that it had eyes and a nose and mouth; and when she
#   had come close to it, she saw clearly that it was <name ref=hd556>HUMPTY DUMPTY</name> himself. ‘It can’t
#   be anybody else!’ she said to herself.<br/>

#   ‘I’m as certain of it, as if his name were written all over his face.’

#   """
#   for d in datoms = HTML.datoms_from_html text
#     echo jr d
#   echo '-'.repeat 108
#   echo ( HTML.html_from_datoms d for d in datoms ).join ''
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML demo (buffer)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { HTML, }                 = INTERTEXT
#   text    = """<!DOCTYPE html>
#   <h1><strong>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>"""
#   buffer  = Buffer.from text
#   debug '^80009^', buffer
#   for d in datoms = HTML.datoms_from_html buffer
#     echo jr d
#   echo '-'.repeat 108
#   echo ( HTML.html_from_datoms d for d in datoms ).join ''
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "_HTML demo (layout)" ] = ( T, done ) ->
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   { tag
#     html_from_datoms
#     raw
#     text
#     script
#     css }                   = ( require '../..' ).HTML.export()
#   layout = ( settings ) ->
#     defaults  = { title: "My App", content: ( new_datom '~content' ), }
#     settings  = { defaults..., settings..., }
#     # Doctype   = ( P... ) -> tag 'doctype',    P...
#     # Div       = ( P... ) -> tag 'div',        P...
#     # div       = ( P... ) -> tag 'div',        P...
#     H = tag
#     return [
#       ( H 'doctype'                                             )
#       H 'head', [
#         ( H 'meta', charset: 'utf-8'                              )
#         ( H 'title', settings.title                               )
#         ( script    './jquery-3.4.1.js'                           )
#         ( css       './jquery-ui-1.12.1/jquery-ui.min.css'        ) ]
#       H 'body', [
#         settings.content
#         H 'article', [
#           H 'h3', "Greetings"
#           H 'p', "helo world!"
#           ]
#         H 'span#page-ready' ] ]
#     # tag 'meta', 'http-equiv': "Content-Security-Policy", content: "default-src 'self'"
#     # tag 'meta', 'http-equiv': "Content-Security-Policy", content: "script-src 'unsafe-inline'"
#     return null
#   #.........................................................................................................
#   info html_from_datoms layout { title: "Beautiful HTML" }
#   done() if done?
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "《现代常用独体字规范》" ] = ( T, done ) ->
#   SP                        = require 'steampipes'
#   # SP                        = require '../../apps/steampipes'
#   { $
#     $async
#     $drain
#     $watch
#     $split
#     $show  }                = SP.export()
#   DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
#   { new_datom
#     lets
#     select }                = DATOM.export()
#   { tag
#     datoms_from_html
#     $datoms_from_html
#     html_from_datoms
#     raw
#     text
#     script
#     css }                   = ( require '../..' ).HTML.export()
#   html_source = """<div class="ie-fix"><span class="wkwm5edb3638">来自</span><style type="text/css">.wkwm5edb3638{display: none; font-size: 12px;}</style><p class="reader-word-layer reader-word-s1-1" style="width:144px;height:288px;line-height:288px;top:1260px;left:2890px;z-index:0;font-family:simsun;">&nbsp;
# </p><span class="wkwm5edb3638">百度</span><p class="reader-word-layer reader-word-s1-0" style="width:3184px;height:288px;line-height:288px;top:1760px;left:2890px;z-index:1;font-family:'黑体','42c2b43eeefdc8d376ee32f60020001','黑体';letter-spacing:1.1300000000000001px;false">《现代常用独体字规范》</p><p class="reader-word-layer reader-word-s1-1" style="width:144px;height:288px;line-height:288px;top:1760px;left:6078px;z-index:2;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-4" style="width:835px;height:258px;line-height:258px;top:2282px;left:2644px;z-index:3;false">CF&nbsp;0013</p><p class="reader-word-layer reader-word-s1-6" style="width:480px;height:258px;line-height:258px;top:2282px;left:3481px;z-index:4;false">——</p><p class="reader-word-layer reader-word-s1-4" style="width:479px;height:258px;line-height:258px;top:2282px;left:3962px;z-index:5;letter-spacing:-0.37px;false">2009</p><p class="reader-word-layer reader-word-s1-6" style="width:721px;height:258px;line-height:258px;top:2282px;left:4441px;z-index:6;false">，一共</p><p class="reader-word-layer reader-word-s1-4" style="width:362px;height:258px;line-height:258px;top:2282px;left:5221px;z-index:7;letter-spacing:0.8999999999999999px;false">256</p><p class="reader-word-layer reader-word-s1-6" style="width:480px;height:258px;line-height:258px;top:2282px;left:5644px;z-index:8;false">个字</p><p class="reader-word-layer reader-word-s1-4" style="width:60px;height:258px;line-height:258px;top:2282px;left:6124px;z-index:9;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:2681px;left:1442px;z-index:10;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-10" style="width:384px;height:192px;line-height:192px;top:2994px;left:1442px;z-index:11;false">音序</p><p class="reader-word-layer reader-word-s1-9" style="width:192px;height:192px;line-height:192px;top:2994px;left:1827px;z-index:12;false">&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:384px;height:192px;line-height:192px;top:2994px;left:2019px;z-index:13;false">字数</p><p class="reader-word-layer reader-word-s1-9" style="width:577px;height:192px;line-height:192px;top:2994px;left:2403px;z-index:14;false">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:576px;height:192px;line-height:192px;top:2994px;left:2981px;z-index:15;false">独体字</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:192px;line-height:192px;top:2994px;left:3558px;z-index:16;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:3369px;left:1442px;z-index:17;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:319px;height:206px;line-height:206px;top:3369px;left:1586px;z-index:18;letter-spacing:-2.8000000000000003px;false">A&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:3369px;left:1954px;z-index:19;false">1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:192px;height:206px;line-height:206px;top:3369px;left:2434px;z-index:20;">凹</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:3369px;left:2629px;z-index:21;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:3744px;left:1442px;z-index:22;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:319px;height:206px;line-height:206px;top:3744px;left:1586px;z-index:23;letter-spacing:-0.32px;false">B&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:576px;height:206px;line-height:206px;top:3744px;left:1954px;z-index:24;false">14&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10 reader-word-s1-11" style="width:2693px;height:206px;line-height:206px;top:3744px;left:2530px;z-index:25;font-family:'宋体','42c2b43eeefdc8d376ee32f60040001','宋体';false">八巴白百办半贝本匕必丙秉卜不</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:3744px;left:5225px;z-index:26;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:4119px;left:1442px;z-index:27;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9 reader-word-s1-11" style="width:321px;height:206px;line-height:206px;top:4119px;left:1586px;z-index:28;font-family:'Times New Roman','42c2b43eeefdc8d376ee32f60030001','Times New Roman';false">C&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:576px;height:206px;line-height:206px;top:4119px;left:1955px;z-index:29;false">20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:3845px;height:206px;line-height:206px;top:4119px;left:2532px;z-index:30;false">才册叉产长厂车臣承尺斥虫丑出川串垂匆囱寸</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:4119px;left:6379px;z-index:31;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:4494px;left:1442px;z-index:32;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-12" style="width:330px;height:206px;line-height:206px;top:4494px;left:1586px;z-index:33;false">D&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:576px;height:206px;line-height:206px;top:4494px;left:1965px;z-index:34;false">10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:1922px;height:206px;line-height:206px;top:4494px;left:2542px;z-index:35;false">大歹丹刀弟电刁丁东斗</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:4494px;left:4466px;z-index:36;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:4869px;left:1442px;z-index:37;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:309px;height:206px;line-height:206px;top:4869px;left:1586px;z-index:38;false">E&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:4869px;left:1944px;z-index:39;false">4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:769px;height:206px;line-height:206px;top:4869px;left:2425px;z-index:40;false">儿而耳二</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:4869px;left:3194px;z-index:41;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:5244px;left:1442px;z-index:42;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:297px;height:206px;line-height:206px;top:5244px;left:1586px;z-index:43;letter-spacing:-0.28px;false">F&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:5244px;left:1932px;z-index:44;false">8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:1540px;height:206px;line-height:206px;top:5244px;left:2413px;z-index:45;letter-spacing:0.22999999999999998px;false">凡方飞丰夫弗甫父</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:5244px;left:3954px;z-index:46;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:5619px;left:1442px;z-index:47;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-12" style="width:330px;height:206px;line-height:206px;top:5619px;left:1586px;z-index:48;false">G&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:576px;height:206px;line-height:206px;top:5619px;left:1965px;z-index:49;false">13&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:2499px;height:206px;line-height:206px;top:5619px;left:2542px;z-index:50;false">丐干甘戈革个更工弓瓜广鬼果</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:5619px;left:5043px;z-index:51;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:5994px;left:1442px;z-index:52;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-12" style="width:330px;height:206px;line-height:206px;top:5994px;left:1586px;z-index:53;false">H&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:5994px;left:1965px;z-index:54;false">6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:1153px;height:206px;line-height:206px;top:5994px;left:2446px;z-index:55;false">亥禾乎互户火</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:5994px;left:3600px;z-index:56;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:6369px;left:1442px;z-index:57;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:269px;height:206px;line-height:206px;top:6369px;left:1586px;z-index:58;letter-spacing:0.47px;false">J&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:576px;height:206px;line-height:206px;top:6369px;left:1904px;z-index:59;false">16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:3074px;height:206px;line-height:206px;top:6369px;left:2480px;z-index:60;letter-spacing:-0.10999999999999999px;false">击及几己夹甲兼柬见巾斤井九久臼巨</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:6369px;left:5556px;z-index:61;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:6744px;left:1442px;z-index:62;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-12" style="width:330px;height:206px;line-height:206px;top:6744px;left:1586px;z-index:63;false">K&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:6744px;left:1965px;z-index:64;false">3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:576px;height:206px;line-height:206px;top:6744px;left:2446px;z-index:65;false">卡开口</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:6744px;left:3023px;z-index:66;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:7120px;left:1442px;z-index:67;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:297px;height:206px;line-height:206px;top:7120px;left:1588px;z-index:68;letter-spacing:-2.75px;false">L&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:576px;height:206px;line-height:206px;top:7120px;left:1934px;z-index:69;false">12&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:2309px;height:206px;line-height:206px;top:7120px;left:2511px;z-index:70;letter-spacing:0.14px;false">来乐里力立吏隶两了六龙卤</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:7120px;left:4821px;z-index:71;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:7495px;left:1442px;z-index:72;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:363px;height:206px;line-height:206px;top:7495px;left:1586px;z-index:73;false">M&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:576px;height:206px;line-height:206px;top:7495px;left:1998px;z-index:74;false">13&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:2499px;height:206px;line-height:206px;top:7495px;left:2575px;z-index:75;false">马毛矛么门米面民皿末母木目</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:7495px;left:5075px;z-index:76;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:7869px;left:1442px;z-index:77;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-12" style="width:330px;height:206px;line-height:206px;top:7869px;left:1586px;z-index:78;false">N&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:7869px;left:1965px;z-index:79;false">7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:1346px;height:206px;line-height:206px;top:7869px;left:2446px;z-index:80;false">乃内年鸟牛农女</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:7869px;left:3792px;z-index:81;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:8244px;left:1442px;z-index:82;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:292px;height:206px;line-height:206px;top:8244px;left:1586px;z-index:83;letter-spacing:-1.6300000000000001px;false">P&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:8244px;left:1927px;z-index:84;false">2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:384px;height:206px;line-height:206px;top:8244px;left:2407px;z-index:85;false">片平</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:8244px;left:2792px;z-index:86;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:8619px;left:1442px;z-index:87;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-12" style="width:330px;height:206px;line-height:206px;top:8619px;left:1586px;z-index:88;false">Q&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:8619px;left:1965px;z-index:89;false">9&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:1730px;height:206px;line-height:206px;top:8619px;left:2446px;z-index:90;false">七气千羌且丘求曲犬</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:8619px;left:4177px;z-index:91;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:417px;height:206px;line-height:206px;top:8994px;left:1442px;z-index:92;false">&nbsp;&nbsp;R&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:8994px;left:1907px;z-index:93;false">7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:1346px;height:206px;line-height:206px;top:8994px;left:2388px;z-index:94;false">冉人王刃日肉人</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:8994px;left:3735px;z-index:95;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:9369px;left:1442px;z-index:96;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:299px;height:206px;line-height:206px;top:9369px;left:1586px;z-index:97;letter-spacing:0.16px;false">S&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:576px;height:206px;line-height:206px;top:9369px;left:1934px;z-index:98;false">29&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:5576px;height:206px;line-height:206px;top:9369px;left:2511px;z-index:99;false">三山上少申身升生尸失十石史矢土氏世事手首书鼠术束甩水巳四肃</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:9369px;left:8089px;z-index:100;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:9744px;left:1442px;z-index:101;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:305px;height:206px;line-height:206px;top:9744px;left:1586px;z-index:102;letter-spacing:-0.96px;false">T&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:9744px;left:1940px;z-index:103;false">7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:1346px;height:206px;line-height:206px;top:9744px;left:2421px;z-index:104;false">太天田头凸土屯</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:9744px;left:3767px;z-index:105;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:10120px;left:1442px;z-index:106;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:371px;height:206px;line-height:206px;top:10120px;left:1586px;z-index:107;letter-spacing:-0.64px;false">W&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:10120px;left:2005px;z-index:108;false">16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:3076px;height:206px;line-height:206px;top:10120px;left:2486px;z-index:109;false">瓦丸万亡王为卫未文我乌无五午勿戊</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:10120px;left:5564px;z-index:110;font-family:simsun;">&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:10495px;left:1442px;z-index:111;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-12" style="width:330px;height:206px;line-height:206px;top:10495px;left:1586px;z-index:112;false">X&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:480px;height:206px;line-height:206px;top:10495px;left:1965px;z-index:113;false">10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:1922px;height:206px;line-height:206px;top:10495px;left:2446px;z-index:114;false">夕西习下乡象小心囟血</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:10495px;left:4370px;z-index:115;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:10870px;left:1442px;z-index:116;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:322px;height:206px;line-height:206px;top:10870px;left:1588px;z-index:117;letter-spacing:-1.9px;false">Y&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:482px;height:206px;line-height:206px;top:10870px;left:1961px;z-index:118;letter-spacing:0.25px;false">33&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:5646px;height:206px;line-height:206px;top:10870px;left:2446px;z-index:119;letter-spacing:2.3200000000000003px;false">丫牙亚严言央羊夭也业页一衣夷乙已义亦永用尤由酉又于予与雨禹</p><p class="reader-word-layer reader-word-s1-10" style="width:769px;height:192px;line-height:192px;top:11245px;left:1442px;z-index:120;false">玉曰月云</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:192px;line-height:192px;top:11245px;left:2211px;z-index:121;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-9" style="width:96px;height:206px;line-height:206px;top:11620px;left:1442px;z-index:122;false">&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:307px;height:206px;line-height:206px;top:11620px;left:1586px;z-index:123;letter-spacing:-0.51px;false">Z&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-9" style="width:576px;height:206px;line-height:206px;top:11620px;left:1942px;z-index:124;false">16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p class="reader-word-layer reader-word-s1-10" style="width:3078px;height:206px;line-height:206px;top:11620px;left:2519px;z-index:125;letter-spacing:0.1px;false">再乍丈正之止中重舟州朱主爪专子自</p><p class="reader-word-layer reader-word-s1-9" style="width:48px;height:206px;line-height:206px;top:11620px;left:5598px;z-index:126;font-family:simsun;">&nbsp;
# </p><p class="reader-word-layer reader-word-s1-5" style="width:42px;height:182px;line-height:182px;top:12005px;left:1442px;z-index:127;font-size:169px;font-family:simsun;">&nbsp;
# </p><span class="wkwm5edb3638">文库</span></div>"""
#   # html_source = """<p>helo</p><p></p><p></p>     <p>    </p><p>over</p>"""
#   #.........................................................................................................
#   $resolve_entities = -> $ ( d, send ) =>
#     return send d unless select d, '^text'
#     send lets d, ( d ) => d.text = d.text.replace /&nbsp;/g, ' '
#   #.........................................................................................................
#   $remove_styles_and_classes = -> $ ( d, send ) =>
#     return if select d, '<span'
#     return if select d, '>span'
#     return send d unless d.style? or d.class?
#     send lets d, ( d ) =>
#       delete d.style
#       delete d.class
#   #.........................................................................................................
#   $skip_styles = ->
#     within_style = false
#     return $ ( d, send ) =>
#       if select d, '<style'
#         within_style = true
#         return
#       if select d, '>style'
#         within_style = false
#         return
#       return if within_style
#       send d
#   #.........................................................................................................
#   $trim = -> $ ( d, send ) =>
#     return send d unless select d, '^text'
#     d = lets d, ( d ) => d.text = d.text.trim()
#     send d unless d.text is ''
#   #.........................................................................................................
#   $remove_empty_tags = ->
#     width     = 2
#     fallback  = Symbol 'fallback'
#     skip_next = false
#     #.......................................................................................................
#     return SP.window { width, fallback, }, $ ( ds, send ) ->
#       if skip_next
#         skip_next = false
#         return
#       #.....................................................................................................
#       [ this_d, next_d, ] = ds
#       # return send next_d  if this_d  is fallback
#       return              if this_d is fallback
#       return send this_d  if next_d is fallback
#       this_sigil    = this_d.$key[ 0 ]
#       return send this_d unless this_sigil is '<'
#       this_tagname  = this_d.$key[ 1 .. ]
#       next_sigil    = next_d.$key[ 0 ]
#       return send this_d unless next_sigil is '>'
#       next_tagname  = next_d.$key[ 1 .. ]
#       return send this_d unless this_tagname is next_tagname
#       skip_next     = true
#   #.........................................................................................................
#   pipeline  = []
#   pipeline.push [ ( Buffer.from html_source ), ] ### TAINT fix `$split()` to accept string ###
#   pipeline.push $split()
#   pipeline.push $datoms_from_html()
#   pipeline.push $resolve_entities()
#   pipeline.push $remove_styles_and_classes()
#   pipeline.push $skip_styles()
#   pipeline.push $trim()
#   pipeline.push $remove_empty_tags()
#   # pipeline.push $show()
#   pipeline.push SP.$filter ( d ) -> select d, '^text'
#   pipeline.push $drain ( ds ) -> urge ( d.text for d in ds ).join ''
#   SP.pull pipeline...
#   #.........................................................................................................
#   done() if done?
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML Cupofhtml (1)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   HTML                      = INTERTEXT.HTML
#   cupofhtml                 = new HTML.Cupofhtml()
#   { isa
#     type_of }               = INTERTEXT.types
#   #.........................................................................................................
#   T.eq cupofhtml.settings.flatten, true
#   T.ok isa.list cupofhtml.collector
#   T.ok cupofhtml.target is cupofhtml.collector
#   T.ok isa.function cupofhtml.cram
#   T.ok isa.function cupofhtml.expand
#   T.ok isa.asyncfunction cupofhtml.expand_async
#   T.ok isa.function cupofhtml.tag
#   T.ok isa.function cupofhtml.css
#   T.ok isa.function cupofhtml.script
#   T.ok isa.function cupofhtml.raw
#   T.ok isa.function cupofhtml.text
#   #.........................................................................................................
#   { cram
#     expand
#     expand_async
#     tag
#     raw
#     text
#     script
#     css }                   = cupofhtml.export()
#   T.ok isa.function cram
#   T.ok isa.function expand
#   T.ok isa.asyncfunction expand_async
#   T.ok isa.function tag
#   T.ok isa.function text
#   T.ok isa.function raw
#   T.ok isa.function script
#   T.ok isa.function css
#   #.........................................................................................................
#   done()

# #-----------------------------------------------------------------------------------------------------------
# @[ "HTML Cupofhtml (2)" ] = ( T, done ) ->
#   INTERTEXT                 = require '../..'
#   { isa
#     type_of }               = INTERTEXT.types
#   HTML                      = INTERTEXT.HTML
#   cupofhtml                 = new HTML.Cupofhtml()
#   { cram
#     expand
#     expand_async
#     tag
#     raw
#     text
#     script
#     css }                   = cupofhtml.export()
#   { datoms_from_html
#     html_from_datoms }      = HTML.export()
#   #.........................................................................................................
#   # debug '^33343^', ( k for k of cupofhtml )
#   # debug '^33343^', ( k for k of cupofhtml.export() )
#   tag 'paper', ->
#     css     './styles.css'
#     script  './awesome.js'
#     script ->
#       console.log "pretty darn cool"
#     tag 'article', ->
#       tag 'title', "Some Thoughts on Nested Data Structures"
#       tag 'p', ->
#         text        "An interesting "
#         tag   'em', "fact"
#         text        " about CupOfJoe is that you "
#         tag   'em', -> text "can"
#         tag  'strong', " nest", " with both sequences", " and function calls."
#       tag 'p', ->
#         text "Text is escaped before output: <&>, "
#         raw  "but can also be included literally with `raw`: <&>."
#     tag 'conclusion', ->
#       text  "With CupOfJoe, you don't need brackets."
#   datoms = expand()
#   html   = html_from_datoms datoms
#   info datoms
#   urge jr html
#   T.eq html, "<paper><link href=./styles.css rel=stylesheet><script src=./awesome.js></script><script>(function() {\n        return console.log(\"pretty darn cool\");\n      })();</script><article><title>Some Thoughts on Nested Data Structures</title><p>An interesting <em>fact</em> about CupOfJoe is that you <em>can</em><strong> nest with both sequences and function calls.</strong></p><p>Text is escaped before output: &lt;&amp;&gt;, but can also be included literally with `raw`: <&>.</p></article><conclusion>With CupOfJoe, you don't need brackets.</conclusion></paper>"
#   #.........................................................................................................
#   done() if done?


# ############################################################################################################
# if module is require.main then do => # await do =>
#   # debug ( k for k of ( require '../..' ).HTML ).sort().join ' '
#   # await @_demo()
#   test @
#   # test @[ "HTML.datoms_from_html (1)" ]
#   # test @[ "HTML.datoms_from_html (dubious)" ]
#   # test @[ "HTML.datoms_from_html (2)" ]
#   # test @[ "HTML.html_from_datoms (singular tags)" ]
#   # test @[ "HTML Cupofhtml (1)" ]
#   # test @[ "HTML Cupofhtml (2)" ]
#   # test @[ "HTML._parse_compact_tagname" ]
