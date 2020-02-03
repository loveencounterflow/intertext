<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Ansi Colors (??? or keep in CND)](#ansi-colors--or-keep-in-cnd)
- [Number Formatting](#number-formatting)
- [Tabulation, `width_of`](#tabulation-width_of)
- [Hyphenation](#hyphenation)
  - [Turning Texts into "Slabs"](#turning-texts-into-slabs)
- [HTML](#html)
  - [HTML Parsing](#html-parsing)
  - [HTML Generation](#html-generation)
  - [Example: HTML Parsing and HTML Generation](#example-html-parsing-and-html-generation)
- [Codepoint Characterization](#codepoint-characterization)
- [Benchmarks](#benchmarks)
  - [Hyphenators](#hyphenators)
    - [Speed](#speed)
    - [Quality](#quality)
    - [Verdict](#verdict)
- [Links](#links)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


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

Implemented with [`mnater/hyphenopoly`](https://github.com/mnater/Hyphenopoly).

* `INTERTEXT.hyphenate = ( text ) ->`: return the text with soft hyphens (U+00ad) inserted. For languages
  other than US English, `INTERTEXT.new_hyphenator = ( settings ) ->` may in a future version be used to
  obtain a custom hyphenation function.

* `INTERTEXT.count_soft_hyphens = ( text ) ->`: Count occurances of U+00ad in `text`.

* `INTERTEXT.reveal_hyphens = ( text, replacement = '-' ) ->`: Replace all soft hyphens with `replacement`.


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


## HTML

### HTML Parsing

HTML parsing uses [`atlassubbed/atlas-html-stream`](https://github.com/atlassubbed/atlas-html-stream) to
turn HTML5 texts into series of [datoms](https://github.com/loveencounterflow/datom). Two HTML formats are
supported:

* plain HTML5, and
* MKTScript, a nascent crossbreed of a kind-of MarkDown with HTMLish tags.

Unless you know what you're after you'll probably want to use the plain HTML5 flavor.

After `{ HTML, } = require 'intertext'`, use one of these methods:

* `HTML.html_as_datoms = ( text ) ->` to turn HTML fragments or entire documents into a list of datoms, or

* `HTML.mkts_html_as_datoms = ( text ) ->` to do the same with MKTScript.

Both methods work pretty much the same and are the inverse operations to `HTML.datom_as_html()`:

* All opening tags will be turned into datoms whose `$key` is the tagname prefixed with the left pointy
  bracket as sigil, and attribute name/value pairs becoming properties of the datom.
* Closing tags will be turned into datoms whose `$key` is the tagname prefixed with the right pointy bracket
  as sigil.
* For plain HTML, 'lone'/'self-closing' tags will be treated like an opening tag immediately followed by a
  closing tag. as sigil.
* For MKTScript, 'lone'/'self-closing' tags will be turned into datoms whose `$key` is the tagname prefixed
  with the caret as sigil.
* Intermittent text will be turned into datoms whose `$key` is `^text` and whose contents are stored under
  the `text` property.
* Whitespace will be preserved.

### HTML Generation

<!-- Successor to `coffeenode-teacup`? -->

`{ HTML, } = require 'intertext'`

* `HTML.datom_as_html = ( d ) ->`


* For the tagname:
  *  `d.$key` will become the tagname
  * the tagname must conform to the [XML tagname restrictions](https://www.w3.org/TR/xml)

* For the attributes:
  * all facets with value `true` (the boolean, not the text) will be turned into 'lone attributes', such
    that `{ $key: '<p', contenteditable: true, }` will result in `<p contenteditable>`
  * facet values are subject to HTML5 attribute value escaping rules as detailed in
    https://mathiasbynens.be/notes/unquoted-attribute-values
  * where permitted, values will be left unquoted ('naked'); where necessary, values will be surrounded
    by `'` (single quotes)
  * facets with an empty string are not treated specially; per attribute value escaping rules, they will
    result in `''` (two single quotes)
  * all keys that start with a `$` will be ignored
  * if `d.$value` is an object, its facets will be turned into HTML attributes; all other keys are ignored

* Open questions:
  * how to treat system-level names (sigils `[`, `~`, `]`)?
    * ignore?
    * as comments?
    * as prefixed/namespaced tags?
  * how to treat datom keys that contain hyphens, underscores?
    * turn underscores into hyphens?

### Example: HTML Parsing and HTML Generation

```coffee
text = """<!DOCTYPE html>
<h1><strong>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>

<p id=p227>However, the egg only got larger and larger, and <em>more and more human</em>:<br>

when she had come within a few yards of it, she saw that it had eyes and a nose and mouth; and when she
had come close to it, she saw clearly that it was <name ref=hd556>HUMPTY DUMPTY</name> himself. ‘It can’t
be anybody else!’ she said to herself.<br/>

‘I’m as certain of it, as if his name were written all over his face.’

"""
for d in HTML.html_as_datoms text
  log JSON.stringify d
log '-'.repeat 108
log ( HTML.datom_as_html d for d in datoms ).join ''
```

... will produce:

```json
{ "$key": "^doctype",   "$value": "html",                                                           }
{ "$key": "^text",      "text":   "\n",                                                             }
{ "$key": "<h1",                                                                                    }
{ "$key": "<strong",                                                                                }
{ "$key": "^text",      "text":   "CHAPTER VI.",                                                    }
{ "$key": ">strong",                                                                                }
{ "$key": "^text",      "text":   " ",                                                              }
{ "$key": "<name",      "ref":    "hd553",                                                          }
{ "$key": "^text",      "text":   "Humpty Dumpty",                                                  }
{ "$key": ">h1",                                                                                    }
{ "$key": "^text",      "text":   "\n\n",                                                           }
{ "$key": "<p",         "id":     "p227",                                                           }
{ "$key": "^text",      "text":   "However, the egg only got larger and larger, and ",              }
{ "$key": "<em",                                                                                    }
{ "$key": "^text",      "text":   "more and more human",                                            }
{ "$key": ">em",                                                                                    }
{ "$key": "^text",      "text":   ":",                                                              }
{ "$key": "<br",                                                                                    }
{ "$key": "^text",      "text":   "\n\nwhen she had come within ...  she saw clearly that it was ", }
{ "$key": "<name",      "ref":    "hd556",                                                          }
{ "$key": "^text",      "text":   "HUMPTY DUMPTY",                                                  }
{ "$key": ">name",                                                                                  }
{ "$key": "^text",      "text":   " himself. ‘It can’t\nbe anybody else!’ she said to herself.",    }
{ "$key": "<br",                                                                                    }
{ "$key": ">br",                                                                                    }
{ "$key": "^text",      "text":   "\n\n‘I’m as certain ... all over his face.’\n",                  }
```

```html
<!DOCTYPE html>
<h1><strong>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>

<p id=p227>However, the egg only got larger and larger, and <em>more and more human</em>:<br>

when she had come within a few yards of it, she saw that it had eyes and a nose and mouth; and when she
had come close to it, she saw clearly that it was <name ref=hd556>HUMPTY DUMPTY</name> himself. ‘It can’t
be anybody else!’ she said to herself.<br></br>

‘I’m as certain of it, as if his name were written all over his face.’
```

As can be seen, no validation will be done, and the parser will happily produce events for unclosed and
unbalanced closing tags. There is a minor issue with the `<br></br>` tag pair which will get resolved in
a future version.


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


## Benchmarks

### Hyphenators

#### Speed

Against 100,000 words randomly selected anew for each test case from `/usr/share/dict/american-english`
(102,305 words) over 5 runs, total time needed 32s; observe

```
fresh
hyphenate_mnater_hyphenopoly_sync                242,819 Hz   100.0 % │████████████▌│
hyphenate_sergeysolovev_hyphenated               176,003 Hz    72.5 % │█████████    │
hyphenate_bramstein_hypher                       107,437 Hz    44.2 % │█████▌       │
hyphenate_ytiurin_hyphen                             658 Hz     0.3 % │             │
```

These figures have been reproduced several times; if we do not re-generate the selection of words for each
test case but have all hyphenators hyphenate the same collection over, performance seems to improve
slightly:

```
same
hyphenate_mnater_hyphenopoly_sync                345,892 Hz   100.0 % │████████████▌│
hyphenate_sergeysolovev_hyphenated               219,550 Hz    63.5 % │███████▉     │
hyphenate_bramstein_hypher                       121,050 Hz    35.0 % │████▍        │
hyphenate_ytiurin_hyphen                             707 Hz     0.2 % │             │
```

Curiously when only a single run is done, `bramstein/hypher` and `sergeysolovev/hyphenated` changes places
and, curioser still, almost exactly their relative performances; also note how overall performance seems to
drop:

```
00:09 BENCHMARKS  ▶  hyphenate_mnater_hyphenopoly_sync                144,789 Hz   100.0 % │████████████▌│
00:09 BENCHMARKS  ▶  hyphenate_bramstein_hypher                       108,914 Hz    75.2 % │█████████▍   │
00:09 BENCHMARKS  ▶  hyphenate_sergeysolovev_hyphenated                46,895 Hz    32.4 % │████         │
00:09 BENCHMARKS  ▶  hyphenate_ytiurin_hyphen                             638 Hz     0.4 % │             │
```



#### Quality

`/etc/dictionaries-common/words`, total 102,305 English words (so probably the exact same as
`/usr/share/dict/american-english`)

`hypher` would appear to have a rather serious flaw in that it insists on inserting a hyphen before the last
letter of a word when that word ends in an apostrophe (or a single quote) plus letter `s` to indicate a
genitive (so far I have not tested whether that strange behavior also occurs with other situations involving
apostrophes or quotes); this occurs in 3,057 (3%) of all words in the list:

```
hyphenopoly                    hypher
—————————————————————————————————————————————————————————
thun-der-storm’s               thun-der-stor-m’s
tib-ia’s                       tib-i-a’s
tights’s                       tight-s’s
time-stamp’s                   time-stam-p’s
```

In a very small number of words (36 or 0.035%), `hyphenopoly` inserts fewer hyphens than `hypher`; many of
these have letters with diacritics; observe that some words with diacritics *are* hyphenated by
`hyphenopoly`:

```
hyphenopoly                    hypher
—————————————————————————————————————————————————————————
Düssel-dorf                    Düs-sel-dorf
Es-terházy                     Es-ter-házy
Furtwängler                    Furtwän-gler
Göteborg                       Göte-borg
Pokémon                        Poké-mon
Pétain                         Pé-tain
abbés                          ab-bés
as-so-ciate                    as-so-ci-ate
as-so-ciates                   as-so-ci-ates
châtelaine                     châte-laine
châtelaines                    châte-laines
clientèle                      clien-tèle
clientèles                     clien-tèles
croûton                        croû-ton
croûtons                       croû-tons
di-vorcée                      di-vor-cée
di-vorcées                     di-vor-cées
décol-leté                     dé-col-leté
détente                        dé-tente
flambéed                       flam-béed
ingénue                        in-génue
ingénues                       in-génues
matinée                        mat-inée
matinées                       mat-inées
present                        pre-sent
presents                       pre-sents
project                        pro-ject
projects                       pro-jects
protégé                        pro-tégé
protégés                       pro-tégés
précis                         pré-cis
précised                       pré-cised
précis-ing                     pré-cis-ing
recherché                      recher-ché
reci-procity                   rec-i-proc-ity
smörgåsbord                    smörgås-bord
```

#### Verdict

In terms of speed, `ytiurin/hyphen` is clearly the looser, being almost 500 times slower than the
consistenly fastest hyphenator, `mnater/hyphenopoly`.

`bramstein/hypher` and `sergeysolovev/hyphenated` vie for the second place to the extent that modifying the
test setup somwhat will make them change places; however, at least `bramstein/hypher` has some serious flaws
which seems surprising in view of its popularity. Given their poor configurability, the fact they will take
twice to four times as long as `hyphenopoly` and apparently not catch more opportunities than that library,
the choice becomes a very easy one.

`mnater/hyphenopoly` is the clear winner: it has the most extensive tweaking configuration (including
per-language exceptions, minimum number of letters to be left on both ends of words and so on); it is
extensively documented (see https://github.com/mnater/Hyphenopoly/docs). In no case have we observed a
hyphen placement that could be termed unacceptable. If anything, `hyphenopoly` misses some obvious
opportunities; in particular, it seems to have an adversion (but not a strict taboo) against hyphenating
words in the genitive case. That, be it said, is still much better than suggesting to write `tight-s’s` as
`hypher` would have it.



## Links

* [regexpu-core/property-escapes.md at master · mathiasbynens/regexpu-core](https://github.com/mathiasbynens/regexpu-core/blob/master/property-escapes.md)
* [Unicode property escapes in JavaScript regular expressions · Mathias Bynens](https://mathiasbynens.be/notes/es-unicode-property-escapes)
* [https://unicode.org/Public/UNIDATA/PropertyValueAliases.txt](https://unicode.org/Public/UNIDATA/PropertyValueAliases.txt)
* [https://unicode.org/Public/UNIDATA/PropertyAliases.txt](https://unicode.org/Public/UNIDATA/PropertyAliases.txt)
* [UAX #24: Unicode Script Property](https://unicode.org/reports/tr24/#Script_Extensions)
* [UTS #18: Unicode Regular Expressions](https://unicode.org/reports/tr18/#RL1.2)
* [UAX #44: Unicode Character Database](https://unicode.org/reports/tr44/#Ideographic)
* [Unicode Utilities: UnicodeSet](https://unicode.org/cldr/utility/list-unicodeset.jsp?a=%5B%5B:name=/CJK/:%5D-%5B:ideographic:%5D%5D)

