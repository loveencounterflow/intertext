(function() {
  'use strict';
  var CND, FS, PATH, alert, badge, debug, echo, help, info, jr, log, rpr, urge, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT/UCD';

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
  PATH = require('path');

  FS = require('fs');

  //-----------------------------------------------------------------------------------------------------------
  this.get_block_list = function() {
    var R, first, i, last, len, line, line_pattern, lines, name, path;
    R = [];
    line_pattern = /^(?<first>[0-9A-F]+)\.\.(?<last>[0-9A-F]+);\x20(?<name>.+)$/;
    path = PATH.resolve(PATH.join(__dirname, '../data/Blocks-13.0.0.txt'));
    lines = (FS.readFileSync(path, {
      encoding: 'utf-8'
    })).split('\n');
    for (i = 0, len = lines.length; i < len; i++) {
      line = lines[i];
      if (!((!line.startsWith('#')) && (line.length > 0))) {
        continue;
      }
      ({first, last, name} = (line.match(line_pattern)).groups);
      first = parseInt(first, 16);
      last = parseInt(last, 16);
      R.push({first, last, name});
    }
    return R;
  };

}).call(this);
