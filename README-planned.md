
## InterText Planned Features

* [ ] Integrate [TimeTunnel](https://github.com/loveencounterflow/timetunnel)

* [ ] Integrate [jzr](https://github.com/loveencounterflow/jzr), repurpose that package

* [ ] https://github.com/slevithan/xregexp (?)
* [ ] PCRE, RE2 (???)

* [ ] **InterText ?ANSI?** for colorizing console output.

* [ ] **InterText ?TBL?** for tabulating console output; includes facilities to determing display width of
  individual characters and running text, taking into account 'wide' and 'narrow' characters.

* [ ] **InterText ?FMT?** for formatting numbers.

* [ ] **Code Bautification** with https://github.com/beautify-web/js-beautify (https://beautifier.io/)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Ansi Colors (??? or keep in CND)](#ansi-colors--or-keep-in-cnd)
- [Number Formatting](#number-formatting)
- [Tabulation, `width_of`](#tabulation-width_of)
- [Codepoint Characterization](#codepoint-characterization)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### Ansi Colors (??? or keep in CND)

* use TrueColors for modern terminal emulators

### Number Formatting

```coffee
_format                   = require 'number-format.js'
format_float              = ( x ) -> _format '#,##0.000', x
format_integer            = ( x ) -> _format '#,##0.',    x
format_as_percentage      = ( x ) -> _format '#,##0.00',  x * 100
```

### Tabulation, `width_of`

### Codepoint Characterization

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

