(function() {
  'use strict';
  var CND, CRYPTO, assign, badge, convert_color, debug, declare, echo, help, info, isa, jr, rpr, size_of, type_of, types, urge, validate, warn, whisper,
    modulo = function(a, b) { return (+a % (b = +b) + b) % b; };

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/COLORS';

  debug = CND.get_logger('debug', badge);

  warn = CND.get_logger('warn', badge);

  info = CND.get_logger('info', badge);

  urge = CND.get_logger('urge', badge);

  help = CND.get_logger('help', badge);

  whisper = CND.get_logger('whisper', badge);

  echo = CND.echo.bind(CND);

  ({jr, assign} = CND);

  //...........................................................................................................
  types = require('./types');

  ({isa, validate, declare, size_of, type_of} = types);

  convert_color = require('color-convert');

  // X                         = require 'cnd/lib/TRM-VT100-ANALYZER'
  CRYPTO = require('crypto');

  //-----------------------------------------------------------------------------------------------------------
  /* thx to https://css-tricks.com/snippets/css/named-colors-and-hex-equivalents/ */
  this.hex_by_names = {
    AliceBlue: '#F0F8FF',
    AntiqueWhite: '#FAEBD7',
    Aqua: '#00FFFF',
    Aquamarine: '#7FFFD4',
    Azure: '#F0FFFF',
    Beige: '#F5F5DC',
    Bisque: '#FFE4C4',
    Black: '#000000',
    BlanchedAlmond: '#FFEBCD',
    Blue: '#0000FF',
    BlueViolet: '#8A2BE2',
    Brown: '#A52A2A',
    BurlyWood: '#DEB887',
    CadetBlue: '#5F9EA0',
    Chartreuse: '#7FFF00',
    Chocolate: '#D2691E',
    Coral: '#FF7F50',
    CornflowerBlue: '#6495ED',
    Cornsilk: '#FFF8DC',
    Crimson: '#DC143C',
    Cyan: '#00FFFF',
    DarkBlue: '#00008B',
    DarkCyan: '#008B8B',
    DarkGoldenRod: '#B8860B',
    DarkGrey: '#A9A9A9',
    DarkGreen: '#006400',
    DarkKhaki: '#BDB76B',
    DarkMagenta: '#8B008B',
    DarkOliveGreen: '#556B2F',
    Darkorange: '#FF8C00',
    DarkOrchid: '#9932CC',
    DarkRed: '#8B0000',
    DarkSalmon: '#E9967A',
    DarkSeaGreen: '#8FBC8F',
    DarkSlateBlue: '#483D8B',
    DarkSlateGrey: '#2F4F4F',
    DarkTurquoise: '#00CED1',
    DarkViolet: '#9400D3',
    DeepPink: '#FF1493',
    DeepSkyBlue: '#00BFFF',
    DimGrey: '#696969',
    DodgerBlue: '#1E90FF',
    FireBrick: '#B22222',
    FloralWhite: '#FFFAF0',
    ForestGreen: '#228B22',
    Fuchsia: '#FF00FF',
    Gainsboro: '#DCDCDC',
    GhostWhite: '#F8F8FF',
    Gold: '#FFD700',
    GoldenRod: '#DAA520',
    Grey: '#808080',
    Green: '#008000',
    GreenYellow: '#ADFF2F',
    HoneyDew: '#F0FFF0',
    HotPink: '#FF69B4',
    IndianRed: '#CD5C5C',
    Indigo: '#4B0082',
    Ivory: '#FFFFF0',
    Khaki: '#F0E68C',
    Lavender: '#E6E6FA',
    LavenderBlush: '#FFF0F5',
    LawnGreen: '#7CFC00',
    LemonChiffon: '#FFFACD',
    LightBlue: '#ADD8E6',
    LightCoral: '#F08080',
    LightCyan: '#E0FFFF',
    LightGoldenRodYellow: '#FAFAD2',
    LightGrey: '#D3D3D3',
    LightGreen: '#90EE90',
    LightPink: '#FFB6C1',
    LightSalmon: '#FFA07A',
    LightSeaGreen: '#20B2AA',
    LightSkyBlue: '#87CEFA',
    LightSlateGrey: '#778899',
    LightSteelBlue: '#B0C4DE',
    LightYellow: '#FFFFE0',
    Lime: '#00FF00',
    LimeGreen: '#32CD32',
    Linen: '#FAF0E6',
    Magenta: '#FF00FF',
    Maroon: '#800000',
    MediumAquaMarine: '#66CDAA',
    MediumBlue: '#0000CD',
    MediumOrchid: '#BA55D3',
    MediumPurple: '#9370D8',
    MediumSeaGreen: '#3CB371',
    MediumSlateBlue: '#7B68EE',
    MediumSpringGreen: '#00FA9A',
    MediumTurquoise: '#48D1CC',
    MediumVioletRed: '#C71585',
    MidnightBlue: '#191970',
    MintCream: '#F5FFFA',
    MistyRose: '#FFE4E1',
    Moccasin: '#FFE4B5',
    NavajoWhite: '#FFDEAD',
    Navy: '#000080',
    OldLace: '#FDF5E6',
    Olive: '#808000',
    OliveDrab: '#6B8E23',
    Orange: '#FFA500',
    OrangeRed: '#FF4500',
    Orchid: '#DA70D6',
    PaleGoldenRod: '#EEE8AA',
    PaleGreen: '#98FB98',
    PaleTurquoise: '#AFEEEE',
    PaleVioletRed: '#D87093',
    PapayaWhip: '#FFEFD5',
    PeachPuff: '#FFDAB9',
    Peru: '#CD853F',
    Pink: '#FFC0CB',
    Plum: '#DDA0DD',
    PowderBlue: '#B0E0E6',
    Purple: '#800080',
    Red: '#FF0000',
    RosyBrown: '#BC8F8F',
    RoyalBlue: '#4169E1',
    SaddleBrown: '#8B4513',
    Salmon: '#FA8072',
    SandyBrown: '#F4A460',
    SeaGreen: '#2E8B57',
    SeaShell: '#FFF5EE',
    Sienna: '#A0522D',
    Silver: '#C0C0C0',
    SkyBlue: '#87CEEB',
    SlateBlue: '#6A5ACD',
    SlateGrey: '#708090',
    Snow: '#FFFAFA',
    SpringGreen: '#00FF7F',
    SteelBlue: '#4682B4',
    Tan: '#D2B48C',
    Teal: '#008080',
    Thistle: '#D8BFD8',
    Tomato: '#FF6347',
    Turquoise: '#40E0D0',
    Violet: '#EE82EE',
    Wheat: '#F5DEB3',
    White: '#FFFFFF',
    WhiteSmoke: '#F5F5F5',
    Yellow: '#FFFF00',
    YellowGreen: '#9ACD32'
  };

  //-----------------------------------------------------------------------------------------------------------
  this.name_selection = ['Aqua', 'Aquamarine', 'Bisque', 'Blue', 'BlueViolet', 'Brown', 'BurlyWood', 'CadetBlue', 'Chartreuse', 'Chocolate', 'Coral', 'CornflowerBlue', 'Crimson', 'Cyan', 'DarkBlue', 'DarkCyan', 'DarkGoldenRod', 'DarkGrey', 'DarkGreen', 'DarkKhaki', 'DarkMagenta', 'DarkOliveGreen', 'Darkorange', 'DarkOrchid', 'DarkRed', 'DarkSalmon', 'DarkSeaGreen', 'DarkSlateBlue', 'DarkSlateGrey', 'DarkTurquoise', 'DarkViolet', 'DeepPink', 'DeepSkyBlue', 'DodgerBlue', 'FireBrick', 'ForestGreen', 'Fuchsia', 'Gold', 'GoldenRod', 'Green', 'GreenYellow', 'HotPink', 'IndianRed', 'Indigo', 'Khaki', 'LawnGreen', 'LightBlue', 'LightCoral', 'LightCyan', 'LightGreen', 'LightPink', 'LightSalmon', 'LightSeaGreen', 'LightSkyBlue', 'LightSlateGrey', 'LightSteelBlue', 'LightYellow', 'Lime', 'LimeGreen', 'Magenta', 'Maroon', 'MediumAquaMarine', 'MediumBlue', 'MediumOrchid', 'MediumPurple', 'MediumSeaGreen', 'MediumSlateBlue', 'MediumSpringGreen', 'MediumTurquoise', 'MediumVioletRed', 'MidnightBlue', 'Navy', 'Olive', 'OliveDrab', 'Orange', 'OrangeRed', 'Orchid', 'PaleGoldenRod', 'PaleGreen', 'PaleTurquoise', 'PaleVioletRed', 'PapayaWhip', 'PeachPuff', 'Peru', 'Pink', 'Plum', 'PowderBlue', 'Purple', 'Red', 'RosyBrown', 'RoyalBlue', 'SaddleBrown', 'Salmon', 'SandyBrown', 'SeaGreen', 'SeaShell', 'Sienna', 'Silver', 'SkyBlue', 'SlateBlue', 'SlateGrey', 'SpringGreen', 'SteelBlue', 'Tan', 'Teal', 'Thistle', 'Tomato', 'Turquoise', 'Violet', 'Wheat', 'White', 'Yellow', 'YellowGreen'];

  //-----------------------------------------------------------------------------------------------------------
  declare('hexcolor', {
    tests: {
      "x is a text": function(x) {
        return this.isa.text(x);
      },
      "x matches hex color pattern": function(x) {
        return this.isa.true((x.match(/^#[0-9a-fA-F]{6}$/)) != null);
      }
    }
  });

  //-----------------------------------------------------------------------------------------------------------
  this.hexcolor_from_name = function(name) {
    var R;
    validate.nonempty_text(name);
    if ((R = this.hex_by_names[name]) == null) {
      throw new Error(`µ33420 unknown color name ${rpr(name)}`);
    }
    return R;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.rgb_from_hexcolor = function(hexcolor) {
    validate.hexcolor(hexcolor);
    return [parseInt(hexcolor.slice(1, 3), 16), parseInt(hexcolor.slice(3, 5), 16), parseInt(hexcolor.slice(5, 7), 16)];
  };

  //-----------------------------------------------------------------------------------------------------------
  this.rgb_from_name = function(name) {
    return this.rgb_from_hexcolor(this.hexcolor_from_name(name));
  };

  //-----------------------------------------------------------------------------------------------------------
  this.ansi256_code_from_name = function(name) {
    var code;
    code = convert_color.rgb.ansi256(this.rgb_from_name(name));
    return `\x1b[38;05;${code}m`;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.ansi24bit_code_from_rgb = function(rgb, background = false) {
    var b, fb, g, r;
    [r, g, b] = rgb;
    fb = background ? 48 : 38;
    return `\x1b[${fb};2;${r};${g};${b}m`;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.ansi24bit_code_from_lch = function(lch, background = false) {
    return this.ansi24bit_code_from_rgb(convert_color.lch.rgb(lch), background);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.ansi24bit_code_from_name = function(name, background = false) {
    return this.ansi24bit_code_from_rgb(this.rgb_from_name(name), background);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.numerical_sha1_from_text = function(text) {
    var hash;
    hash = CRYPTO.createHash('sha1');
    hash.update(text);
    return parseInt((hash.digest('hex')).slice(0, 9), 16);
  };

  //-----------------------------------------------------------------------------------------------------------
  this.color_name_from_text = function(text) {
    var n, sha1;
    n = this.name_selection.length;
    sha1 = this.numerical_sha1_from_text(text);
    return this.name_selection[modulo(sha1, n)];
  };

  //-----------------------------------------------------------------------------------------------------------
  this.ansi_code_from_text = function(text) {
    return this.ansi256_code_from_name(this.color_name_from_text(text));
  };

  //-----------------------------------------------------------------------------------------------------------
  this.demo_1 = function() {
    var c, i, j, len, n, name, ref;
    debug(this.hexcolor_from_name('Azure'));
    debug(this.rgb_from_name('Azure'));
    debug(this.ansi256_code_from_name('Azure'));
    ref = this.name_selection;
    // debug X.get_css_source()
    // debug convert_color.rgb.ansi16 255, 0, 0
    // for name of @hex_by_names
    for (i = 0, len = ref.length; i < len; i++) {
      name = ref[i];
      c = function(x) {
        return x;
      };
      c = CND.reverse;
      debug(c((this.ansi256_code_from_name(name)) + (`  ${name}  `.padEnd(30))));
    }
    for (n = j = 1; j <= 3; n = ++j) {
      debug(CND.reverse((this.ansi_code_from_text(`x${n}`)) + `  ${n}  `));
    }
    return null;
  };

  //-----------------------------------------------------------------------------------------------------------
  this.demo_truecolor = function() {
    var c, name;
// debug @hexcolor_from_name 'Azure'
// debug @ansi24bit_code_from_name 'Azure'
    for (name in this.hex_by_names) {
      // c = ( x ) -> x
      c = CND.reverse;
      debug(c((this.ansi24bit_code_from_name(name)) + `  ${name}  `));
    }
    return null;
  };

  this.show_gradient = function(cold_lch, hot_lch) {
    return this._show_gradient(cold_lch, hot_lch);
  };

  // cold_lch[ 2 ] += 360
  // @_show_gradient cold_lch, hot_lch
  this._show_gradient = function(cold_lch, hot_lch) {
    var C, H, L, _, delta_C, delta_H, delta_L, i, ref, reset, scale, step_count;
    reset = "\x1b[0m";
    step_count = 13;
    delta_L = (hot_lch[0] - cold_lch[0]) / (step_count - 1);
    delta_C = (hot_lch[1] - cold_lch[1]) / (step_count - 1);
    delta_H = (hot_lch[2] - cold_lch[2]) / (step_count - 1);
    [L, C, H] = cold_lch;
    scale = '';
    for (_ = i = 1, ref = step_count; (1 <= ref ? i <= ref : i >= ref); _ = 1 <= ref ? ++i : --i) {
      scale += (this.ansi24bit_code_from_lch([L, C, H], true)) + ' ';
      L += delta_L;
      C += delta_C;
      H += delta_H;
    }
    return echo(scale + reset);
  };

  // L: 0 .. 100
  // H: 0 .. 132
  // C: 0 .. 360 (wraparound)
  this.show_gradient([57, 98, 271], [43, 72, 17]);

  this.show_gradient([57, 98, 271], [43, 72, 360]);

  this.show_gradient([57, 98, 271], [43, 72, 380]);

  this.show_gradient([153, 105, 200], [53, 105, 60]);

  this.show_gradient([153, 105, 200], [53, 105, 20]);

  this.show_gradient([90, 105, 200], [53, 105, 30]);

  help("see https://github.com/d3/d3-color");

  help("see https://observablehq.com/@d3/achromatic-interpolation?collection=@d3/d3-color");

  help("see https://observablehq.com/@d3/working-with-color?collection=@d3/d3-color");

  help("see https://observablehq.com/@d3/sequential-scales?collection=@d3/d3-color");

  return null;

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      var BAR, border, color, color_1, color_2, demo_lch_gamut, i, k, n, puffer, reset, text;
      // @demo_1()
      // @demo_truecolor()
      debug(type_of(this.ansi24bit_code_from_name));
      debug((function() {
        var results;
        results = [];
        for (k in this) {
          if (/24/.test(k)) {
            results.push(k);
          }
        }
        return results;
      }).call(this));
      debug(rpr(this.ansi24bit_code_from_rgb([100, 150, 0], false)));
      debug(rpr(this.ansi24bit_code_from_rgb([100, 150, 0], true)));
      color = '';
      /* NOTE CFN = Color From Name */
      this.cfn = function(fg, bg = 'Black') {
        return (this.ansi24bit_code_from_name(fg)) + (this.ansi24bit_code_from_name(bg, true));
      };
      text = CND.bold(' WXD ');
      // echo color + text
      BAR = require('./bar');
      color_1 = this.cfn('Green', 'Black');
      color_2 = this.cfn('Orchid', 'Green');
      reset = "\x1b[0m";
      puffer = (this.cfn('Black')) + ' ';
      border = (this.cfn('White', 'Black')) + '▏';
      echo(color_1);
      for (n = i = 70; i <= 96; n = i += +1) {
        // echo ( BAR.hollow_percentage_bar n  ) + text
        // echo color_1 + ( BAR.hollow_percentage_bar n  ) + text
        echo(puffer + (color_1 + BAR.percentage_bar(n)) + border + puffer + (color_2 + ` ${n} `) + reset);
      }
      debug(((function() {
        var results;
        results = [];
        for (k in convert_color) {
          results.push(k);
        }
        return results;
      })()).sort().join(' '));
      debug(this.rgb_from_name('Red'));
      debug(convert_color.rgb.lch(this.rgb_from_name('Green')));
      debug(convert_color.rgb.lch(this.rgb_from_name('Red')));
      // debug ( @ansi24bit_code_from_rgb convert_color.rgb.lch [ 53, 105, 40 ] ) + 'helo'
      demo_lch_gamut = function() {
        /* see http://lea.verou.me/2020/04/lch-colors-in-css-what-why-and-how */
        var C, H, L, j, l, line, results;
        L = 53;
        C = 105;
        H = 40;
        echo(CND.blue('Colors!'));
// for L in [ 0 .. 100 ] by +10
        results = [];
        for (H = j = 0; j <= 360; H = j += +10) {
          line = CND.yellow(` LCH ${L},${C},${H} `);
          for (C = l = 0; l <= 100; C = l += +10) {
            line += (this.ansi24bit_code_from_lch([L, C, H], true)) + '  ';
          }
          results.push(echo(line + (CND.black(' '))));
        }
        return results;
      };
      // cold_lch     = [ 46, 72, 136 ]
      // cold_lch     = [ 53, 105, 136 ]
      // CND.ring_bell()
      // echo "\x1b]0;helo world"
      echo("\x1b]0;second try\x07");
      echo("\x1b]1;second try\x07");
      return echo("\x1b]2;second try\x07");
    })();
  }

}).call(this);

//# sourceMappingURL=colors.js.map