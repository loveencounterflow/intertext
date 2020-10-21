(function() {
  'use strict';
  var CND, DATOM, MAIN, Multimix, _defaults, alert, badge, cast, debug, echo, help, info, isa, log, ref, ref1, rpr, type_of, types, urge, validate, warn, whisper,
    boundMethodCheck = function(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new Error('Bound instance method accessed before binding'); } },
    indexOf = [].indexOf;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/CUPOFHTML';

  log = CND.get_logger('plain', badge);

  info = CND.get_logger('info', badge);

  whisper = CND.get_logger('whisper', badge);

  alert = CND.get_logger('alert', badge);

  debug = CND.get_logger('debug', badge);

  warn = CND.get_logger('warn', badge);

  help = CND.get_logger('help', badge);

  urge = CND.get_logger('urge', badge);

  echo = CND.echo.bind(CND);

  //...........................................................................................................
  MAIN = this;

  DATOM = require('datom');

  Multimix = require('multimix');

  types = require('./types');

  ({isa, validate, cast, type_of} = types);

  //...........................................................................................................
  _defaults = {
    flatten: true,
    DATOM: null,
    newlines: true
  };

  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  this._Targeted_collection = class _Targeted_collection extends Multimix {
    constructor(target) {
      super();
      this._ = target;
    }

  };

  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  ref = this.Tags = class Tags extends this._Targeted_collection {
    constructor() {
      super(...arguments);
      this.address = this.address.bind(this);
      this.article = this.article.bind(this);
      this.aside = this.aside.bind(this);
      this.blockquote = this.blockquote.bind(this);
      this.dd = this.dd.bind(this);
      this.details = this.details.bind(this);
      this.dialog = this.dialog.bind(this);
      this.div = this.div.bind(this);
      this.dl = this.dl.bind(this);
      this.dt = this.dt.bind(this);
      this.fieldset = this.fieldset.bind(this);
      this.figcaption = this.figcaption.bind(this);
      this.figure = this.figure.bind(this);
      this.footer = this.footer.bind(this);
      this.form = this.form.bind(this);
      this.h1 = this.h1.bind(this);
      this.h2 = this.h2.bind(this);
      this.h3 = this.h3.bind(this);
      this.h4 = this.h4.bind(this);
      this.h5 = this.h5.bind(this);
      this.h6 = this.h6.bind(this);
      this.header = this.header.bind(this);
      this.hgroup = this.hgroup.bind(this);
      this.hr = this.hr.bind(this);
      this.li = this.li.bind(this);
      this.main = this.main.bind(this);
      this.nav = this.nav.bind(this);
      this.ol = this.ol.bind(this);
      this.p = this.p.bind(this);
      this.pre = this.pre.bind(this);
      this.section = this.section.bind(this);
      this.table = this.table.bind(this);
      this.ul = this.ul.bind(this);
      //.........................................................................................................
      this.a = this.a.bind(this);
      this.abbr = this.abbr.bind(this);
      this.acronym = this.acronym.bind(this);
      this.applet = this.applet.bind(this);
      this.area = this.area.bind(this);
      this.audio = this.audio.bind(this);
      this.b = this.b.bind(this);
      this.base = this.base.bind(this);
      this.basefont = this.basefont.bind(this);
      this.bdi = this.bdi.bind(this);
      this.bdo = this.bdo.bind(this);
      this.big = this.big.bind(this);
      this.body = this.body.bind(this);
      this.br = this.br.bind(this);
      this.button = this.button.bind(this);
      this.canvas = this.canvas.bind(this);
      this.caption = this.caption.bind(this);
      this.center = this.center.bind(this);
      this.cite = this.cite.bind(this);
      this.code = this.code.bind(this);
      this.col = this.col.bind(this);
      this.colgroup = this.colgroup.bind(this);
      this.data = this.data.bind(this);
      this.datalist = this.datalist.bind(this);
      this.del = this.del.bind(this);
      this.dfn = this.dfn.bind(this);
      this.em = this.em.bind(this);
      this.embed = this.embed.bind(this);
      this.font = this.font.bind(this);
      this.frame = this.frame.bind(this);
      this.frameset = this.frameset.bind(this);
      this.head = this.head.bind(this);
      this.html = this.html.bind(this);
      this.i = this.i.bind(this);
      this.iframe = this.iframe.bind(this);
      this.img = this.img.bind(this);
      this.input = this.input.bind(this);
      this.ins = this.ins.bind(this);
      this.kbd = this.kbd.bind(this);
      this.keygen = this.keygen.bind(this);
      this.label = this.label.bind(this);
      this.legend = this.legend.bind(this);
      this.link = this.link.bind(this);
      this.map = this.map.bind(this);
      this.mark = this.mark.bind(this);
      this.menu = this.menu.bind(this);
      this.menuitem = this.menuitem.bind(this);
      this.meta = this.meta.bind(this);
      this.meter = this.meter.bind(this);
      this.noscript = this.noscript.bind(this);
      this.object = this.object.bind(this);
      this.optgroup = this.optgroup.bind(this);
      this.option = this.option.bind(this);
      this.output = this.output.bind(this);
      this.param = this.param.bind(this);
      this.progress = this.progress.bind(this);
      this.q = this.q.bind(this);
      this.rb = this.rb.bind(this);
      this.rp = this.rp.bind(this);
      this.rt = this.rt.bind(this);
      this.rtc = this.rtc.bind(this);
      this.ruby = this.ruby.bind(this);
      this.s = this.s.bind(this);
      this.samp = this.samp.bind(this);
      this.script = this.script.bind(this);
      this.select = this.select.bind(this);
      this.small = this.small.bind(this);
      this.source = this.source.bind(this);
      this.span = this.span.bind(this);
      this.strike = this.strike.bind(this);
      this.strong = this.strong.bind(this);
      this.style = this.style.bind(this);
      this.sub = this.sub.bind(this);
      this.summary = this.summary.bind(this);
      this.sup = this.sup.bind(this);
      this.tbody = this.tbody.bind(this);
      this.td = this.td.bind(this);
      this.template = this.template.bind(this);
      this.textarea = this.textarea.bind(this);
      this.tfoot = this.tfoot.bind(this);
      this.th = this.th.bind(this);
      this.thead = this.thead.bind(this);
      this.time = this.time.bind(this);
      this.title = this.title.bind(this);
      this.tr = this.tr.bind(this);
      this.track = this.track.bind(this);
      this.u = this.u.bind(this);
      this.var = this.var.bind(this);
      this.video = this.video.bind(this);
      this.wbr = this.wbr.bind(this);
    }

    address(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('address', {
        $blk: true
      }, ...P);
    }

    article(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('article', {
        $blk: true
      }, ...P);
    }

    aside(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('aside', {
        $blk: true
      }, ...P);
    }

    blockquote(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('blockquote', {
        $blk: true
      }, ...P);
    }

    dd(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('dd', {
        $blk: true
      }, ...P);
    }

    details(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('details', {
        $blk: true
      }, ...P);
    }

    dialog(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('dialog', {
        $blk: true
      }, ...P);
    }

    div(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('div', {
        $blk: true
      }, ...P);
    }

    dl(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('dl', {
        $blk: true
      }, ...P);
    }

    dt(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('dt', {
        $blk: true
      }, ...P);
    }

    fieldset(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('fieldset', {
        $blk: true
      }, ...P);
    }

    figcaption(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('figcaption', {
        $blk: true
      }, ...P);
    }

    figure(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('figure', {
        $blk: true
      }, ...P);
    }

    footer(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('footer', {
        $blk: true
      }, ...P);
    }

    form(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('form', {
        $blk: true
      }, ...P);
    }

    h1(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('h1', {
        $blk: true
      }, ...P);
    }

    h2(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('h2', {
        $blk: true
      }, ...P);
    }

    h3(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('h3', {
        $blk: true
      }, ...P);
    }

    h4(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('h4', {
        $blk: true
      }, ...P);
    }

    h5(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('h5', {
        $blk: true
      }, ...P);
    }

    h6(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('h6', {
        $blk: true
      }, ...P);
    }

    header(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('header', {
        $blk: true
      }, ...P);
    }

    hgroup(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('hgroup', {
        $blk: true
      }, ...P);
    }

    hr(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('hr', {
        $blk: true
      }, ...P);
    }

    li(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('li', {
        $blk: true
      }, ...P);
    }

    main(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('main', {
        $blk: true
      }, ...P);
    }

    nav(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('nav', {
        $blk: true
      }, ...P);
    }

    ol(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('ol', {
        $blk: true
      }, ...P);
    }

    p(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('p', {
        $blk: true
      }, ...P);
    }

    pre(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('pre', {
        $blk: true
      }, ...P);
    }

    section(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('section', {
        $blk: true
      }, ...P);
    }

    table(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('table', {
        $blk: true
      }, ...P);
    }

    ul(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('ul', {
        $blk: true
      }, ...P);
    }

    a(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('a', ...P);
    }

    abbr(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('abbr', ...P);
    }

    acronym(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('acronym', ...P);
    }

    applet(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('applet', ...P);
    }

    area(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('area', ...P);
    }

    audio(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('audio', ...P);
    }

    b(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('b', ...P);
    }

    base(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('base', ...P);
    }

    basefont(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('basefont', ...P);
    }

    bdi(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('bdi', ...P);
    }

    bdo(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('bdo', ...P);
    }

    big(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('big', ...P);
    }

    body(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('body', ...P);
    }

    br(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('br', ...P);
    }

    button(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('button', ...P);
    }

    canvas(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('canvas', ...P);
    }

    caption(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('caption', ...P);
    }

    center(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('center', ...P);
    }

    cite(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('cite', ...P);
    }

    code(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('code', ...P);
    }

    col(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('col', ...P);
    }

    colgroup(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('colgroup', ...P);
    }

    data(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('data', ...P);
    }

    datalist(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('datalist', ...P);
    }

    del(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('del', ...P);
    }

    dfn(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('dfn', ...P);
    }

    em(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('em', ...P);
    }

    embed(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('embed', ...P);
    }

    font(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('font', ...P);
    }

    frame(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('frame', ...P);
    }

    frameset(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('frameset', ...P);
    }

    head(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('head', ...P);
    }

    html(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('html', ...P);
    }

    i(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('i', ...P);
    }

    iframe(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('iframe', ...P);
    }

    img(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('img', ...P);
    }

    input(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('input', ...P);
    }

    ins(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('ins', ...P);
    }

    kbd(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('kbd', ...P);
    }

    keygen(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('keygen', ...P);
    }

    label(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('label', ...P);
    }

    legend(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('legend', ...P);
    }

    link(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('link', ...P);
    }

    map(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('map', ...P);
    }

    mark(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('mark', ...P);
    }

    menu(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('menu', ...P);
    }

    menuitem(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('menuitem', ...P);
    }

    meta(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('meta', ...P);
    }

    meter(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('meter', ...P);
    }

    noscript(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('noscript', ...P);
    }

    object(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('object', ...P);
    }

    optgroup(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('optgroup', ...P);
    }

    option(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('option', ...P);
    }

    output(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('output', ...P);
    }

    param(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('param', ...P);
    }

    progress(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('progress', ...P);
    }

    q(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('q', ...P);
    }

    rb(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('rb', ...P);
    }

    rp(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('rp', ...P);
    }

    rt(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('rt', ...P);
    }

    rtc(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('rtc', ...P);
    }

    ruby(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('ruby', ...P);
    }

    s(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('s', ...P);
    }

    samp(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('samp', ...P);
    }

    script(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('script', ...P);
    }

    select(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('select', ...P);
    }

    small(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('small', ...P);
    }

    source(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('source', ...P);
    }

    span(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('span', ...P);
    }

    strike(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('strike', ...P);
    }

    strong(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('strong', ...P);
    }

    style(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('style', ...P);
    }

    sub(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('sub', ...P);
    }

    summary(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('summary', ...P);
    }

    sup(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('sup', ...P);
    }

    tbody(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('tbody', ...P);
    }

    td(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('td', ...P);
    }

    template(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('template', ...P);
    }

    textarea(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('textarea', ...P);
    }

    tfoot(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('tfoot', ...P);
    }

    th(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('th', ...P);
    }

    thead(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('thead', ...P);
    }

    time(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('time', ...P);
    }

    title(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('title', ...P);
    }

    tr(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('tr', ...P);
    }

    track(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('track', ...P);
    }

    u(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('u', ...P);
    }

    var(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('var', ...P);
    }

    video(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('video', ...P);
    }

    wbr(...P) {
      boundMethodCheck(this, ref);
      return this._.tag('wbr', ...P);
    }

  };

  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  ref1 = this.Specials = class Specials extends this._Targeted_collection {
    constructor() {
      super(...arguments);
      this.doctype = this.doctype.bind(this);
      // img:          ( P... ) => XXXX @_.tag '!–', P...

      //---------------------------------------------------------------------------------------------------------
      this.raw = this.raw.bind(this);
      this.text = this.text.bind(this);
      this.comment = this.comment.bind(this);
      this.newline = this.newline.bind(this);
      //---------------------------------------------------------------------------------------------------------
      this._raw = this._raw.bind(this);
    }

    doctype(type = 'html') {
      boundMethodCheck(this, ref1);
      return this._._cram(this._raw('doctype', type));
    }

    raw(...P) {
      boundMethodCheck(this, ref1);
      validate.list_of('text', P);
      return this._raw('raw', ...P);
    }

    text(...P) {
      boundMethodCheck(this, ref1);
      validate.list_of('text', P);
      return this._raw('text', ...P);
    }

    comment(...P) {
      boundMethodCheck(this, ref1);
      validate.list_of('text', P);
      return this._raw('raw', `<!-- ${P.join()} -->`);
    }

    newline(...P) {
      boundMethodCheck(this, ref1);
      validate.list_of('text', P);
      return this._raw('raw', "\n");
    }

    _raw(name, ...P) {
      boundMethodCheck(this, ref1);
      return this._._cram(this._.DATOM.new_datom(`^${name}`, {
        text: P.join(''),
        $: 'ð1'
      }));
    }

    //---------------------------------------------------------------------------------------------------------
    link_css(href) {
      /* `<link rel=stylesheet href="../reset.css"/>` */
      var arity;
      if ((arity = arguments.length) !== 1) {
        throw new Error(`^intertext/cupofhtml/link_css@2935^ expected 1 argument, got ${arity}`);
      }
      validate.nonempty_text(href);
      return this._._cram(this._.DATOM.new_datom('^link', {
        rel: 'stylesheet',
        href
      }));
    }

    //---------------------------------------------------------------------------------------------------------
    script(x) {
      var arity, type;
      if ((arity = arguments.length) !== 1) {
        throw new Error(`^intertext//cupofhtml/link_js@3502^ expected 1 argument, got ${arity}`);
      }
      switch (type = type_of(x)) {
        case 'text':
          return this._script_src(x);
        case 'function':
          return this._script_literal(x);
      }
      throw new Error(`^intertext/cupofhtml/script@4069^ expected a text or a function, got a ${type}`);
    }

    //---------------------------------------------------------------------------------------------------------
    _script_src(src) {
      /* `<script type="text/javascript" src="../jquery-3.4.1.js">` */
      validate.nonempty_text(src);
      return this._.cram('script', {src});
    }

    //---------------------------------------------------------------------------------------------------------
    _script_literal(f) {
      /* `<script type="text/javascript"> var a, b; ...;</script>` */
      return this._.cram('script', () => {
        return this.raw(`(${f.toString()})();`);
      });
    }

  };

  //###########################################################################################################
  //###########################################################################################################
  //###########################################################################################################
  //###########################################################################################################
  //###########################################################################################################
  //###########################################################################################################

  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  this._escape_text = function(x) {
    var R;
    R = x;
    R = R.replace(/&/g, '&amp;');
    R = R.replace(/</g, '&lt;');
    R = R.replace(/>/g, '&gt;');
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this._as_attribute_literal = function(x) {
    var R, must_quote;
    R = isa.text(x) ? x : JSON.stringify(x);
    must_quote = !isa._intertext_html_naked_attribute_text(R);
    R = this._escape_text(R);
    R = R.replace(/'/g, '&#39;');
    R = R.replace(/\n/g, '&#10;');
    if (must_quote) {
      R = "'" + R + "'";
    }
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.$html_from_datoms = function() {
    var $;
    ({$} = (require('steampipes')).export());
    return $((d, send) => {
      var ds, i, len;
      ds = (isa.list(d)) ? d : [d];
      for (i = 0, len = ds.length; i < len; i++) {
        d = ds[i];
        send(this._html_from_datom({
          newlines: false
        }, d));
      }
      return null;
    });
  };

  //-----------------------------------------------------------------------------------------------------------
  this._html_from_datom = function(settings, d) {
    var atxt, bnl, i, is_block_tag, is_empty_tag, key, len, ref2, ref3, ref4, ref5, ref6, sigil, slash, src, tagname, value, x_key, x_sys_key, xnl;
    /* TAINT should not use `$key` for the tag name, rather, use `$key` to distinguish tags, texts */
    /* TAINT make compatible with Paragate HTMLish parser */
    if (!DATOM.types.isa.datom_datom(d)) {
      if (!isa.text(d)) {
        throw new Error(`^intertext/cupofhtml/_html_from_datom@4786^ unable to convert a ${type_of(d)} to HTML; got ${rpr(d)}`);
      }
      d = {
        $key: '^text',
        text: d
      };
    }
    //.........................................................................................................
    atxt = '';
    sigil = d.$key[0];
    tagname = d.$key.slice(1);
    is_empty_tag = isa._intertext_html_empty_element_tagname(tagname);
    x_key = null;
    is_block_tag = (ref2 = d.$blk) != null ? ref2 : false;
    if (settings.newlines) {
      bnl = is_block_tag ? '\n\n' : '';
      xnl = '\n';
    } else {
      bnl = '';
      xnl = '';
    }
    //.........................................................................................................
    /* TAINT simplistic solution; namespace might already be taken? */
    if (indexOf.call('[~]', sigil) >= 0) {
      switch (sigil) {
        case '[':
          sigil = '<';
          break;
        case '~':
          sigil = '^';
          break;
        case ']':
          sigil = '>';
      }
      [x_key, tagname] = [tagname, 'x-sys'];
    }
    if ((sigil === '^') && (tagname === 'text')) {
      //.........................................................................................................
      return this._escape_text((ref3 = d.text) != null ? ref3 : '');
    }
    if ((sigil === '^') && (tagname === 'raw')) {
      return (ref4 = d.text) != null ? ref4 : '';
    }
    if ((sigil === '^') && (tagname === 'doctype')) {
      return `<!DOCTYPE ${(ref5 = d.$value) != null ? ref5 : 'html'}>${xnl}`;
    }
    if (sigil === '>') {
      return `</${tagname}>${bnl}`;
    }
    //.........................................................................................................
    /* NOTE sorting atxt by keys to make result predictable: */
    if (isa.object(d.$value)) {
      src = d.$value;
    } else {
      src = d;
    }
    if (x_key != null) {
      atxt += ` x-key=${this._as_attribute_literal(x_key)}`;
    }
    ref6 = (Object.keys(src)).sort();
    for (i = 0, len = ref6.length; i < len; i++) {
      key = ref6[i];
      if (key.startsWith('$')) {
        continue;
      }
      if ((value = src[key]) === true) {
        atxt += ` ${key}`;
      } else {
        atxt += ` ${key}=${this._as_attribute_literal(value)}`;
      }
    }
    //.........................................................................................................
    /* TAINT make self-closing elements configurable, depend on HTML5 type */
    slash = (sigil === '<') || is_empty_tag ? '' : `</${tagname}>${bnl}`;
    x_sys_key = x_key != null ? `<x-sys-key>${x_key}</x-sys-key>` : '';
    if (atxt === '') {
      return `<${tagname}>${slash}${x_sys_key}`;
    }
    return `<${tagname}${atxt}>${x_sys_key}${slash}`;
  };

  //###########################################################################################################
  //###########################################################################################################
  //###########################################################################################################
  //###########################################################################################################
  //###########################################################################################################
  //###########################################################################################################

  //===========================================================================================================

  //-----------------------------------------------------------------------------------------------------------
  this.Cupofhtml = (function() {
    class Cupofhtml extends DATOM.Cupofdatom {
      //---------------------------------------------------------------------------------------------------------
      constructor(settings = null) {
        super({..._defaults, ...settings});
        this.H = new this.H(this);
        this.S = new this.S(this);
        return this;
      }

      //---------------------------------------------------------------------------------------------------------
      expand() {
        return this.last_expansion = super.expand();
      }

      //---------------------------------------------------------------------------------------------------------
      new_tag(name, attributes) {
        var f;
        if (attributes != null) {
          f = function(...P) {
            return this._.tag(name, attributes, ...P);
          };
        } else {
          f = function(...P) {
            return this._.tag(name, ...P);
          };
        }
        this.H[name] = f.bind(this.H);
        return null;
      }

      //---------------------------------------------------------------------------------------------------------
      tag(name, ...content) {
        if (name !== null) {
          validate.intertext_html_tagname(name);
        }
        return this.cram(name, ...content);
      }

      //---------------------------------------------------------------------------------------------------------
      as_html() {
        var d;
        return ((function() {
          var i, len, ref2, results;
          ref2 = this.expand();
          results = [];
          for (i = 0, len = ref2.length; i < len; i++) {
            d = ref2[i];
            results.push(MAIN._html_from_datom(this.settings, d));
          }
          return results;
        }).call(this)).join('');
      }

    };

    // @include CUPOFHTML, { overwrite: false, }
    // @extend MAIN, { overwrite: false, }
    Cupofhtml.prototype._defaults = _defaults;

    Cupofhtml.prototype.last_expansion = null;

    Cupofhtml.prototype.H = MAIN.Tags;

    Cupofhtml.prototype.S = MAIN.Specials;

    return Cupofhtml;

  }).call(this);

}).call(this);

//# sourceMappingURL=cupofhtml.js.map