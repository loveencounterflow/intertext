(function() {
  'use strict';
  var CND, FS, Multimix, PATH, alert, assign, badge, debug, echo, help, info, jr, log, rpr, urge, warn, whisper;

  //###########################################################################################################
  CND = require('cnd');

  rpr = CND.rpr;

  badge = 'INTERTEXT';

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
  FS = require('fs');

  PATH = require('path');

  Multimix = require('multimix');

  ({assign, jr} = CND);

  // { walk_cids_in_cid_range
  //   cwd_abspath
  //   cwd_relpath
  //   here_abspath
  //   _drop_extension
  //   project_abspath }       = require './helpers'
  // @types                    = require './types'
  // { isa
  //   validate
  //   cast
  //   type_of }               = @types
  // SP                        = require 'steampipes'
  // { $
  //   $async
  //   $watch
  //   $show
  //   $drain }                = SP.export()
  // { jr, }                   = CND
  // DATOM                     = new ( require 'datom' ).Datom { dirty: false, }
  // { new_datom
  //   wrap_datom
  //   # lets
  //   select }                = DATOM.export()
  Multimix = require('multimix');

  // #===========================================================================================================
  // #
  // #-----------------------------------------------------------------------------------------------------------
  // MAIN = @
  // class Fontmirror extends Multimix
  //   @include MAIN,                              { overwrite: false, }
  //   @include ( require './outliner.mixin' ),    { overwrite: false, }
  //   @include ( require './cachewalker.mixin' ), { overwrite: false, }
  //   @include ( require './_temp_svgttf' ),      { overwrite: false, } ### !!!!!!!!!!!!!!!!!!!!!!!!!!! ###
  //   # @extend MAIN, { overwrite: false, }

  //   #---------------------------------------------------------------------------------------------------------
  //   constructor: ( target = null ) ->
  //     super()
  //     @CLI    = require './cli'
  //     @CFG    = require './cfg'
  //     @TAGS   = require './tags'
  //     @NICKS  = require './texfontnamesake'
  //     @LINKS  = require './links'
  //     @export target if target?
  //     return @

  // module.exports = FONTMIRROR = new Fontmirror()

  //###########################################################################################################
  if (module === require.main) {
    (() => {
      return null;
    })();
  }

}).call(this);
