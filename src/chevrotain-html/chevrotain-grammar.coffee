
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
  return { name, text, start, stop, }

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
    type        = tree.tokenType.name
    { name
      text
      start
      stop }    = @distill_token tree
    token_name  = name
    #.......................................................................................................
    switch type
      when 'o_text', 'stm_text' then  yield freeze { $key: '^text',    text, start, stop,                 }
      when 'stm_slash2'         then  yield freeze { $key: '>tag',     text, start, stop, type: 'ztag',   }
      when 'o_comment'          then  yield freeze { $key: '^COMMENT', text, start, stop, escaped: true,  }
      when 'o_doctype'          then  yield freeze { $key: '^DOCTYPE', text, start, stop, escaped: true,  }
      when 'o_pi'               then  yield freeze { $key: '^PI',      text, start, stop, escaped: true,  }
      when 'o_cdata'
        start1 = start + 9
        stop1  = stop  - 3
        text0   = source[ start   ... start1  ]
        text1   = source[ start1  ... stop1   ]
        text2   = source[ stop1   ... stop    ]
        yield freeze { $key: '<CDATA',  text: text0,  start: start,   stop: start1, }
        yield freeze { $key: '^text',   text: text1,  start: start1,  stop: stop1,  }
        yield freeze { $key: '>CDATA',  text: text2,  start: stop1,   stop: stop,   }
      else
        yield freeze { $key: '^other', name: token_name, text, start, stop, }
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
        yield freeze { $key: '<tag', name, text, start, stop, type, atrs, }
      else
        yield freeze { $key: '<tag', name, text, start, stop, type, }
    when 'ctag'
      name = tree.children.i_name[ 0 ].image
      yield freeze { $key: '>tag', name, text, start, stop, type, }
    else
      yield freeze { $key: "^unknown", text, start, stop, type, } unless type is 'document'
      for key, tokens of tree.children
        for token in tokens
          yield from @_extract_tokens source, token, level + 1
  return null


