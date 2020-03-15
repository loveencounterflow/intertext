
## InterText HTML: Parse and Generate HTML5


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [API Overview](#api-overview)
- [General Considerations](#general-considerations)
- [HTML Parsing](#html-parsing)
- [HTML Generation](#html-generation)
  - [HTML Generation from Datoms](#html-generation-from-datoms)
  - [HTML Generation from Method Calls](#html-generation-from-method-calls)
- [Example: HTML Parsing and HTML Generation](#example-html-parsing-and-html-generation)
- [Remarks](#remarks)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### API Overview

```
INTERTEXT.HTML

  # HTML parser
    html_from_datoms
    $html_from_datoms

  # HTML generator
    datoms_from_html
    $datoms_from_html
    tag
    css
    raw
    script
    text
    # CupOfJoe
      new INTERTEXT.HTML.Cupofhtml { flatten: true, }
        tag
        css
        raw
        script
        text
```



### General Considerations

* Parsing takes a single text (or a stream of texts) as input and generates a list of (or a stream of)
  [datoms](https://github.com/loveencounterflow/datom) as output.

* Conversely, HTML generation works by taking a list (or a stream) of
  [datoms](https://github.com/loveencounterflow/datom) as input and generating a single text (or a stream of
  texts) with tags and properly HTML-escaped text content as output.

* In HTML5 parsing, no errors will be thrown; in principle, any string may be thrown at the parser. However,
  (in the future) there may be system-level datoms with warnings interspersed with the output.

* [HTML5 empty tags](https://developer.mozilla.org/en-US/docs/Glossary/empty_element) will be honored: when
  parsing HTML, tags like `<br>`, `<img>`, `<hr>` are considered complete without being explicitly closed;
  their self-closing versions `<br/>`, `<img/>`, `<hr/>` will be parsed like the unslashed versions, and
  their closing counterparts `</br>`, `</img>`, `</hr>` will be silently ignored.

  > List of HTML5 empty tags: `area`, `base`, `br`, `col`, `embed`, `hr`, `img`, `input`, `link`, `meta`,
  > `param`, `source`, `track`, `wbr`. This list is fixed for now, but may conceivably become configurable
  > in the future.

* InterText HTML uses the most generous definition of an XML name, ever. It basically allows anything except
  those few characters that would definitely mess with the rest of the grammar, so tags like `<123>`,
  `<foo:bar#baz.gnu bro:go=42>` are totally OK. Consumers are advised to do their own checking to narrow
  down available choices or interpret special constructs, as the case may be. A valid InterText HTML name is
  any sequence of one or more characters, excluding only
  * whitespace,
  * brackets (`{[(<>)]}`),
  * question and exclamation marks (`!?`),
  * slashes (`/`),
  * equal signs (`=`),
  * and quotes (`'` and `"`).

* Special constructs are not further analyzed ATM; this includes
  * Doctypes (e.g. `<!DOCTYPE html>`),
  * XML declarations (e.g. `<?xml foo bar?>`),
  * Processing Instructions (e.g. `<?what ever?>`).
  Observe that tag-like constructs that start with `<?` (left pointy bracket, question mark) but end with a
  plain `>` (right pointy bracket) not preceded by a `?` (question mark) are considered ungrammatical (they
  are be allowed in SGML, though).

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

In [SteamPipe](https://github.com/loveencounterflow/steampipes) streams, use the transforms returned by

* `$html_as_datoms()`
* `$mkts_html_as_datoms()`

for the same functionality; both transforms accept texts and buffers as inputs.

### HTML Generation

* two formats ?
* one with lists
* one à la Teacup, with implicit function calls



#### HTML Generation from Datoms

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

Experimental method: `HTML.datoms_as_nlhtml = ( ds... ) ->` to add a newline befor each [HTML5 Block-Level
Tag](https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements).

#### HTML Generation from Method Calls

compact syntax for HTML tags:

* `HTML.parse_compact_tagname = ( compact_tagname ) ->`: Given a string with tagname followed by using CSS
  selector syntax, return an object with `tagname`, `id`, `class`

* `HTML.datoms_as_html = ( ds ) ->`

* `HTML.dhtml = ( compact_tagname, attributes, content... ) ->`

`<div#c432.foo.bar>...</div>` => `<div id=c432 class='foo bar'>...</div>`
`<p.noindent>...</p>` => `<p class=noindent>...</p>`





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


### Remarks


