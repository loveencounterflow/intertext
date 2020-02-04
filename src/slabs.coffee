
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


#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
@slabs_from_text = ( text ) ->
  ### TAINT why doesn't import in top level work? ###
  INTERTEXT    ?= require '..'
  ### TAINT benchmark against https://github.com/hfour/linebreak-ts ###
  LineBreaker  ?= require 'linebreak'
  line_breaker  = new LineBreaker text
  #.........................................................................................................
  shy           = INTERTEXT.HYPH.soft_hyphen_chr
  spc           = '\x20'
  prv_position  = 0
  slabs         = []
  ends          = []
  R             = { slabs, ends, }
  #.........................................................................................................
  ### LBO: line break opportunity ###
  while ( lbo = line_breaker.nextBreak() )?
    end           = 'x'
    slab          = text[ prv_position ... lbo.position ]
    prv_position  = lbo.position
    last_idx      = slab.length - 1
    #.......................................................................................................
    switch slab[ last_idx ]
      when shy then [ end, slab, ] = [ '|', slab[ ... last_idx ], ]
      ### TAINT in the future, we might want to consider other breaking (fixed or variable) spaces ###
      when spc then [ end, slab, ] = [ '_', slab[ ... last_idx ], ]
    #.......................................................................................................
    slabs.push  slab
    ends.push   end
  #.........................................................................................................
  R.ends = R.ends.join ''
  return R

#-----------------------------------------------------------------------------------------------------------
@assemble = ( me, first_idx = null, last_idx = null ) ->
  ### TAINT validate indexes? ###
  first_idx  ?= 0
  last_idx   ?= me.slabs.length - 1
  first_idx   = Math.max first_idx, 0
  last_idx    = Math.min last_idx, me.slabs.length - 1
  R           = ''
  #.........................................................................................................
  for idx in [ first_idx .. last_idx ] by +1
    R += me.slabs[ idx ]
    switch end = me.ends[ idx ]
      when 'x'  then null
      when '_'  then ( if idx isnt last_idx then R+= '\x20' )
      ### TAINT allow to configure hyphen ###
      when '|'  then ( if idx is last_idx then R+= '-' )
      else throw new Error "^INTERTEXT/SLABS@4352^ unknown slab `end` option #{rpr end}"
  #.........................................................................................................
  return R



