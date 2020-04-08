# ###

# ====================================================================================
# compact names for MKTScript:

# `<div#c432.foo.bar>...</div>` => `<div id=c432 class='foo bar'>...</div>`
# `<p.noindent>...</p>` => `<p class=noindent>...</p>`

# positional arguments:
# `<columns:2>` => `<columns count=2/>` => `<columns count=2></columns>` ?=> `<mkts-columns count=2></mkts-columns>`

# NB Svelte uses capitalized names, allows self-closing tags(!): `<Mytag/>`

# ###

# 'use strict'

# ############################################################################################################
# CND                       = require 'cnd'
# rpr                       = CND.rpr
# badge                     = 'INTERTEXT/TESTS/MKTSCRIPT'
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
# DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
# { new_datom
#   lets
#   select }                = DATOM.export()
# types                     = require '../types'
# { isa
#   validate
#   # cast
#   # declare
#   # declare_cast
#   # check
#   # sad
#   # is_sad
#   # is_happy
#   type_of }               = types
# #...........................................................................................................
# test                      = require 'guy-test'
# INTERTEXT                 = require '../..'
# { MKTS, }                 = INTERTEXT



# #===========================================================================================================
# # TESTS
# #-----------------------------------------------------------------------------------------------------------
# @[ "MKTS.datoms_from_html" ] = ( T, done ) ->
#   probes_and_matchers = [
#     ["line A<br/>line B",[{"text":"line A","$key":"^text"},{"$key":"^br"},{"text":"line B","$key":"^text"}],null]
#     ["<p>|here and|<br>",[{"$key":"<p"},{"text":"|here and|","$key":"^text"},{"$key":"^br"}],null]
#     ["|foo |<p>|here and|<br>|there|",[{"text":"|foo |","$key":"^text"},{"$key":"<p"},{"text":"|here and|","$key":"^text"},{"$key":"^br"},{"text":"|there|","$key":"^text"}],null]
#     ["< >",[{"message":"Syntax error: whitespace not allowed here: \"< >\"","type":"mkts-syntax-html","source":"< >","$key":"~error"}],null]
#     ["< x >",[{"message":"Syntax error: whitespace not allowed here: \"< x >\"","type":"mkts-syntax-html","source":"< x >","$key":"~error"}],null]
#     ["<>",[{"message":"Syntax error: closing bracket too close to opening bracket: \"<>\"","type":"mkts-syntax-html","source":"<>","$key":"~error"}],null]
#     ["<",[{"message":"Syntax error: opening but no closing bracket: \"<\"","type":"mkts-syntax-html","source":"<","$key":"~error"}],null]
#     ["<tag",[{"message":"Syntax error: opening but no closing bracket: \"<tag\"","type":"mkts-syntax-html","source":"<tag","$key":"~error"}],null]
#     ["tag>",[{"message":"Syntax error: closing but no opening bracket: \"tag>\"","type":"mkts-syntax-html","source":"tag>","$key":"~error"}],null]
#     [">",[{"message":"Syntax error: closing but no opening bracket: \">\"","type":"mkts-syntax-html","source":">","$key":"~error"}],null]
#     ["<",[{"message":"Syntax error: opening but no closing bracket: \"<\"","type":"mkts-syntax-html","source":"<","$key":"~error"}],null]
#     ["x",[{"text":"x","$key":"^text"}],null]
#     ["&",[{"text":"&","$key":"^text"}],null]
#     ["&;",[{"text":"&;","$key":"^text"}],null]
#     ["&&",[{"text":"&&","$key":"^text"}],null]
#     ["max & moritz",[{"text":"max & moritz","$key":"^text"}],null]
#     ["&amp;",[{"text":"&amp;","$key":"^text"}],null]
#     ["<tag>\n \n\t\n</p>",[{"$key":"<tag"},{"text":"\n \n\t\n","$key":"^text"},{"$key":">p"}],null]
#     ["<tag a='<'>",[{"message":"Syntax error: additional opening bracket: \"<tag a='<'>\"","type":"mkts-syntax-html","source":"<tag a='<'>","$key":"~error"}],null]
#     ["<tag a='>'>",[{"text":">","$key":"^text"},{"message":"Syntax error: closing but no opening bracket: \"'>\"","type":"mkts-syntax-html","source":"'>","$key":"~error"}],null]
#     ["if <math> a > b </math> then",[{"text":"if ","$key":"^text"},{"$key":"<math"},{"message":"Syntax error: closing before opening bracket: \" a > b </math> then\"","type":"mkts-syntax-html","source":" a > b </math> then","$key":"~error"}],null]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
#       text      = probe
#       resolve MKTS.datoms_from_html text
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "MKTS.datoms_from_html (compact syntax)" ] = ( T, done ) ->
#   probes_and_matchers = [
#     # [ '<columns =2 =3>' ]
#     ["<div>",[{"$key":"<div"}]]
#     ["<div#c432.foo.bar>",[{"$key":"<div","id":"c432","class":"foo bar"}]]
#     ["<p.noindent>",[{"$key":"<p","class":"noindent"}]]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
#       resolve MKTS.datoms_from_html probe
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "MKTS.$datoms_from_html" ] = ( T, done ) ->
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
#   pipeline.push MKTS.$datoms_from_html()
#   pipeline.push $show()
#   pipeline.push $drain ( result ) =>
#     help jr result
#     T.eq result, matcher
#     done()
#   SP.pull pipeline...
#   #.........................................................................................................
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "MKTS.datoms_from_html (dubious)" ] = ( T, done ) ->
#   probes_and_matchers = [
#     ### TAINT these edge cases should be solved by an appropriate (MKTScript) pre-processor; NB that in
#     MKTScript stray pointy brackets in ordinary text (but not in `<code>` blocks) are forbidden and must
#     be escaped as entities wherever they appear in attribute values; these rules, however, do not
#     necessarily apply when parsing general MKTS sources. ###
#     ###
#     ["< >",[{"text":"< >","$key":"^text"}],null]          # !!! silent failure
#     ["< x >",[{"text":"< x >","$key":"^text"}],null]      # !!! silent failure
#     ["<>",[{"text":"<>","$key":"^text"}],null]            # !!! silent failure
#     ["<",[{"text":"<","$key":"^text"}],null]              # !!! silent failure
#     ["<tag",[{"text":"<tag","$key":"^text"}],null]        # !!! silent failure
#     ###
#     ["if <math> a > b </math> then",[{"text":"if ","$key":"^text"},{"$key":"<math"},{"message":"Syntax error: closing before opening bracket: \" a > b </math> then\"","type":"mkts-syntax-html","source":" a > b </math> then","$key":"~error"}],null]
#     [">",[{"message":"Syntax error: closing but no opening bracket: \">\"","type":"mkts-syntax-html","source":">","$key":"~error"}],null]
#     ["&",[{"text":"&","$key":"^text"}],null]
#     ["&amp;",[{"text":"&amp;","$key":"^text"}],null]
#     ["<tag a='<'>",[{"message":"Syntax error: additional opening bracket: \"<tag a='<'>\"","type":"mkts-syntax-html","source":"<tag a='<'>","$key":"~error"}],null]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
#       resolve MKTS.datoms_from_html probe
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "__MKTS.datoms_from_html (SGML SHORTTAG syntax)" ] = ( T, done ) ->
#   provide_basic_parser.apply X = {}
#   urge X._parse_html "<foo><br>content</foo>"
#   urge X._parse_html "<foo#id.class>"
#   urge X._parse_html "</foo>"
#   urge X._parse_html "<tag>content</>"
#   urge X._parse_html "<tag#id>content</>"
#   urge X._parse_html "<tag/content/"
#   urge X._parse_html "Yellow is <zh/黃/ <py/huang2/ in Mandarin."
#   urge X._parse_html "Yellow is <zh/黃/> <py/huang2/> in Mandarin."
#   urge X._parse_html "Yellow is <zh/黃> <py/huang2> in Mandarin."
#   urge X._parse_html "China is big: <py|Zhongguo hen da.> in Mandarin."
#   urge X._parse_html "a<py|huang2>b"
#   urge X._parse_html "a<py|huang2 di4>b"
#   # probes_and_matchers = [
#   #   ["<tag#id>content</>",[{"message":"Syntax error: additional opening bracket: \"<tag a='<'>\"","type":"mkts-syntax-html","source":"<tag a='<'>","$key":"~error"}],null]
#   #   ["before<tag#id>content</>after",[{"message":"Syntax error: additional opening bracket: \"<tag a='<'>\"","type":"mkts-syntax-html","source":"<tag a='<'>","$key":"~error"}],null]
#   #   ]
#   # for [ probe, matcher, error, ] in probes_and_matchers
#   #   await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
#   #     # resolve MKTS.datoms_from_html probe
#   #     resolve ( require '../html' ).datoms_from_html probe
#   # #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "__MKTS.datoms_from_html (SGML NET syntax)" ] = ( T, done ) ->
#   probes_and_matchers = [
#     ["<tag#id/class/content/",[{"message":"Syntax error: additional opening bracket: \"<tag a='<'>\"","type":"mkts-syntax-html","source":"<tag a='<'>","$key":"~error"}],null]
#     ["before<tag#id/class/content/after",[{"message":"Syntax error: additional opening bracket: \"<tag a='<'>\"","type":"mkts-syntax-html","source":"<tag a='<'>","$key":"~error"}],null]
#     ]
#   for [ probe, matcher, error, ] in probes_and_matchers
#     await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
#       resolve MKTS.datoms_from_html probe
#   #.........................................................................................................
#   done()
#   return null


# #===========================================================================================================
# # DEMOS
# #-----------------------------------------------------------------------------------------------------------
# @[ "MKTS demo" ] = ( T, done ) ->
#   text = """<!DOCTYPE html>
#   <h1#s4451><strong>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>

#   <p#p227.noindent>However, the egg only got larger and larger, and <em>more and more human</em>:<br>

#   when she had come within a few yards of it, she saw that it had eyes and a nose and mouth; and when she
#   had come close to it, she saw clearly that it was <name ref=hd556>HUMPTY DUMPTY</name> himself. ‘It can’t
#   be anybody else!’ she said to herself.<br/>

#   ‘I’m as certain of it, as if his name were written all over his face.’

#   """
#   for d in datoms = MKTS.datoms_from_html text
#     echo jr d
#   echo '-'.repeat 108
#   echo result = ( MKTS.html_from_datoms d for d in datoms ).join ''
#   # debug '^2228^', jr result
#   T.eq result, "<!DOCTYPE html>\n<h1 id=s4451><strong>CHAPTER VI.</strong> \
#     <name ref=hd553>Humpty Dumpty</h1>\n\n<p class=noindent id=p227>However, the egg only got larger and larger, \
#     and <em>more and more human</em>:<br>\n\nwhen she had come within a few yards of it, she saw that it \
#     had eyes and a nose and mouth; and when she\nhad come close to it, she saw clearly that it was \
#     <name ref=hd556>HUMPTY DUMPTY</name> himself. ‘It can’t\nbe anybody else!’ she said to herself.\
#     <br>\n\n‘I’m as certain of it, as if his name were written all over his face.’\n"
#   #.........................................................................................................
#   done()
#   return null

# #-----------------------------------------------------------------------------------------------------------
# @[ "MKTS demo (buffer)" ] = ( T, done ) ->
#   text    = """<!DOCTYPE html>
#   <h1#c4443><strong.myclass>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>"""
#   buffer  = Buffer.from text
#   # debug '^80009^', buffer
#   # for d in datoms = MKTS.datoms_from_html buffer
#   for d in datoms = MKTS.datoms_from_html buffer
#     echo jr d
#   echo '-'.repeat 108
#   echo result = ( MKTS.html_from_datoms d for d in datoms ).join ''
#   T.eq result, "<!DOCTYPE html>\n<h1 id=c4443><strong class=myclass>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>"
#   #.........................................................................................................
#   done()
#   return null


# ############################################################################################################
# if module is require.main then do => # await do =>
#   # await @_demo()
#   # await test @
#   await test @[ "MKTS.datoms_from_html (SGML SHORTTAG syntax)" ]
#   await test @[ "MKTS.datoms_from_html (SGML NET syntax)" ]
#   # await test @[ "MKTS.datoms_from_html" ]
#   # await test @[ "MKTS.datoms_from_html (compact syntax)" ]
#   # await test @[ "MKTS.$datoms_from_html" ]
#   # await test @[ "MKTS.datoms_from_html (dubious)" ]
#   # await test @[ "MKTS demo" ]
#   # await test @[ "MKTS demo (buffer)" ]
