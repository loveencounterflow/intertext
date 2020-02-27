
'use strict'


### thx to https://www.w3.org/TR/xml ###
@xmlname_re_head = ///
  a-z
  A-Z
  :_
  \xc0-\xd6
  \xd8-\xf6
  \u00f8-\u02ff
  \u0370-\u037d
  \u037f-\u1fff
  \u200c-\u200d
  \u2070-\u218f
  \u2c00-\u2fef
  \u3001-\ud7ff
  \uf900-\ufdcf
  \ufdf0-\ufffd
  \u{10000}-\u{effff} ///u

@xmlname_re_tail = ///
  0-9
  \.\x2d\xb7
  \u0300-\u036f
  \u203f-\u2040 ///u

@mktsname_re_tail = ///
  0-9 \x23
  \.\x2d\xb7
  \u0300-\u036f
  \u203f-\u2040 ///u

@xmlname_re_anchored = /// ^
  [#{@xmlname_re_head.source}]
  [#{@xmlname_re_head.source}#{@xmlname_re_tail.source}]* $ ///u ### must NOT set global flag ###

@xmlname_re_frontanchored = /// ^
  [#{@xmlname_re_head.source}]
  [#{@xmlname_re_head.source}#{@xmlname_re_tail.source}]* ///u ### must NOT set global flag ###

@xmlname_re_sticky = ///
  [#{@xmlname_re_head.source}]
  [#{@xmlname_re_head.source}#{@xmlname_re_tail.source}]* ///uy ### must NOT set global flag ###

@mktsname_re_frontanchored = /// ^
  [#{@xmlname_re_head.source}]
  [#{@xmlname_re_head.source}#{@mktsname_re_tail.source}]* ///u ### must NOT set global flag ###

@mktsname_re_sticky = ///
  [#{@xmlname_re_head.source}]
  [#{@xmlname_re_head.source}#{@mktsname_re_tail.source}]* ///uy ### must NOT set global flag ###



