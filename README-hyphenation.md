
## InterText HYPH: Hyphenation

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [InterText HYPH: Hyphenation](#intertext-hyph-hyphenation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



Implemented with [`mnater/hyphenopoly`](https://github.com/mnater/Hyphenopoly).

* `INTERTEXT.HYPH.hyphenate = ( text ) ->`: return the text with soft hyphens (U+00ad) inserted. For
  languages other than US English, `INTERTEXT.HYPH.new_hyphenator = ( settings ) ->` may in a future version
  be used to obtain a custom hyphenation function.

* `INTERTEXT.HYPH.count_soft_hyphens = ( text ) ->`: Count occurances of U+00ad in `text`.

* `INTERTEXT.HYPH.reveal_hyphens = ( text, replacement = '-' ) ->`: Replace all soft hyphens with
  `replacement`.

