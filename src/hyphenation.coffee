



'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/HYPHENATION'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
echo                      = CND.echo.bind CND
#...........................................................................................................
types                     = require './types'
{ isa
  validate
  cast
  type_of }               = types
hyphenator                = null

#-----------------------------------------------------------------------------------------------------------
### thx to https://stackoverflow.com/a/881111/7568091, https://jsperf.com/performance-of-match-vs-split ###
@soft_hyphen_chr      = '\u00ad'
@soft_hyphen_pattern  = /\u00ad/g
@count_soft_hyphens   = ( text )                    -> ( text.split @soft_hyphen_chr ).length - 1
@reveal_hyphens       = ( text, replacement = '-' ) -> text.replace @soft_hyphen_pattern, replacement
@hyphenate            = ( text )                    -> ( hyphenator ?= @new_hyphenator() ) text

#-----------------------------------------------------------------------------------------------------------
@new_hyphenator = ->
  ### https://github.com/mnater/Hyphenopoly ###
  H9Y               = require 'hyphenopoly/hyphenopoly.module'
  ### see https://github.com/mnater/Hyphenopoly > docs > Setup.md ###
  settings          =
    # hyphen:     '\u00ad'
    #         "exceptions": {
    #             "de": "Algo-rithmus",
    #             "global": "Silben-trennung"
    #         "exceptions": {"de": "Algo-rithmus, Algo-rithmus"},
    # exceptions: {"global": "Silben-trennung"},
    sync:             true
    require:          [ 'en-us', ] # [ "de", "en-us"],
    orphanControl:    1 ### allow orphans ###
    compound:         'auto'  ### all, auto, hyphen; `all` inserts ZWSP after existing hyphen ###
    normalize:        false ### if true, transforms text to some kind of Unicode normal form ###
    mixedCase:        true
    minWordLength:    4
    leftmin:          2 ### also available as per-language setting ###
    rightmin:         2 ### also available as per-language setting ###
  ### return value of call to `config()` is hyphenation function when `require` contain one element, a map
  from language codes to functions otherwise; this we fix here: ###
  _hyphenators = H9Y.config settings
  validate.function _hyphenators
  return _hyphenators
  # switch ( type = type_of _hyphenators )
  #   when 'function' then hyphenators = new Map(); hyphenators.set 'en-us', _hyphenators
  #   when 'map'      then null
  #   else throw new Error "^3464^ unknown hyphenators type #{rpr type}"
  # return hyphenators.get 'en-us'


###

collection of words that are not satisfactorily hyphenated
to be added to an exceptions dictionary

process
su-per-cal-ifrag-ilis-tic




###





