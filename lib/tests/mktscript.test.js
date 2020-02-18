(function() {
  /*

  ====================================================================================
  compact names for MKTScript:

  `<div#c432.foo.bar>...</div>` => `<div id=c432 class='foo bar'>...</div>`
  `<p.noindent>...</p>` => `<p class=noindent>...</p>`

  positional arguments:
  `<columns:2>` => `<columns count=2/>` => `<columns count=2></columns>` ?=> `<mkts-columns count=2></mkts-columns>`

  NB Svelte uses capitalized names, allows self-closing tags(!): `<Mytag/>`

  */
  'use strict';
  var CND, DATOM, INTERTEXT, MKTS, alert, badge, debug, echo, help, info, isa, jr, lets, log, new_datom, rpr, select, test, type_of, types, urge, validate, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/TESTS/MKTSCRIPT';

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

  //...........................................................................................................
  test = require('guy-test');

  INTERTEXT = require('../..');

  ({MKTS} = INTERTEXT);

  //===========================================================================================================
  // TESTS
  //-----------------------------------------------------------------------------------------------------------
  this["MKTS.datoms_from_html"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
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
            "$key": "^br"
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
            "$key": "^br"
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
        "<tag>\n \n\t\n</p>",
        [
          {
            "$key": "<tag"
          },
          {
            "text": "\n \n\t\n",
            "$key": "^text"
          },
          {
            "$key": ">p"
          }
        ],
        null
      ],
      [
        "<tag a='<'>",
        [
          {
            "message": "Syntax error: additional opening bracket: \"<tag a='<'>\"",
            "type": "mkts-syntax-html",
            "source": "<tag a='<'>",
            "$key": "~error"
          }
        ],
        null
      ],
      [
        "<tag a='>'>",
        [
          {
            "text": ">",
            "$key": "^text"
          },
          {
            "message": "Syntax error: closing but no opening bracket: \"'>\"",
            "type": "mkts-syntax-html",
            "source": "'>",
            "$key": "~error"
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
          return resolve(MKTS.datoms_from_html(text));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["MKTS.datoms_from_html (compact syntax)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [
        // [ '<columns =2 =3>' ]
        "<div>",
        [
          {
            "$key": "<div"
          }
        ]
      ],
      [
        "<div#c432.foo.bar>",
        [
          {
            "$key": "<div",
            "id": "c432",
            "class": "foo bar"
          }
        ]
      ],
      [
        "<p.noindent>",
        [
          {
            "$key": "<p",
            "class": "noindent"
          }
        ]
      ]
    ];
    for (i = 0, len = probes_and_matchers.length; i < len; i++) {
      [probe, matcher, error] = probes_and_matchers[i];
      await T.perform(probe, matcher, error, function() {
        return new Promise(function(resolve, reject) {
          return resolve(MKTS.datoms_from_html(probe));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["MKTS.$datoms_from_html"] = function(T, done) {
    var $, $async, $drain, $show, $watch, SP, matcher, pipeline, probe;
    SP = require('steampipes');
    // SP                        = require '../../apps/steampipes'
    ({$, $async, $drain, $watch, $show} = SP.export());
    //.........................................................................................................
    probe = `<p>A <em>concise</em> introduction to the things discussed below.</p>`;
    matcher = [
      {
        "$key": "<p"
      },
      {
        "text": "A ",
        "$key": "^text"
      },
      {
        "$key": "<em"
      },
      {
        "text": "concise",
        "$key": "^text"
      },
      {
        "$key": ">em"
      },
      {
        "text": " introduction to the things discussed below.",
        "$key": "^text"
      },
      {
        "$key": ">p"
      }
    ];
    //.........................................................................................................
    pipeline = [];
    pipeline.push([Buffer.from(probe)]);
    pipeline.push(SP.$split());
    pipeline.push(MKTS.$datoms_from_html());
    pipeline.push($show());
    pipeline.push($drain((result) => {
      help(jr(result));
      T.eq(result, matcher);
      return done();
    }));
    SP.pull(...pipeline);
    //.........................................................................................................
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["MKTS.datoms_from_html (dubious)"] = async function(T, done) {
    var error, i, len, matcher, probe, probes_and_matchers;
    probes_and_matchers = [
      [
        /* TAINT these edge cases should be solved by an appropriate (MKTScript) pre-processor; NB that in
                 MKTScript stray pointy brackets in ordinary text (but not in `<code>` blocks) are forbidden and must
                 be escaped as entities wherever they appear in attribute values; these rules, however, do not
                 necessarily apply when parsing general MKTS sources. */
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
            "message": "Syntax error: closing before opening bracket: \" a > b </math> then\"",
            "type": "mkts-syntax-html",
            "source": " a > b </math> then",
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
            "message": "Syntax error: additional opening bracket: \"<tag a='<'>\"",
            "type": "mkts-syntax-html",
            "source": "<tag a='<'>",
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
          return resolve(MKTS.datoms_from_html(probe));
        });
      });
    }
    //.........................................................................................................
    done();
    return null;
  };

  //===========================================================================================================
  // DEMOS
  //-----------------------------------------------------------------------------------------------------------
  this["MKTS demo"] = function(T, done) {
    var d, datoms, i, len, ref, result, text;
    text = `<!DOCTYPE html>
<h1#s4451><strong>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>

<p#p227.noindent>However, the egg only got larger and larger, and <em>more and more human</em>:<br>

when she had come within a few yards of it, she saw that it had eyes and a nose and mouth; and when she
had come close to it, she saw clearly that it was <name ref=hd556>HUMPTY DUMPTY</name> himself. ‘It can’t
be anybody else!’ she said to herself.<br/>

‘I’m as certain of it, as if his name were written all over his face.’
`;
    ref = datoms = MKTS.datoms_from_html(text);
    for (i = 0, len = ref.length; i < len; i++) {
      d = ref[i];
      echo(jr(d));
    }
    echo('-'.repeat(108));
    echo(result = ((function() {
      var j, len1, results;
      results = [];
      for (j = 0, len1 = datoms.length; j < len1; j++) {
        d = datoms[j];
        results.push(MKTS.html_from_datoms(d));
      }
      return results;
    })()).join(''));
    // debug '^2228^', jr result
    T.eq(result, "<!DOCTYPE html>\n<h1 id=s4451><strong>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>\n\n<p class=noindent id=p227>However, the egg only got larger and larger, and <em>more and more human</em>:<br>\n\nwhen she had come within a few yards of it, she saw that it had eyes and a nose and mouth; and when she\nhad come close to it, she saw clearly that it was <name ref=hd556>HUMPTY DUMPTY</name> himself. ‘It can’t\nbe anybody else!’ she said to herself.<br>\n\n‘I’m as certain of it, as if his name were written all over his face.’\n");
    //.........................................................................................................
    done();
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this["MKTS demo (buffer)"] = function(T, done) {
    var buffer, d, datoms, i, len, ref, result, text;
    text = `<!DOCTYPE html>
<h1#c4443><strong.myclass>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>`;
    buffer = Buffer.from(text);
    ref = datoms = MKTS.datoms_from_html(buffer);
    // debug '^80009^', buffer
    // for d in datoms = MKTS.datoms_from_html buffer
    for (i = 0, len = ref.length; i < len; i++) {
      d = ref[i];
      echo(jr(d));
    }
    echo('-'.repeat(108));
    echo(result = ((function() {
      var j, len1, results;
      results = [];
      for (j = 0, len1 = datoms.length; j < len1; j++) {
        d = datoms[j];
        results.push(MKTS.html_from_datoms(d));
      }
      return results;
    })()).join(''));
    T.eq(result, "<!DOCTYPE html>\n<h1 id=c4443><strong class=myclass>CHAPTER VI.</strong> <name ref=hd553>Humpty Dumpty</h1>");
    //.........................................................................................................
    done();
    return null;
  };

  //###########################################################################################################
  if (module === require.main) {
    (async() => { // await do =>
      // await @_demo()
      return (await test(this));
    })();
  }

  // await test @[ "MKTS.datoms_from_html" ]
// await test @[ "MKTS.datoms_from_html (compact syntax)" ]
// await test @[ "MKTS.$datoms_from_html" ]
// await test @[ "MKTS.datoms_from_html (dubious)" ]
// await test @[ "MKTS demo" ]
// await test @[ "MKTS demo (buffer)" ]

}).call(this);
