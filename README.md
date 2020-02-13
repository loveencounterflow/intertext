
# InterText

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [InterText: Services for Recurrent Text-related Tasks](#intertext-services-for-recurrent-text-related-tasks)
- [Links](#links)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## InterText: Services for Recurrent Text-related Tasks

InterText provides pre-packaged solutioons for a number of tasks in text formatting and typesetting that
tend to show up frequently. I'm aiming at conducing comparative benchmarks and soundness checks for all
solutions (see [Benchmarks](#benchmarks), below, for available data). The areas covered so far and planned
for the future include:

* [x] **InterText HYPH** for hyphenating text in multiple languages (only en-US covered so far, but
  underlying software is multilingual and configurable).

* [x] **InterText SLABS** for segmenting and re-assembling text according to *Unicode Standard Annex #14:
  Unicode Line Breaking Algorithm* (UAX#14); this is useful to determine line breaking opportunities (LBOs)
  for running text. So far, ASCII spaces (U+0020), Soft Hyphens (U+00ad) and implicit CJK Inter-Character
  Breaks work.

* [x] **InterText HTML** for parsing and generating HTML markup.

* [ ] **InterText ?ANSI?** for colorizing console output.

* [ ] **InterText ?TBL?** for tabulating console output; includes facilities to determing display width of
  individual characters and running text, taking into account 'wide' and 'narrow' characters.

* [ ] **InterText ?FMT?** for formatting numbers.

## Links

* [regexpu-core/property-escapes.md at master · mathiasbynens/regexpu-core](https://github.com/mathiasbynens/regexpu-core/blob/master/property-escapes.md)
* [Unicode property escapes in JavaScript regular expressions · Mathias Bynens](https://mathiasbynens.be/notes/es-unicode-property-escapes)
* [https://unicode.org/Public/UNIDATA/PropertyValueAliases.txt](https://unicode.org/Public/UNIDATA/PropertyValueAliases.txt)
* [https://unicode.org/Public/UNIDATA/PropertyAliases.txt](https://unicode.org/Public/UNIDATA/PropertyAliases.txt)
* [UAX #24: Unicode Script Property](https://unicode.org/reports/tr24/#Script_Extensions)
* [UTS #18: Unicode Regular Expressions](https://unicode.org/reports/tr18/#RL1.2)
* [UAX #44: Unicode Character Database](https://unicode.org/reports/tr44/#Ideographic)
* [Unicode Utilities: UnicodeSet](https://unicode.org/cldr/utility/list-unicodeset.jsp?a=%5B%5B:name=/CJK/:%5D-%5B:ideographic:%5D%5D)

