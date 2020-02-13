
# InterText

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [InterText: Services for Recurrent Text-related Tasks](#intertext-services-for-recurrent-text-related-tasks)
- [Related Links](#related-links)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## InterText: Services for Recurrent Text-related Tasks

InterText provides pre-packaged solutioons for a number of tasks in text formatting and typesetting that
tend to show up frequently. I'm aiming at conducing comparative [benchmarks](./README-benchmarks.md) and
soundness checks for all solutions. Areas covered so far include:


* [**InterText HTML**](./README-html.md): parse, generate HTML markup.

* [**InterText HYPH**](./README-hyphenation.md) for hyphenating text in multiple languages (only en-US
  covered so far, but underlying software is multilingual and configurable).

* [**InterText SLABS**](./README-slabs.md) for segmenting and re-assembling text according to *Unicode
  Standard Annex #14: Unicode Line Breaking Algorithm* (UAX#14); this is useful to determine line breaking
  opportunities (LBOs) for running text.

See also the (rough) [list of planned features](./README-planned.md).



## Related Links

* [regexpu-core/property-escapes.md at master · mathiasbynens/regexpu-core](https://github.com/mathiasbynens/regexpu-core/blob/master/property-escapes.md)
* [Unicode property escapes in JavaScript regular expressions · Mathias Bynens](https://mathiasbynens.be/notes/es-unicode-property-escapes)
* [https://unicode.org/Public/UNIDATA/PropertyValueAliases.txt](https://unicode.org/Public/UNIDATA/PropertyValueAliases.txt)
* [https://unicode.org/Public/UNIDATA/PropertyAliases.txt](https://unicode.org/Public/UNIDATA/PropertyAliases.txt)
* [UAX #24: Unicode Script Property](https://unicode.org/reports/tr24/#Script_Extensions)
* [UTS #18: Unicode Regular Expressions](https://unicode.org/reports/tr18/#RL1.2)
* [UAX #44: Unicode Character Database](https://unicode.org/reports/tr44/#Ideographic)
* [Unicode Utilities: UnicodeSet](https://unicode.org/cldr/utility/list-unicodeset.jsp?a=%5B%5B:name=/CJK/:%5D-%5B:ideographic:%5D%5D)

