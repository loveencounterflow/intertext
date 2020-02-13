
## InterText HYPH: Hyphenation

Implemented with [`mnater/hyphenopoly`](https://github.com/mnater/Hyphenopoly).

* `INTERTEXT.HYPH.hyphenate = ( text ) ->`: return the text with soft hyphens (U+00ad) inserted. For
  languages other than US English, `INTERTEXT.HYPH.new_hyphenator = ( settings ) ->` may in a future version
  be used to obtain a custom hyphenation function.

* `INTERTEXT.HYPH.count_soft_hyphens = ( text ) ->`: Count occurances of U+00ad in `text`.

* `INTERTEXT.HYPH.reveal_hyphens = ( text, replacement = '-' ) ->`: Replace all soft hyphens with
  `replacement`.

