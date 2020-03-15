
'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'CHEVROTAIN-HTML-GRAMMAR'
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
{ assign
  jr }                    = CND
LEXER                     = require './chevrotain-lexer'
PARSER                    = require './chevrotain-parser'
{ lets
  freeze }                = ( new ( require 'datom' ).Datom { dirty: false, } ).export()
{ isa }                   = require '../types'

#-----------------------------------------------------------------------------------------------------------
@distill_token = ( token ) ->
  text      = token.image
  start     = token.startOffset
  stop      = token.endOffset + 1
  name      = token.tokenType?.name ? '???'
  return freeze { $key: '^token', name, text, start, stop, }

#-----------------------------------------------------------------------------------------------------------
@_errors_from_parsification = ( parsification ) ->
  not_given   = ( x ) -> ( x is '') or ( not x? ) or ( isa.nan x )
  { source, } = parsification
  R           = []
  for error in parsification.errors.lexer
    { offset
      length
      message } = error
    start       = offset
    stop        = offset + length
    text        = parsification.source[ start ... stop ]
    if message.startsWith 'extraneous' then code = 'extraneous'
    else                                    code = 'other'
    R.push { $key: '^error', code, origin: 'lexer', message, text, start, stop, }
  for error in parsification.errors.parser
    { name
      message
      token
      resyncedTokens
      context         } = error
    start = error.token.startOffset
    stop  = error.token.endOffset
    text  = error.token.image
    switch name
      when 'NotAllInputParsedException'
        code  = 'extraneous'
      when 'MismatchedTokenException'
        code  = 'mismatch'
      when 'NoViableAltException'
        code  = 'missing'
      else
        code = 'other'
    start   = error.previousToken.startOffset         if not_given start
    stop    = error.previousToken.endOffset           if not_given stop
    text    = error.previousToken.image               if not_given text
    start   = 0                                       if not_given start
    stop    = parsification.source.length             if not_given stop
    text    = parsification.source[ start ... stop ]  if not_given text
    R.push { $key: '^error', code, chvtname: name, origin: 'parser', message, text, start, stop, }
  return R

#-----------------------------------------------------------------------------------------------------------
@extract_tokens = ( parsification ) ->
  { source
    cst }  = parsification
  ### TAINT adapt errors ###
  errors      = @_errors_from_parsification parsification
  report      = { '$key': '^report', source, errors, }
  tokens      = @_extract_tokens source, cst
  R           = [ report, tokens..., errors..., ]
  ### sort errors, tokens consistently ###
  R.sort ( a, b ) -> return a.start - b.start
  return R

#-----------------------------------------------------------------------------------------------------------
@_extract_tokens = ( source, tree, level = 0 ) ->
  ### terminals: ["image","startOffset","endOffset",...
  non-terminals: ["name","children","location"] ###
  # whisper jr ( k for k of tree )
  return null unless tree?
  indent = '  '.repeat level
  #.........................................................................................................
  unless tree.children?
    switch type = tree.tokenType.name
      when 'o_text', 'stm_text'
        yield lets ( @distill_token tree ), ( d ) -> d.$key = '^text'; delete d.name
      when 'stm_slash2'
        yield lets ( @distill_token tree ), ( d ) -> d.$key = '>tag'; d.type = 'nctag'; delete d.name
      when 'o_comment'
        yield lets ( @distill_token tree ), ( d ) -> d.$key = '^COMMENT'; delete d.name
      when 'o_pi'
        yield lets ( @distill_token tree ), ( d ) -> d.$key = '^PI'; delete d.name
      when 'o_cdata'
        d = @distill_token tree
        start = d.start + 9
        stop  = d.stop  - 3
        text  = source[ start ... stop ]
        yield lets d, ( d ) -> d.$key = '<CDATA'; delete d.name; d.stop = start; d.text = source[ d.start ... d.stop ]
        yield { $key: '^text', text, start, stop, }
        yield lets d, ( d ) -> d.$key = '>CDATA'; delete d.name; d.start = stop; d.text = source[ d.start ... d.stop ]
      else
        yield @distill_token tree
    return null
  #.........................................................................................................
  { start
    stop }  = @distill_token tree.location
  text      = source[ start ... stop ]
  type      = tree.name ? '???'
  switch type
    when 'osntag'
      name = tree.children.i_name[ 0 ].image
      if      tree.children.i_close?       then type = 'otag'
      else if tree.children.i_slash_close? then type = 'stag'
      else if tree.children.stm_slash1?    then type = 'ntag'
      if tree.children.attributes?
        atrs = {}
        # debug '^33412-1^', jr tree.children.attributes
        # debug '^33412-2^', jr tree.children.attributes[ 0 ]
        # debug '^33412-3^', jr tree.children.attributes[ 0 ].children.attribute
        for atr in tree.children.attributes[ 0 ].children.attribute
          k         = atr.children.i_name[ 0 ].image
          v         = atr.children.v_value?[ 0 ]?.image ? true
          atrs[ k ] = v
        yield { $key: '<tag', name, type, text, start, stop, atrs, }
      else
        yield { $key: '<tag', name, type, text, start, stop, }
    when 'ctag'
      name = tree.children.i_name[ 0 ].image
      yield { $key: '>tag', name, type, text, start, stop, }
    else
      yield { $key: "^unknown", type, text, start, stop, } unless type is 'document'
      for key, tokens of tree.children
        for token in tokens
          # yield { $key: '^xxx', text, start, stop, $stamped: true, }
          yield from @_extract_tokens source, token, level + 1
  return null


