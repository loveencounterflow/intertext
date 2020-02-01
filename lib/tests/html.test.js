(function() {
  'use strict';
  var CND, DATOM, HTML, alert, badge, debug, echo, help, info, isa, jr, lets, log, new_datom, rpr, select, test, type_of, types, urge, validate, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/TESTS/HTML';

  log = CND.get_logger('plain', badge);

  info = CND.get_logger('info', badge);

  whisper = CND.get_logger('whisper', badge);

  alert = CND.get_logger('alert', badge);

  debug = CND.get_logger('debug', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  echo = CND.echo.bind(CND);

  ({jr} = CND);

  //...........................................................................................................
  DATOM = new (require('datom')).Datom({
    dirty: false
  });

  ({new_datom, lets, select} = DATOM.export());

  types = require('../types');

  // cast
  // declare
  // declare_cast
  // check
  // sad
  // is_sad
  // is_happy
  ({isa, validate, type_of} = types);

  HTML = require('../html');

  //...........................................................................................................
  test = require('guy-test');

  //===========================================================================================================
  // TESTS
  //-----------------------------------------------------------------------------------------------------------
  this["must quote attribute value"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [["", true, null], ["\"", true, null], ["'", true, null], ["<", true, null], ["<>", true, null], ["foo", false, null], ["foo bar", true, null], ["foo\nbar", true, null]];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var must_quote;
          must_quote = !isa.intertext_html_naked_attribute_value(probe);
          return resolve(must_quote);
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["DATOM.HTML._as_attribute_literal"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [["", "''", null], ['"', '\'"\'', null], ["'", "'&#39;'", null], ["<", "'&lt;'", null], ["<>", "'&lt;&gt;'", null], ["foo", "foo", null], ["foo bar", "'foo bar'", null], ["foo\nbar", "'foo&#10;bar'", null], ["'<>'", "'&#39;&lt;&gt;&#39;'", null]];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          return resolve(HTML._as_attribute_literal(probe));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["isa.intertext_html_tagname"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [["", false, null], ["\"", false, null], ["'", false, null], ["<", false, null], ["<>", false, null], ["foo bar", false, null], ["foo\nbar", false, null], ["foo", true, null], ["此は何ですか", true, null]];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          return resolve(isa.intertext_html_tagname(probe));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.datom_as_html (singular tags)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [['^foo'],
      "<foo></foo>"],
      [
        [
          '^foo',
          {
            height: 42
          }
        ],
        "<foo height=42></foo>"
      ],
      [
        [
          '^foo',
          {
            class: 'plain'
          }
        ],
        "<foo class=plain></foo>"
      ],
      [
        [
          '^foo',
          {
            class: 'plain hilite'
          }
        ],
        "<foo class='plain hilite'></foo>"
      ],
      [
        [
          '^foo',
          {
            editable: true
          }
        ],
        "<foo editable></foo>"
      ],
      [
        [
          '^foo',
          {
            empty: ''
          }
        ],
        "<foo empty=''></foo>"
      ],
      [
        [
          '^foo',
          {
            specials: '<\n\'"&>'
          }
        ],
        "<foo specials='&lt;&#10;&#39;\"&amp;&gt;'></foo>"
      ],
      [
        [
          '^something',
          {
            one: 1,
            two: 2
          }
        ],
        "<something one=1 two=2></something>"
      ],
      [
        [
          '^something',
          {
            z: 'Z',
            a: 'A'
          }
        ],
        "<something a=A z=Z></something>"
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var d;
          d = new_datom(...probe);
          return resolve(HTML.datom_as_html(d));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.datom_as_html (closing tags)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [['>foo'],
      "</foo>"],
      [
        [
          '>foo',
          {
            height: 42
          }
        ],
        "</foo>"
      ],
      [
        [
          '>foo',
          {
            class: 'plain'
          }
        ],
        "</foo>"
      ],
      [
        [
          '>foo',
          {
            class: 'plain hilite'
          }
        ],
        "</foo>"
      ],
      [
        [
          '>foo',
          {
            editable: true
          }
        ],
        "</foo>"
      ],
      [
        [
          '>foo',
          {
            empty: ''
          }
        ],
        "</foo>"
      ],
      [
        [
          '>foo',
          {
            specials: '<\n\'"&>'
          }
        ],
        "</foo>"
      ],
      [
        [
          '>something',
          {
            one: 1,
            two: 2
          }
        ],
        "</something>"
      ],
      [
        [
          '>something',
          {
            z: 'Z',
            a: 'A'
          }
        ],
        "</something>"
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var d;
          d = new_datom(...probe);
          return resolve(HTML.datom_as_html(d));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.datom_as_html (opening tags)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [['<foo'],
      "<foo>"],
      [
        [
          '<foo',
          {
            height: 42
          }
        ],
        "<foo height=42>"
      ],
      [
        [
          '<foo',
          {
            class: 'plain'
          }
        ],
        "<foo class=plain>"
      ],
      [
        [
          '<foo',
          {
            class: 'plain hilite'
          }
        ],
        "<foo class='plain hilite'>"
      ],
      [
        [
          '<foo',
          {
            editable: true
          }
        ],
        "<foo editable>"
      ],
      [
        [
          '<foo',
          {
            empty: ''
          }
        ],
        "<foo empty=''>"
      ],
      [
        [
          '<foo',
          {
            specials: '<\n\'"&>'
          }
        ],
        "<foo specials='&lt;&#10;&#39;\"&amp;&gt;'>"
      ],
      [
        [
          '<something',
          {
            one: 1,
            two: 2
          }
        ],
        "<something one=1 two=2>"
      ],
      [
        [
          '<something',
          {
            z: 'Z',
            a: 'A'
          }
        ],
        "<something a=A z=Z>"
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var d;
          d = new_datom(...probe);
          return resolve(HTML.datom_as_html(d));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.datom_as_html (texts)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [['^text'],
      ""],
      [
        [
          '^text',
          {
            height: 42
          }
        ],
        ""
      ],
      [
        [
          '^text',
          {
            text: '<me & you>\n'
          }
        ],
        "&lt;me &amp; you&gt;\n"
      ],
      [
        [
          '<text',
          {
            z: 'Z',
            a: 'A'
          }
        ],
        "<text a=A z=Z>"
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var d;
          d = new_datom(...probe);
          return resolve(HTML.datom_as_html(d));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.datom_as_html (opening tags w/ $value)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [['<foo'],
      "<foo>"],
      [
        [
          '<foo',
          {
            ignored: 'xxx',
            $value: {
              height: 42
            }
          }
        ],
        "<foo height=42>"
      ],
      [
        [
          '<foo',
          {
            ignored: 'xxx',
            $value: {
              class: 'plain'
            }
          }
        ],
        "<foo class=plain>"
      ],
      [
        [
          '<foo',
          {
            ignored: 'xxx',
            $value: {
              class: 'plain hilite'
            }
          }
        ],
        "<foo class='plain hilite'>"
      ],
      [
        [
          '<foo',
          {
            ignored: 'xxx',
            $value: {
              editable: true
            }
          }
        ],
        "<foo editable>"
      ],
      [
        [
          '<foo',
          {
            ignored: 'xxx',
            $value: {
              empty: ''
            }
          }
        ],
        "<foo empty=''>"
      ],
      [
        [
          '<foo',
          {
            ignored: 'xxx',
            $value: {
              specials: '<\n\'"&>'
            }
          }
        ],
        "<foo specials='&lt;&#10;&#39;\"&amp;&gt;'>"
      ],
      [
        [
          '<something',
          {
            ignored: 'xxx',
            $value: {
              one: 1,
              two: 2
            }
          }
        ],
        "<something one=1 two=2>"
      ],
      [
        [
          '<something',
          {
            ignored: 'xxx',
            $value: {
              z: 'Z',
              a: 'A'
            }
          }
        ],
        "<something a=A z=Z>"
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var d;
          d = new_datom(...probe);
          return resolve(HTML.datom_as_html(d));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.datom_as_html (system tags)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [["~foo"],
      "<x-sys x-key=foo><x-sys-key>foo</x-sys-key></x-sys>",
      null],
      [
        [
          "~foo",
          {
            "height": 42
          }
        ],
        "<x-sys x-key=foo height=42><x-sys-key>foo</x-sys-key></x-sys>",
        null
      ],
      [
        [
          "[foo",
          {
            "class": "plain"
          }
        ],
        "<x-sys x-key=foo class=plain><x-sys-key>foo</x-sys-key>",
        null
      ],
      [
        [
          "[foo",
          {
            "class": "plain hilite"
          }
        ],
        "<x-sys x-key=foo class='plain hilite'><x-sys-key>foo</x-sys-key>",
        null
      ],
      [
        [
          "]foo",
          {
            "editable": true
          }
        ],
        "</x-sys>",
        null
      ],
      [
        [
          "]foo",
          {
            "empty": ""
          }
        ],
        "</x-sys>",
        null
      ],
      [
        [
          "~foo",
          {
            "specials": "<\n'\"&>"
          }
        ],
        "<x-sys x-key=foo specials='&lt;&#10;&#39;\"&amp;&gt;'><x-sys-key>foo</x-sys-key></x-sys>",
        null
      ],
      [
        [
          "~something",
          {
            "one": 1,
            "two": 2
          }
        ],
        "<x-sys x-key=something one=1 two=2><x-sys-key>something</x-sys-key></x-sys>",
        null
      ],
      [
        [
          "~something",
          {
            "z": "Z",
            "a": "A"
          }
        ],
        "<x-sys x-key=something a=A z=Z><x-sys-key>something</x-sys-key></x-sys>",
        null
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var d;
          d = new_datom(...probe);
          return resolve(HTML.datom_as_html(d));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.datom_as_html (raw pseudo-tag)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [['^raw'],
      ""],
      [
        [
          '^raw',
          {
            height: 42
          }
        ],
        ""
      ],
      [
        [
          '^raw',
          {
            text: '<\n\'"&>'
          }
        ],
        '<\n\'"&>'
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var d;
          d = new_datom(...probe);
          return resolve(HTML.datom_as_html(d));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.datom_as_html (doctype)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [['^doctype'],
      "<!DOCTYPE html>"],
      [
        [
          '^doctype',
          {
            height: 42
          }
        ],
        "<!DOCTYPE html>"
      ],
      [['^doctype',
      "obvious"],
      "<!DOCTYPE obvious>"]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var d;
          d = new_datom(...probe);
          return resolve(HTML.datom_as_html(d));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.html_as_datoms (1)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [
        "<!DOCTYPE html>",
        [
          {
            "$value": "html",
            "$key": "^doctype"
          }
        ],
        null
      ],
      [
        "<!DOCTYPE obvious>",
        [
          {
            "$value": "obvious",
            "$key": "^doctype"
          }
        ],
        null
      ],
      [
        "<p contenteditable>",
        [
          {
            "contenteditable": true,
            "$key": "<p"
          }
        ],
        null
      ],
      [
        "<img width=200>",
        [
          {
            "width": "200",
            "$key": "<img"
          }
        ],
        null
      ],
      [
        "<foo/>",
        [
          {
            "$key": "<foo"
          },
          {
            "$key": ">foo"
          }
        ],
        null
      ],
      [
        "<foo></foo>",
        [
          {
            "$key": "<foo"
          },
          {
            "$key": ">foo"
          }
        ],
        null
      ],
      [
        "<p>here and<br>there",
        [
          {
            "$key": "<p"
          },
          {
            "text": "here and",
            "$key": "^text"
          },
          {
            "$key": "<br"
          },
          {
            "text": "there",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "<p>here and<br>there</p>",
        [
          {
            "$key": "<p"
          },
          {
            "text": "here and",
            "$key": "^text"
          },
          {
            "$key": "<br"
          },
          {
            "text": "there",
            "$key": "^text"
          },
          {
            "$key": ">p"
          }
        ],
        null
      ],
      [
        "<p>here and<br/>there</p>",
        [
          {
            "$key": "<p"
          },
          {
            "text": "here and",
            "$key": "^text"
          },
          {
            "$key": "<br"
          },
          {
            "$key": ">br"
          },
          {
            "text": "there",
            "$key": "^text"
          },
          {
            "$key": ">p"
          }
        ],
        null
      ],
      [
        "just some plain text",
        [
          {
            "$key": "^text",
            "text": "just some plain text"
          }
        ],
        null
      ],
      [
        "<p>one<p>two",
        [
          {
            "$key": "<p"
          },
          {
            "text": "one",
            "$key": "^text"
          },
          {
            "$key": "<p"
          },
          {
            "text": "two",
            "$key": "^text"
          }
        ],
        null
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          return resolve(HTML.html_as_datoms(probe));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.html_as_datoms (dubious)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [
        /* TAINT these edge cases should be solved by an appropriate (MKTScript) pre-processor; NB that in
                 MKTScript stray pointy brackets in ordinary text (but not in `<code>` blocks) are forbidden and must
                 be escaped as entities wherever they appear in attribute values; these rules, however, do not
                 necessarily apply when parsing general HTML sources. */
      /*
              ["< >",[{"text":"< >","$key":"^text"}],null]          # !!! silent failure
              ["< x >",[{"text":"< x >","$key":"^text"}],null]      # !!! silent failure
              ["<>",[{"text":"<>","$key":"^text"}],null]            # !!! silent failure
              ["<",[{"text":"<","$key":"^text"}],null]              # !!! silent failure
              ["<tag",[{"text":"<tag","$key":"^text"}],null]        # !!! silent failure
              */
      "if <math> a > b </math> then",
        [
          {
            "text": "if ",
            "$key": "^text"
          },
          {
            "$key": "<math"
          },
          {
            "text": " a > b ",
            "$key": "^text"
          },
          {
            "$key": ">math"
          },
          {
            "text": " then",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        ">",
        [
          {
            "text": ">",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "&",
        [
          {
            "text": "&",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "&amp;",
        [
          {
            "text": "&amp;",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "<tag a='<'>",
        [
          {
            "a": "<",
            "$key": "<tag"
          }
        ],
        null
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          return resolve(HTML.html_as_datoms(probe));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.html_as_datoms (dubious w/ pre-processor)"] = async function(T, done) {
    var error, find_next_tag, i, len, matcher, parse_mktscript_html, probe, probes_and_matchers;
    //.........................................................................................................
    find_next_tag = function(text, prv_idx = 0) {
      var idx_0, idx_1;
      idx_0 = text.indexOf('<', prv_idx);
      idx_1 = text.indexOf('>', prv_idx);
      if (idx_0 < 0) {
        if (idx_1 < 0) {
          return [null, null];
        }
        throw new Error("Syntax error: closing but no opening bracket");
      }
      if (idx_1 < 0) {
        throw new Error("Syntax error: opening but no closing bracket");
      }
      if (idx_1 < idx_0) {
        throw new Error("Syntax error: closing before opening bracket");
      }
      if (idx_1 < idx_0 + 2) {
        throw new Error("Syntax error: closing bracket too close to opening bracket");
      }
      if (/\s/.test(text[idx_0 + 1])) {
        throw new Error("Syntax error: whitespace not allowed here");
      }
      return [idx_0, idx_1];
    };
    //.........................................................................................................
    parse_mktscript_html = function(text) {
      var R, d, error, idx_0, idx_1, prv_idx, prv_idx_1, source, tags;
      R = [];
      prv_idx = 0;
      prv_idx_1 = -1;
      while (true) {
        try {
          //.....................................................................................................
          //.......................................................................................................
          [idx_0, idx_1] = find_next_tag(text, prv_idx);
        } catch (error1) {
          error = error1;
          if (!/Syntax error/.test(error.message)) {
            throw error;
          }
          source = text.slice(prv_idx);
          R.push(new_datom('~error', {
            message: `${error.message}: ${jr(source)}`,
            type: 'mkts-syntax-html',
            source: source
          }));
          return R;
        }
        //.....................................................................................................
        if (idx_0 > prv_idx_1 + 1) {
          R.push(new_datom('^text', {
            text: text.slice(prv_idx_1 + 1, idx_0)
          }));
        }
        if (idx_0 == null) {
          break;
        }
        tags = HTML.html_as_datoms(text.slice(idx_0, +idx_1 + 1 || 9e9));
        if (text[idx_1 - 1] === '/') {
          R.push(d = lets(tags[0], function(d) {
            return d.$key = '^' + d.$key.slice(1);
          }));
        } else {
          R.push(...tags);
        }
        prv_idx_1 = idx_1;
        prv_idx = idx_1 + 1;
      }
      //.......................................................................................................
      // debug '7776^', rpr { prv_idx, prv_idx_1, idx_0, idx_1, length: text.length, }
      if (prv_idx < text.length) {
        R.push(new_datom('^text', {
          text: text.slice(prv_idx_1 + 1)
        }));
      }
      return R;
    };
    //.........................................................................................................
    // find_next_tag = ( text, prv_idx = 0 ) ->
    //   return [ null, null, ]          if ( idx_0 = text.indexOf '<', prv_idx    ) < 0
    //   throw new Error "Syntax error"  if ( idx_1 = text.indexOf '>', idx_0 + 1  ) < 0
    //   return [ idx_0, idx_1, ]
    //.........................................................................................................
    probes_and_matchers = [
      [
        "line A<br/>line B",
        [
          {
            "text": "line A",
            "$key": "^text"
          },
          {
            "$key": "^br"
          },
          {
            "text": "line B",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "<p>|here and|<br>",
        [
          {
            "$key": "<p"
          },
          {
            "text": "|here and|",
            "$key": "^text"
          },
          {
            "$key": "<br"
          }
        ],
        null
      ],
      [
        "|foo |<p>|here and|<br>|there|",
        [
          {
            "text": "|foo |",
            "$key": "^text"
          },
          {
            "$key": "<p"
          },
          {
            "text": "|here and|",
            "$key": "^text"
          },
          {
            "$key": "<br"
          },
          {
            "text": "|there|",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "< >",
        [
          {
            "message": "Syntax error: whitespace not allowed here: \"< >\"",
            "type": "mkts-syntax-html",
            "source": "< >",
            "$key": "~error"
          }
        ],
        null
      ],
      [
        "< x >",
        [
          {
            "message": "Syntax error: whitespace not allowed here: \"< x >\"",
            "type": "mkts-syntax-html",
            "source": "< x >",
            "$key": "~error"
          }
        ],
        null
      ],
      [
        "<>",
        [
          {
            "message": "Syntax error: closing bracket too close to opening bracket: \"<>\"",
            "type": "mkts-syntax-html",
            "source": "<>",
            "$key": "~error"
          }
        ],
        null
      ],
      [
        "<",
        [
          {
            "message": "Syntax error: opening but no closing bracket: \"<\"",
            "type": "mkts-syntax-html",
            "source": "<",
            "$key": "~error"
          }
        ],
        null
      ],
      [
        "<tag",
        [
          {
            "message": "Syntax error: opening but no closing bracket: \"<tag\"",
            "type": "mkts-syntax-html",
            "source": "<tag",
            "$key": "~error"
          }
        ],
        null
      ],
      [
        "tag>",
        [
          {
            "message": "Syntax error: closing but no opening bracket: \"tag>\"",
            "type": "mkts-syntax-html",
            "source": "tag>",
            "$key": "~error"
          }
        ],
        null
      ],
      [
        ">",
        [
          {
            "message": "Syntax error: closing but no opening bracket: \">\"",
            "type": "mkts-syntax-html",
            "source": ">",
            "$key": "~error"
          }
        ],
        null
      ],
      [
        "<",
        [
          {
            "message": "Syntax error: opening but no closing bracket: \"<\"",
            "type": "mkts-syntax-html",
            "source": "<",
            "$key": "~error"
          }
        ],
        null
      ],
      [
        "x",
        [
          {
            "text": "x",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "&",
        [
          {
            "text": "&",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "&;",
        [
          {
            "text": "&;",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "&&",
        [
          {
            "text": "&&",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "max & moritz",
        [
          {
            "text": "max & moritz",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "&amp;",
        [
          {
            "text": "&amp;",
            "$key": "^text"
          }
        ],
        null
      ],
      [
        "<tag a='<'>",
        [
          {
            "a": "<",
            "$key": "<tag"
          }
        ],
        null
      ],
      [
        "if <math> a > b </math> then",
        [
          {
            "text": "if ",
            "$key": "^text"
          },
          {
            "$key": "<math"
          },
          {
            "message": "Syntax error: closing before opening bracket: \" a > b </math> then\"",
            "type": "mkts-syntax-html",
            "source": " a > b </math> then",
            "$key": "~error"
          }
        ],
        null
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var text;
          text = probe;
          return resolve(parse_mktscript_html(text));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["HTML.html_as_datoms (2)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [["<!DOCTYPE html>", "<!DOCTYPE html>", null], ["<!DOCTYPE obvious>", "<!DOCTYPE obvious>", null], ["<p contenteditable>", "<p contenteditable>", null], ["<img width=200>", "<img width=200>", null], ["<dang z=Z a=A>", "<dang a=A z=Z>", null], ["<foo/>", "<foo>|</foo>", null], ["<foo></foo>", "<foo>|</foo>", null], ["<p>here and<br>there", "<p>|here and|<br>|there", null], ["<p>here and<br>there</p>", "<p>|here and|<br>|there|</p>", null], ["<p>here and<br/>there</p>", "<p>|here and|<br>|</br>|there|</p>", null], ["just some plain text", "just some plain text", null], ["<p>one<p>two", "<p>|one|<p>|two", null]];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          var d;
          return resolve(((function() {
            var j, len1, ref, results;
            ref = HTML.html_as_datoms(probe);
            results = [];
            for (j = 0, len1 = ref.length; j < len1; j++) {
              d = ref[j];
              results.push(HTML.datom_as_html(d));
            }
            return results;
          })()).join('|'));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //###########################################################################################################
  if (module === require.main) {
    (() => { // await do =>
      // await @_demo()
      // test @
      help('ok');
      // test @[ "must quote attribute value" ]
      // test @[ "DATOM.HTML._as_attribute_literal" ]
      // test @[ "isa.intertext_html_tagname" ]
      // test @[ "HTML.datom_as_html (singular tags)" ]
      // test @[ "HTML.datom_as_html (closing tags)" ]
      // test @[ "HTML.datom_as_html (opening tags)" ]
      // test @[ "HTML.datom_as_html (texts)" ]
      // test @[ "HTML.datom_as_html (opening tags w/ $value)" ]
      // test @[ "HTML.datom_as_html (system tags)" ]
      // test @[ "HTML.datom_as_html (raw pseudo-tag)" ]
      // test @[ "HTML.datom_as_html (doctype)" ]
      // test @[ "HTML.html_as_datoms (1)" ]
      // test @[ "HTML.html_as_datoms (dubious 2)" ]
      return test(this["HTML.html_as_datoms (dubious w/ pre-processor)"]);
    })();
  }

}).call(this);
