
'use strict'


############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/TYPES'
debug                     = CND.get_logger 'debug',     badge
alert                     = CND.get_logger 'alert',     badge
whisper                   = CND.get_logger 'whisper',   badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
info                      = CND.get_logger 'info',      badge
jr                        = JSON.stringify
Intertype                 = ( require 'intertype' ).Intertype
intertype                 = new Intertype module.exports
L                         = @
PATTERNS                  = require './_patterns'

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_shy',
  tests:
    "x is a text":                   					( x ) -> @isa.text                      x
    "x ends with soft hyphen":       					( x ) -> x[ x.length - 1 ] is '\u00ad'

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_slabs_slabjoints',
  tests:
    "@isa.object x":                          ( x ) -> @isa.object x
    "@isa.nonempty_text x.version":           ( x ) -> @isa.nonempty_text x.version
    "@isa.object x.joints":                   ( x ) -> @isa.object x.joints
    "@isa.chr x.joints.blunt":                ( x ) -> @isa.chr x.joints.blunt
    "@isa.chr x.joints.shy":                  ( x ) -> @isa.chr x.joints.shy
    "@isa.chr x.joints.space":                ( x ) -> @isa.chr x.joints.space
    "@isa.cardinal x.cursor":                 ( x ) -> @isa.cardinal x.cursor

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_slabs_slabjoints_v001',
  tests:
    "x is a intertext_slabs_slabjoints":      ( x ) -> @isa.intertext_slabs_slabjoints x
    "x.version is '0.0.1":                    ( x ) -> x.version is '0.0.1'

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_slabs_metrics',
  tests:
    "x is an object":                         ( x ) -> @isa.object x
    "x.width is a positive float":            ( x ) -> @isa.positive_float x.width
    "x.widths is an object":                  ( x ) -> @isa.object x.widths
    ### TAINT should allow async functions: ###
    "x.compute_width is a function":          ( x ) -> @isa.function x.compute_width

# #-----------------------------------------------------------------------------------------------------------
# @declare 'intertext_template_name',
#   tests:
#     "x is a nonempty_text":                   ( x ) -> @isa.nonempty_text                      x
#     "x is name of template":                  ( x ) -> @isa.function ( require './templates' )[ x ]

#-----------------------------------------------------------------------------------------------------------
### TAINT consider to use JS regex unicode properties:

```
/\p{Script_Extensions=Latin}/u
/\p{Script=Latin}/u
/\p{Script_Extensions=Cyrillic}/u
/\p{Script_Extensions=Greek}/u
/\p{Unified_Ideograph}/u
/\p{Script=Han}/u
/\p{Script_Extensions=Han}/u
/\p{Ideographic}/u
/\p{IDS_Binary_Operator}/u
/\p{IDS_Trinary_Operator}/u
/\p{Radical}/u
/\p{White_Space}/u
/\p{Script_Extensions=Hiragana}/u
/\p{Script=Hiragana}/u
/\p{Script_Extensions=Katakana}/u
/\p{Script=Katakana}/u
```

###
regex_cid_ranges =
  hiragana:     '[\u3041-\u3096]'
  katakana:     '[\u30a1-\u30fa]'
  kana:         '[\u3041-\u3096\u30a1-\u30fa]'
  ideographic:  '[\u3006-\u3007\u3021-\u3029\u3038-\u303a\u3400-\u4db5\u4e00-\u9fef\uf900-\ufa6d\ufa70-\ufad9\u{17000}-\u{187f7}\u{18800}-\u{18af2}\u{1b170}-\u{1b2fb}\u{20000}-\u{2a6d6}\u{2a700}-\u{2b734}\u{2b740}-\u{2b81d}\u{2b820}-\u{2cea1}\u{2ceb0}-\u{2ebe0}\u{2f800}-\u{2fa1d}]'

#-----------------------------------------------------------------------------------------------------------
### TAINT kludge; this will be re-implemented in InterText ###
@interplot_regex_cjk_property_terms = [
  'Ideographic'                     ### https://unicode.org/reports/tr44/#Ideographic ###
  'Radical'
  'IDS_Binary_Operator'
  'IDS_Trinary_Operator'
  'Script_Extensions=Hiragana'
  'Script_Extensions=Katakana'
  'Script_Extensions=Hangul'
  'Script_Extensions=Han'
  ]

#-----------------------------------------------------------------------------------------------------------
@_regex_any_of_cjk_property_terms = ->
  return '[' + ( ( "\\p{#{t}}" for t in @interplot_regex_cjk_property_terms ).join '' ) + ']'


#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_text_with_hiragana',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? has hiragana':           ( x ) -> ( x.match ///#{regex_cid_ranges.hiragana}///u )?

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_text_with_katakana',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? has katakana':           ( x ) -> ( x.match ///#{regex_cid_ranges.katakana}///u )?

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_text_with_kana',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? has kana':               ( x ) -> ( x.match ///#{regex_cid_ranges.kana}///u )?

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_text_with_ideographic',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? has ideographic':        ( x ) -> ( x.match ///#{regex_cid_ranges.ideographic}///u )?

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_text_hiragana',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? is hiragana':            ( x ) -> ( x.match ///^#{regex_cid_ranges.hiragana}+$///u )?

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_text_katakana',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? is katakana':            ( x ) -> ( x.match ///^#{regex_cid_ranges.katakana}+$///u )?

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_text_kana',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? is kana':                ( x ) -> ( x.match ///^#{regex_cid_ranges.kana}+$///u )?

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_text_ideographic',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? is ideographic':         ( x ) -> ( x.match ///^#{regex_cid_ranges.ideographic}+$///u )?

#-----------------------------------------------------------------------------------------------------------
@declare 'interplot_text_cjk',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? is cjk':                 ( x ) -> ( x.match /// ^ #{L._regex_any_of_cjk_property_terms()}+ $ /// )?

#-----------------------------------------------------------------------------------------------------------
@declare 'interplot_text_with_cjk',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? has cjk':                ( x ) -> ( x.match ///   #{L._regex_any_of_cjk_property_terms()}+   /// )?


#===========================================================================================================
# HTML
#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_html_tagname',
  tests:
    "x is a text":                    ( x ) -> @isa.text x
    "x matches xmlname_re":           ( x ) -> PATTERNS.xmlname_re_anchored.test x

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_html_naked_attribute_value',
  ### thx to https://raw.githubusercontent.com/mathiasbynens/mothereff.in/master/unquoted-attributes/eff.js
  also see https://mothereff.in/unquoted-attributes,
  https://mathiasbynens.be/notes/unquoted-attribute-values ###
  tests:
    "x is a text":                                ( x ) -> @isa.text x
    "x isa intertext_html_naked_attribute_text":  ( x ) -> @isa._intertext_html_naked_attribute_text x

#-----------------------------------------------------------------------------------------------------------
@declare '_intertext_html_naked_attribute_text', ( x ) -> /^[^ \t\n\f\r"'`=<>]+$/.test x

# #-----------------------------------------------------------------------------------------------------------
# @declare 'parse_html_settings',
#   tests:
#     "x is an object":                       ( x ) -> @isa.object x
#     "x.format is known":                    ( x ) -> x.format in [ 'html5', 'mkts', ]

# #-----------------------------------------------------------------------------------------------------------
# @defaults =
#   settings:
#     parse_html_settings:
#       format:     'html5'

#-----------------------------------------------------------------------------------------------------------
### thx to https://developer.mozilla.org/en-US/docs/Glossary/empty_element ###
empty_element_tagnames = new Set """area base br col embed hr img input link meta param
  source track wbr""".split /\s+/

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_html_empty_element_tagname',
  tests:
    "x is a text":                            ( x ) -> @isa.text x
    "x is name of an empty HTML element":     ( x ) -> @isa._intertext_html_empty_element_tagname x

#-----------------------------------------------------------------------------------------------------------
@declare '_intertext_html_empty_element_tagname', ( x ) -> empty_element_tagnames.has x

### thx to https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements ###
#-----------------------------------------------------------------------------------------------------------
html5_block_level_tagnames = new Set """address article aside blockquote dd details dialog div dl dt
  fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 header hgroup hr li main nav ol p pre section table
  td th ul""".split /\s+/

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_html_block_level_tagname',
  tests:
    "x is a text":                            ( x ) -> @isa.text x
    "x is name of an empty HTML element":     ( x ) -> @isa._intertext_html_block_level_tagname x

#-----------------------------------------------------------------------------------------------------------
@declare '_intertext_html_block_level_tagname', ( x ) -> html5_block_level_tagnames.has x




