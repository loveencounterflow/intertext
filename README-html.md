
## InterText HTML: Parse and Generate HTML5


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [API Overview](#api-overview)
- [General Considerations](#general-considerations)
- [HTML Generation](#html-generation)
  - [HTML Generation from Datoms](#html-generation-from-datoms)
  - [HTML Generation from Method Calls](#html-generation-from-method-calls)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### API Overview

```
INTERTEXT.HTML

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

* HTML generation works by taking a list (or a stream) of
  [datoms](https://github.com/loveencounterflow/datom) as input and generating a single text (or a stream of
  texts) with tags and properly HTML-escaped text content as output.

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




<!--
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

 -->