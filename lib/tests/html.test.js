(function() {
  'use strict';
  var CND, DATOM, HTML, alert, badge, debug, echo, help, info, isa, jr, log, new_datom, rpr, select, test, type_of, types, urge, validate, warn, whisper;

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

  // lets
  ({new_datom, select} = DATOM.export());

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
      return test(this["HTML.html_as_datoms (1)"]);
    })();
  }

}).call(this);
