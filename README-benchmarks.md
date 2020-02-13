
## InterText Benchmarks

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Hyphenators](#hyphenators)
  - [Speed](#speed)
  - [Quality](#quality)
  - [Verdict](#verdict)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


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

