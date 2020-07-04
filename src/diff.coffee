#!node

CND                       = require 'cnd'
badge                     = 'INTERTEXT/DIFF'
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
  type_of  }              = types
{ to_width, width_of, }   = require 'to-width'
Multimix                  = require 'multimix'


### see https://github.com/JackuB/diff-match-patch ###

#-----------------------------------------------------------------------------------------------------------
class Diff extends Multimix
  # @include MAIN, { overwrite: false, }
  # @extend MAIN, { overwrite: false, }
  _defaults:
    color_same:   'white'
    color_old:    'orange'
    color_new:    'lime'
    tty_columns:  null

  #---------------------------------------------------------------------------------------------------------
  constructor: ( settings = null) ->
    super()
    @settings               = { @_defaults..., settings..., }
    @_DMP                   = require 'diff-match-patch'
    @_dmp                   = new @_DMP.diff_match_patch()
    unless @settings.tty_columns?
      INTERTEXT = require '..'
      @settings.tty_columns = ( INTERTEXT.get_terminal_size() ).columns
    return @

  #---------------------------------------------------------------------------------------------------------
  rawdiff: ( old_text, new_text ) ->
    R = @_dmp.diff_main old_text, new_text
    @_dmp.diff_cleanupSemantic R
    return R

  #---------------------------------------------------------------------------------------------------------
  colordiff: ( old_text, new_text ) ->
    INTERTEXT = require '..'
    ### TAINT to be replaced by INTERTEXT.COLORS ###
    _cnd      = require 'cnd/lib/TRM-CONSTANTS'
    R         = ''
    diff      = @rawdiff old_text, new_text
    colorized = ( @_colorize dd, text for [ dd, text, ] in diff ).join ''
    lines     = colorized.split '\n'
    for line in lines
      line += _cnd.reverse + _cnd.colors.white
      line  = ( to_width line, @settings.tty_columns ) + '\n'
      R    += line
    return R

  #---------------------------------------------------------------------------------------------------------
  _colorize: ( delta_code, text ) ->
    ### TAINT to be replaced by INTERTEXT.COLORS ###
    lines = text.split '\n'
    color = switch delta_code
      when -1 then CND[ @settings.color_old   ]
      when  0 then CND[ @settings.color_same  ]
      when +1 then CND[ @settings.color_new   ]
    return ( CND.reverse color line for line in lines ).join '\n'



############################################################################################################
module.exports = new Diff()


############################################################################################################
if module is require.main then do =>


