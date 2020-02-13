

## InterText SLABS: Finding Linebreak Opportunities

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [API](#api)
- [`slb` Objects](#slb-objects)
- [A Practical Example](#a-practical-example)
- [Terminology](#terminology)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### API

* `@slabs_from_text = ( text ) ->`—Given a `text`, return an `slb` object as described below that describes
  all the UAX#14-compliant linebreak opportunities (LBOs) in that text.

* `@assemble = ( slb, first_idx = null, last_idx = null ) ->`—Given an `slb` object and, optionally, two
  slab indices, return a line of text, honoring the intermediate and final LBOs as needed for typesetting.

### `slb` Objects

An `slb` is a plain JS object with two attributes:
* `slb.slabs` is a list of strings containing the individual subparts of the original text;
* `slb.ends` ends is string of codepoints (in the range `U+0021..U+ffff`, excluding surrogates,
  non-printables, specials, and whitespace) of the same length as `slb.slabs`, each code unit using one of a
  number of codes to describe how the end (right edge in the case of LTR scripts, left edge in the case of
  RTL scripts) is to be treated when re-assembling lines from slabs.

### A Practical Example

Given a text that one would like to break into properly hyphenated lines of approximately equal length of,
say, up to 14 characters each:

```
a very fine day for a cromulent solution
```

The first step is to hyphenate the text. InterText `HYPH.hyphenate text` inserts 'Soft' (Discretionary)
Hyphen characters (U+00ad) into the text, here symbolized with `🞛`:

```
a very fine day for a cro🞛mu🞛lent so🞛lu🞛tion
```

Passing the hyphenated text to InterText `SLABS.slabs_from_text()` returns this `slb` object:

```coffee
{ slabs: [
    'a',   'very', 'fine',
    'day', 'for',  'a',
    'cro', 'mu',   'lent',
    'so',  'lu',   'tion'
  ],
  ends: '______||_||x'
}
```

> As it stands, `SLABS` `slb` objects use three different single-character markers in the `ends` string
> to indicate how to treat the corresponding slab with the same index:
>
> * `x` indicates 'none': insert nothing (empty string) whether non-final or final
> * `_` indicates 'space': insert space (U+0020) when non-final, insert nothing (empty string) when final
> * `|` indicates 'hyphen': insert nothing when non-final, add hyphen (U+002d) when final
>
> These may change in the future.

One can then use `( INTERTEXT.SLABS.assemble slb, 0, idx for idx in [ 0 ... slb.slabs.length ] )` to
re-assemble all possible initial lines:

```
a                                                  0    0    1
a very                                             0    1    6
a very fine                                        0    2    11
a very fine day                                    0    3    15
a very fine day for                                0    4    19
a very fine day for a                              0    5    21
a very fine day for a cro-                         0    6    26
a very fine day for a cromu-                       0    7    28
a very fine day for a cromulent                    0    8    31
a very fine day for a cromulent so-                0    9    35
a very fine day for a cromulent solu-              0    10   37
a very fine day for a cromulent solution           0    11   40
```

We can stop at the third iteration (`idx == 2`) since that yields a line that fits into the desired length
while the next one exceeds our 14-character limit. Continuing with a `first_idx` of `3`, the candidates for
the second line are:

```
day                                                3     3     3
day for                                            3     4     7
day for a                                          3     5     9
day for a cro-                                     3     6     14
day for a cromu-                                   3     7     16
```

which gives us `day for a cro-` as second line. Going on, one arrives at this finely formatted paragraph:

```
--------------
a very fine
day for a cro-
mulent solu-
tion
--------------
```

Hardly rocket science but also best not coded in too much of a cobbled-together ad-hoc way, all the more
since this barely scratches the surface of the complexities in line-oriented typesetting, which include but
are not limited to the following considersations:

* When the output is indeed monspaced as shown here, we still have to take care of wide glyphs (e.g. Chinese
  characters); InterText `?TBL?` will provide solutions for that. Generally speaking, using JavaScript
  `String#length` as a proxy for display is generally a bad idea and has only been done for presentation.

* When lines are considerably longer than the average slab width, a lot of unnecessary computations are
  performed. In real life situations, it will probably be more performant to estimate how man slabs will fit
  onto a given line and start looking from there instead of trying out all the solutions that are probably
  much too short anyway.

* Outside of the most restricted of environments, ligatures have to be taken into account, meaning that one
  has to either reconstruct font metrics in ones software (*don't*, see the next point) or else try each
  line candidate in the targetted application (e.g. a web browser) and retrieve the resulting typeset
  lengths. Needless, this will exacerbate performance considerations, so best to strive and limit the number
  of attempts need for each line.

* If text with mixed styles (different fonts, italic, bold, subscripts) is taken into consideration, all of
  a sudden the task shifts from *"let's just reconstruct the metrics of this TTF font so we can add all the
  character widths"* to *"let's write a full fledged universal font rendering engine that takes account of
  all the OpenType features and all the scripts and languages of the world"*. In other words, don't. Even.
  Try. Instead, use an existing piece of software.

  I still believe that under many circumstances, hyphenation paired with 'slabification' gives a good enough
  approximation to cut down the number of line candidates in a meaningful way, especially when the
  typesetting algorithm used to turn slabs into paragraphs has a good grasp on the spatial statistics of
  what it is trying to achieve (as in *'most lines contain between x and y English slabs, and each CJK
  codepoint is worth around 0.8 English slabs on average'*). You can't partition a long text in one go from
  end to end with confidence using these estimates, but one can use such numbers as a starting point to
  estimate how many of a given sequence of slabs will probably fit into a given line.

* In advanced typesetting, and maybe even when outputting to the console or typesetting a technical manual
  in all-monospace, using hanging punctuation may result in a more balanced look. One will then have to
  adjust the right edge (and maybe the left one, too) depending on the last (and first) characters of each
  candidate line.

* CSS properties like `word-spacing` and `letter-spacing` as well as [variable
  fonts](https://www.axis-praxis.org) provide an opportunity to typeset material (almost) imperceptibly
  denser or to distribute excessive whitespace among spaces proper, inter-letter spacing, and streched
  letters. This means that depending on preferences, it may be allowable to put material into a single line
  that is just a teeny bit too long by condensing letter shapes or tracking just a teeeeeny bit.

* Some writing systems (Arabic, Hebrew) allow or call for elongated letters that depend on available space;
  others may not use hyphens when breaking words.

* When scripts are mixed, boundaries between two different scripts require our attention. This is a
  considerably more vexing problem when mixing LTR (left-to-right) and RTL (right-to-left) scripts than in,
  say, mixing Latin and CJK in a paragraph, but this is not to say the latter isn't blessed with a good
  number of <strike>problems</strike> interesting questions that do not necessarily have unique answers.

### Terminology

> The addressable unit of memory on the NCR 315 series is a "slab", short for "syllable", consisting of 12
> data bits and a parity bit. Its size falls between a byte and a typical word (hence the name, 'syllable').
> A slab may contain three digits (with at sign, comma, space, ampersand, point, and minus treated as
> digits) or two alphabetic characters of six bits each.—[Wikipedia, "NCR
> 315"](https://en.wikipedia.org/wiki/NCR_315)

Slabs used to be known as 'Logotypes' in typesetting:

> There were later attempts to speed up the typesetting process by casting syllables or entire words as one
> piece. Those pieces were called logotypes—from Ancient Greek “lógos” meaning
> “word”.—(typography.guru)[https://typography.guru/journal/words-and-phrases-in-common-use-which-originated-in-the-field-of-typography-r78/]
