
'use strict'


###

'Slab': the part of a word that is separated from others by breakpoints

> The addressable unit of memory on the NCR 315 series is a "slab", short for "syllable", consisting of 12
> data bits and a parity bit. Its size falls between a byte and a typical word (hence the name, 'syllable').
> A slab may contain three digits (with at sign, comma, space, ampersand, point, and minus treated as
> digits) or two alphabetic characters of six bits each.—[Wikipedia, "NCR
> 315"](https://en.wikipedia.org/wiki/NCR_315)

###


############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'INTERTEXT/SLABS'
debug                     = CND.get_logger 'debug',     badge
alert                     = CND.get_logger 'alert',     badge
whisper                   = CND.get_logger 'whisper',   badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
info                      = CND.get_logger 'info',      badge
PATH                      = require 'path'
FS                        = require 'fs'
{ jr, }                   = CND
assign                    = Object.assign
join_path                 = ( P... ) -> PATH.resolve PATH.join P...
#...........................................................................................................
types                     = require './types'
{ isa
  validate
  cast
  type_of }               = types
SP                        = require 'steampipes'
{ $
  $drain }                = SP.export()
DATOM                     = require 'datom'
{ new_datom
  select }                = DATOM.export()
INTERTEXT                 = null
LineBreaker               = null
Multimix                  = require 'multimix'


#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
class Slabs extends Multimix
  _defaults:
    ### NOTE A joint is a single chr from the Unicode BMP signalling the behavior/status of the right hand
    end of a slab:
    * **blunt**— joint: `#`; nothing (empty string) whether non-final or final
    * **shy**—   joint: `=`; nothing when non-final, add hyphen (U+002d) when final
    * **space**— joint: `°`; space (U+0020) when non-final, nothing (empty string) when final
    ###
    joints:       { blunt: '#', shy: '=', space: '°', }
    versions:     { slabjoints: '0.0.1', }

  #---------------------------------------------------------------------------------------------------------
  constructor: ( settings = null) ->
    super()
    @settings = { @_defaults..., settings..., }
    return @

  #---------------------------------------------------------------------------------------------------------
  _slabs_from_text: ( text ) ->
    ### TAINT why doesn't import in top level work? ###
    INTERTEXT    ?= require '..'
    ### TAINT benchmark against https://github.com/hfour/linebreak-ts ###
    LineBreaker  ?= require 'linebreak'
    line_breaker  = new LineBreaker text
    #.......................................................................................................
    shy_chr       = INTERTEXT.HYPH.soft_hyphen_chr
    spc_chr       = '\x20'
    prv_position  = 0
    slabs         = []
    ends          = []
    R             = { slabs, ends, }
    { blunt
      shy
      space }     = @settings.joints
    #.......................................................................................................
    ### LBO: line break opportunity ###
    while ( lbo = line_breaker.nextBreak() )?
      end           = blunt
      slab          = text[ prv_position ... lbo.position ]
      prv_position  = lbo.position
      last_idx      = slab.length - 1
      #.....................................................................................................
      switch slab[ last_idx ]
        when shy_chr  then [ end, slab, ] = [ shy, slab[ ... last_idx ], ]
        ### TAINT in the future, we might want to consider other breaking (fixed or variable) spaces ###
        when spc_chr  then [ end, slab, ] = [ space, slab[ ... last_idx ], ]
      #.....................................................................................................
      slabs.push  slab
      ends.push   end
    #.......................................................................................................
    R.ends = R.ends.join ''
    return R

  #---------------------------------------------------------------------------------------------------------
  slabjoints_from_text: ( text ) ->
    { slabs, ends, }  = @_slabs_from_text text
    version           = @settings.versions.slabjoints
    joints            = @settings.joints
    segments          = ( slab + ends[ idx ] for slab, idx in slabs )
    return { segments, version, joints, size: segments.length, }

  #---------------------------------------------------------------------------------------------------------
  assemble: ( slabjoints, first_idx = null, last_idx = null ) ->
    ### TAINT validate indexes? ###
    validate.intertext_slabs_slabjoints_v001 slabjoints
    { blunt
      shy
      space }     = slabjoints.joints
    { segments }  = slabjoints
    first_idx    ?= 0
    last_idx     ?= segments.length - 1
    first_idx     = Math.max first_idx, 0
    last_idx      = Math.min last_idx, segments.length - 1
    R             = ''
    #.......................................................................................................
    for idx in [ first_idx .. last_idx ] by +1
      segment = segments[ idx ]
      text    = segment[ ... segment.length - 1 ]
      final   = segment[     segment.length - 1 ]
      R      += text
      switch final
        when blunt  then null
        when space  then ( if idx isnt last_idx then R += '\x20' )
        ### TAINT allow to configure hyphen ###
        when shy    then ( if idx is last_idx then R += '-' )
        else throw new Error "^INTERTEXT/SLABS@4352^ unknown slab `end` option #{rpr end}"
    #.......................................................................................................
    return R


############################################################################################################
module.exports = new Slabs()


############################################################################################################
if module is require.main then do =>



