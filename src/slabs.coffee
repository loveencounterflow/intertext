
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
# reconstitute_text = ( slab ) ->
#   R = slab.txt
#   if slab.rhs is 'shy' then R += '-'
#   else if slab.rhs is 'spc' then R += ' '
#   return R
# @slabs_from_paragraph = ( text ) ->
#   ### TAINT avoid to instantiate new parser for each paragraph ###
#   ### TAINT consider to use pipestreaming instead of looping ###
#   parse_html  = SP.HTML.new_onepiece_parser()
#   ctx_stack   = []
#   R           = []
#   for d in parse_html text
#     ### TAINT should check for matching tags ###
#     ### TAINT must also store HTML attributes ###
#     if ( select d, '<' )      then ctx_stack.push d.$key[ 1 .. ]
#     else if ( select d, '>' ) then ctx_stack.pop()
#     #.......................................................................................................
#     if ( select d, '<' ) and ( d.is_block ? false )
#       info CND.white '————————————————————————————————————— ' + d.$key
#       continue
#     #.......................................................................................................
#     if ( select d, '^text' )
#       text      = d.text.replace /\n/g, ' '
#       slabs     = @slabs_from_text text
#       R.push slabs
#       # for slab in slabs.$value
#       #   rhs = if slab.rhs? then slab.rhs else null
#       opener  = "<slug>" + ( "<#{element}>" for element in ctx_stack ).join ''
#       closer  = "</slug>"
#       info ( CND.yellow opener ), \
#         ( ( ( CND.blue reconstitute_text slab ) for slab in slabs.$value ). join CND.grey '|' ), \
#         ( CND.yellow closer )
#       continue
#     whisper d.$key
#   #.........................................................................................................
#   return new_datom '^slab-blocks', R


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
    end           = null
    slab          = text[ prv_position ... lbo.position ]
    prv_position  = lbo.position
    last_idx      = slab.length - 1
    #.......................................................................................................
    switch slab[ last_idx ]
      when shy then [ end, slab, ] = [ 'shy', slab[ ... last_idx ], ]
      ### TAINT in the future, we might want to consider other breaking (fixed or variable) spaces ###
      when spc then [ end, slab, ] = [ 'spc', slab[ ... last_idx ], ]
    #.......................................................................................................
    slabs.push  slab
    ends.push   end
  #.........................................................................................................
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
      when null   then null
      when 'spc'  then R+= '\x20'
      ### TAINT allow to configure hyphen ###
      when 'shy'  then ( if idx is last_idx then R+= '-' )
      else throw new Error "^INTERTEXT/SLABS@4352^ unknown slab `end` option #{rpr end}"
  #.........................................................................................................
  return R


############################################################################################################
if module is require.main then do =>
  # @demo_linebreak()
  # @demo_hyphenation()
  html = """<p><strong>Letterpress</strong> printing is a <em>technique of relief printing using a printing
  press,</em> a process by which many copies are produced by <em>repeated direct impression of an inked,
  raised surface</em> against sheets or a continuous roll of paper.</p> <p>A worker composes and locks
  movable type into the ‘bed’ or ‘chase’ of a press, inks it, and presses paper against it to transfer the
  ink from the type which creates an impression on the paper.</p>"""
  text = """Letterpress printing is a technique of relief printing using a printing press."""
  html = """<p>#{text}</p>"""
  # urge @slabs_from_paragraph html
  urge @slabs_from_text text


