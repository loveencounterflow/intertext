
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/TESTS/HYPHENATION'
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
@[ "INTERTEXT.HYPH.hyphenate" ] = ( T, done ) ->
  probes_and_matchers = [
    ["","",]
    ["lexicographer","lex|i|cog|ra|pher",]
    ["astronomer","as|tronomer",]
    ["dweeb","dweeb",]
    ["Tylenol","Tylenol",]
    ["diagonally","di|ag|o|nally",]
    ["demeaned","de|meaned",]
    ["Pasternak","Paster|nak",]
    ["proofreader","proof|reader",]
    ["monochrome","mono|chrome",]
    ["diving","div|ing",]
    ["Bimini","Bi|mini",]
    ["hedonist","he|do|nist",]
    ["distinctiveness","dis|tinc|tive|ness",]
    ["repugnance","re|pug|nance",]
    ["haste","haste",]
    ["mistimes","mist|imes",]
    ["bested","bested",]
    ["sundered","sun|dered",]
    ["articulation","ar|tic|u|la|tion",]
    ["LEXICOGRAPHER","LEX|I|COG|RA|PHER",]
    ["ASTRONOMER","AS|TRONOMER",]
    ["DWEEB","DWEEB",]
    ["TYLENOL","TYLENOL",]
    ["DIAGONALLY","DI|AG|O|NALLY",]
    ["DEMEANED","DE|MEANED",]
    ["PASTERNAK","PASTER|NAK",]
    ["PROOFREADER","PROOF|READER",]
    ["MONOCHROME","MONO|CHROME",]
    ["DIVING","DIV|ING",]
    ["BIMINI","BI|MINI",]
    ["HEDONIST","HE|DO|NIST",]
    ["DISTINCTIVENESS","DIS|TINC|TIVE|NESS",]
    ["REPUGNANCE","RE|PUG|NANCE",]
    ["HASTE","HASTE",]
    ["MISTIMES","MIST|IMES",]
    ["BESTED","BESTED",]
    ["SUNDERED","SUN|DERED",]
    ["ARTICULATION","AR|TIC|U|LA|TION",]
    ["over-guesstimate","over-guessti|mate"]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      # debug '^44453^', INTERTEXT.HYPH.new_hyphenator()
      # debug '^44453^', INTERTEXT.HYPH.reveal_hyphens INTERTEXT.HYPH.new_hyphenator() 'fantastic'
      # debug '^777801^', INTERTEXT.HYPH.hyphenate probe
      resolve ( INTERTEXT.HYPH.hyphenate probe ).replace /\xad/g, '|'
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "INTERTEXT.HYPH.soft_hyphen_chr" ] = ( T, done ) ->
  T.eq INTERTEXT.HYPH.soft_hyphen_chr, '\u00ad'
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "INTERTEXT.HYPH.count_soft_hyphens" ] = ( T, done ) ->
  probes_and_matchers = [
    [ "",           0, ]
    ["lex­i­cog­ra­pher",4,]
    ["as­tronomer",1,]
    ["di­ag­o­nally",3,]
    ["de­meaned",1,]
    ["Paster­nak",1,]
    ["proof­reader",1,]
    ["mono­chrome",1,]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      resolve INTERTEXT.HYPH.count_soft_hyphens probe
  #.........................................................................................................
  done()
  return null

#-----------------------------------------------------------------------------------------------------------
@[ "INTERTEXT.HYPH.reveal_hyphens" ] = ( T, done ) ->
  probes_and_matchers = [
    [ "fan\xadtas\xadtic",           "fan-tas-tic", ]
    ]
  for [ probe, matcher, error, ] in probes_and_matchers
    await T.perform probe, matcher, error, -> return new Promise ( resolve, reject ) ->
      resolve INTERTEXT.HYPH.reveal_hyphens probe
  #.........................................................................................................
  done()
  return null



############################################################################################################
if module is require.main then do => # await do =>
  # await @_demo()
  test @
  help 'ok'
  # test @[ "demo" ]
  # test @[ "hyphenate" ]

  # test @[ "must quote attribute value" ]
  # test @[ "DATOM.HTML._as_attribute_literal" ]
  # test @[ "isa.intertext_html_tagname" ]
  # test @[ "HTML.datom_as_html (singular tags)" ]
  # test @[ "HTML.datom_as_html (closing tags)" ]
  # test @[ "HTML.datom_as_html (opening tags)" ]
  # test @[ "HTML.datom_as_html (texts)" ]
  # test @[ "HTML.datom_as_html (opening tags w/ $value)" ]
  # test @[ "HTML.datom_as_html (system tags)" ]
  # test @[ "HTML.datom_as_html (raw pseudo-tag)" ]
  # test @[ "HTML.datom_as_html (doctype)" ]
  # test @[ "HTML.html_as_datoms (1)" ]
  # test @[ "HTML.html_as_datoms (dubious 2)" ]
  # test @[ "HTML.html_as_datoms (dubious w/ pre-processor)" ]



