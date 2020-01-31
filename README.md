
InterText: Services for Recurrent Text-related Tasks


## Ansi Colors (??? or keep in CND)

* use TrueColors for modern terminal emulators

## Number Formatting

```coffee
_format                   = require 'number-format.js'
format_float              = ( x ) -> _format '#,##0.000', x
format_integer            = ( x ) -> _format '#,##0.',    x
format_as_percentage      = ( x ) -> _format '#,##0.00',  x * 100
```

## Tabulation, `width_of`

## Hyphenation

see jzr/benchmarks/src/hyphenation/main.coffee
see jzr/benchmarks/README.md
probably using `mnater/hyphenopoly`

### Turning Texts into "Slabs"

What to call the part of a word that is separated from others by breakpoints


> The addressable unit of memory on the NCR 315 series is a "slab", short for "syllable", consisting of 12
> data bits and a parity bit. Its size falls between a byte and a typical word (hence the name, 'syllable').
> A slab may contain three digits (with at sign, comma, space, ampersand, point, and minus treated as
> digits) or two alphabetic characters of six bits each.—[Wikipedia, "NCR
> 315"](https://en.wikipedia.org/wiki/NCR_315)

Slabs used to be known as 'Logotypes' in typesetting:

> There were later attempts to speed up the typesetting process by casting syllables or entire words as one
> piece. Those pieces were called logotypes—from Ancient Greek “lógos” meaning
> “word”.—(typography.guru)[https://typography.guru/journal/words-and-phrases-in-common-use-which-originated-in-the-field-of-typography-r78/]


## HTML Parsing

see jzr/benchmarks/src/streaming-html-parsers/main.coffee
see jzr/benchmarks/src/streaming-html-parsers/mkts-tagparser.coffee

probably using `atlassubbed/atlas-html-stream`


## HTML Generation

Successor to `coffeenode-teacup`

Serialization implemented in [Datom](https://github.com/loveencounterflow/datom)

## Codepoint Characterization

JS regex unicode properties:

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

```
regex_cid_ranges =
  hiragana:     '[\u3041-\u3096]'
  katakana:     '[\u30a1-\u30fa]'
  kana:         '[\u3041-\u3096\u30a1-\u30fa]'
  ideographic:  '[\u3006-\u3007\u3021-\u3029\u3038-\u303a\u3400-\u4db5\u4e00-\u9fef\uf900-\ufa6d\ufa70-\ufad9\u{17000}-\u{187f7}\u{18800}-\u{18af2}\u{1b170}-\u{1b2fb}\u{20000}-\u{2a6d6}\u{2a700}-\u{2b734}\u{2b740}-\u{2b81d}\u{2b820}-\u{2cea1}\u{2ceb0}-\u{2ebe0}\u{2f800}-\u{2fa1d}]'
```

Should be extensible (extending/diminishing existing categories, add new ones)



## Links

* [regexpu-core/property-escapes.md at master · mathiasbynens/regexpu-core](https://github.com/mathiasbynens/regexpu-core/blob/master/property-escapes.md)
* [Unicode property escapes in JavaScript regular expressions · Mathias Bynens](https://mathiasbynens.be/notes/es-unicode-property-escapes)
* [https://unicode.org/Public/UNIDATA/PropertyValueAliases.txt](https://unicode.org/Public/UNIDATA/PropertyValueAliases.txt)
* [https://unicode.org/Public/UNIDATA/PropertyAliases.txt](https://unicode.org/Public/UNIDATA/PropertyAliases.txt)
* [UAX #24: Unicode Script Property](https://unicode.org/reports/tr24/#Script_Extensions)
* [UTS #18: Unicode Regular Expressions](https://unicode.org/reports/tr18/#RL1.2)
* [UAX #44: Unicode Character Database](https://unicode.org/reports/tr44/#Ideographic)
* [Unicode Utilities: UnicodeSet](https://unicode.org/cldr/utility/list-unicodeset.jsp?a=%5B%5B:name=/CJK/:%5D-%5B:ideographic:%5D%5D)

