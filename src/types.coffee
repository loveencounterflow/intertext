
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

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_shy',
  tests:
    "x is a text":                   					( x ) -> @isa.text                      x
    "x ends with soft hyphen":       					( x ) -> x[ x.length - 1 ] is '\u00ad'

#-----------------------------------------------------------------------------------------------------------
@declare 'intertext_template_name',
  tests:
    "x is a nonempty_text":                   ( x ) -> @isa.nonempty_text                      x
    "x is name of template":                  ( x ) -> @isa.function ( require './templates' )[ x ]

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
@declare 'interplot_text_with_hiragana',
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
@declare 'blank_text',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? is cjk':                 ( x ) -> ( x.match /// ^ #{L._regex_any_of_cjk_property_terms()}+ $ /// )?

#-----------------------------------------------------------------------------------------------------------
@declare 'interplot_text_with_cjk',
  tests:
    '? is a text':              ( x ) -> @isa.text x
    '? has cjk':                ( x ) -> ( x.match ///   #{L._regex_any_of_cjk_property_terms()}+   /// )?



# #-----------------------------------------------------------------------------------------------------------
# @declare 'blank_text',
#   tests:
#     '? is a text':              ( x ) -> @isa.text x
#     '? is blank':               ( x ) -> ( x.match ///^\s*$///u )?


@defaults =
  settings:
    merge:    true
