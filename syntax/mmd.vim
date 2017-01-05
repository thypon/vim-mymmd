" Vim syntax file
" Language:	Multimarkdown
" Maintainer:	Josh Geist
" URL:		http://www.jnicholasgeist.com
" Version:	0.1
" Last Change:  2011 July 05
" Remark:	Derived from Ben Williams's Markdown plugin for vim
"               (http://plasticboy.com/markdown-vim-mode/)
" Remark:	Uses HTML syntax file
" Remark:	I don't do anything with angle brackets (<>) because that would too easily
"		easily conflict with HTML syntax
" TODO: 	Handle stuff contained within stuff (e.g. headings within blockquotes)


if exists("b:current_syntax")
  finish
endif

" Read Jinja2 syntax
if exists( 'g:markdown_jinja' ) && g:markdown_jinja
    runtime! syntax/jinja.vim
    unlet b:current_syntax
else
" Just read the plain HTML syntax to start with
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

syn spell toplevel
syn case ignore
syn sync linebreaks=1

"additions to HTML groups
syn region htmlBold     start=/\\\@<!\(^\|\A\)\@=\*\@<!\*\*\*\@!/     end=/\\\@<!\*\@<!\*\*\*\@!\($\|\A\)\@=/   contains=@Spell,htmlItalic
syn region htmlItalic   start=/\\\@<!\(^\|\A\)\@=\*\@<!\*\*\@!/       end=/\\\@<!\*\@<!\*\*\@!\($\|\A\)\@=/      contains=htmlBold,@Spell
syn region htmlBold     start=/\\\@<!\(^\|\A\)\@=_\@<!___\@!/         end=/\\\@<!_\@<!___\@!\($\|\A\)\@=/       contains=htmlItalic,@Spell
"syn region htmlItalic   start=/\\\@<!\(^\|\A\)\@=_\@<!__\@!/          end=/\\\@<!_\@<!__\@!\($\|\A\)\@=/        contains=htmlBold,@Spell
syn region htmlItalic   start=/\v\s+__@!/ end=/\v\w@<=_(\s+|$)/        contains=htmlBold,@Spell

syn match mkdTableCaption     "|\n\zs\[[^]]*\]$"
syn match mkdTableCaption     "^\[[^]]*\]\ze\n|"

syn region mkdMetadata start=/\%^.*:.*$/ end=/^$/ contains=mkdMetadataKey,mkdMetadataText fold
syn match mkdMetadataKey /^[^:]*\ze:/ contained
syn match mkdMetadataText /:.*/ contained

" [link](URL) | [link][id] | [link][]
syn region mkdLink matchgroup=mkdDelimiter      start="\!\?\[\ze[^]]*\][[(]" end="\]\ze\s*[([]" contains=@Spell nextgroup=mkdURL,mkdID skipwhite
syn region mkdID matchgroup=mkdDelimiter        start="\["    end="\]" contained
syn region mkdURL matchgroup=mkdDelimiter       start="("     end=")"  contained
" mkd  inline links:           protocol   optional  user:pass@       sub/domain                 .com, .co.uk, etc      optional port   path/querystring/hash fragment
"                            ------------ _____________________ --------------------------- ________________________ ----------------- __
"syntax match   mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/

"define Multimarkdown variants
syn match  mmdFootnoteMarker  "\[^\S\+\]"
syn match  mmdFootnoteIdentifier  "\[^.\+\]:" contained
syn region mmdFootnoteText  start="^\s\{0,3\}\[^.\+\]:[ \t]" end="^$" contains=mmdFootnoteIdentifier

" Link definitions: [id]: URL (Optional Title)
" TODO handle automatic links without colliding with htmlTag (<URL>)
"syn region mkdLinkDef matchgroup=mkdDelimiter   start="^ \{,3}\zs\[[^^#]" end="]:" oneline nextgroup=mkdLinkDefTarget skipwhite
"syn region mkdLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline
"syn region mkdLinkTitle matchgroup=mkdDelimiter start=+"+     end=+"+  contained
"syn region mkdLinkTitle matchgroup=mkdDelimiter start=+'+     end=+'+  contained
"syn region mkdLinkTitle matchgroup=mkdDelimiter start=+(+     end=+)+  contained

syn region mkdReference start=/^\[[^]]*\]:/ end=/^$/ contains=mkdLinkDef,mkdLinkDefTarget,mkdLinkTitle,mkdLinkAttrib,mkdSourceDef,mkdSource,mmdFootnoteIdentifier,mmdFootnoteText
syn match  mkdLinkDef   /^\[[^^#]\S\+\]:/ nextgroup=mkdLinkDefTarget contained
syn match  mkdLinkDefTarget /\s*\S\+:\S\+/   nextgroup=mkdLinkTitle contained
syn match  mkdLinkTitle /"[^"]*"/ nextgroup=mkdLinkAttrib contained
syn match  mkdLinkTitle /'[^']*'/ nextgroup=mkdLinkAttrib contained
syn match  mkdLinkTitle /([^)]*)/ nextgroup=mkdLinkAttrib contained
syn match  mkdLinkAttrib /\S\+=\S\+/ contained

syn match  mkdSourceDef   /^\[#\S\+\]:/ nextgroup=mkdSource
syn region mkdSource  start="^\s\{0,3\}\[#\S\+\]:\s\?" end="^$"

"define Markdown groups
syn match  mkdLineContinue ".$" contained
syn match  mkdRule      /^\s*\*\s\{0,1}\*\s\{0,1}\*$/
syn match  mkdRule      /^\s*-\s\{0,1}-\s\{0,1}-$/
syn match  mkdRule      /^\s*_\s\{0,1}_\s\{0,1}_$/
syn match  mkdRule      /^\s*-\{3,}$/
syn match  mkdRule      /^\s*\*\{3,5}$/
syn match  mkdListItem  "^\s*[-*+]\s\+"
syn match  mkdListItem  "^\s*\d\+\.\s\+"
syn match  mkdBlockquote /^\%(\s*>\)\+/
"syn region mkdBlockquote start=/^\s*>/              end=/$/                 contains=mkdLineBreak,mkdLineContinue,@Spell
syn match  mkdCode      /^\%(\s\|>\)*\n\%(\s*>\)*\%(\%(\s\{4,}\|\t\+\)\%(\%([-*+]\|[0-9]\+\.\)\s\+\)\@!\S.*\n\)\+/ contains=mkdBlockquote
syn match  mkdLineBreak /  \+$/
syn region mkdCode      start=/\\\@<!`/                   end=/\\\@<!`/ oneline
syn region mkdCode      start=/\v^\s*\z(`{3,})`@!/          end=/^\s*\z1\s*$/
syn region mkdCode      start="<pre[^>]*>"         end="</pre>"
syn region mkdCode      start="<code[^>]*>"        end="</code>"

"HTML headings
syn region htmlH1       start="^\s*#"                   end="\($\|#\+\)" contains=@Spell
syn region htmlH2       start="^\s*##"                  end="\($\|#\+\)" contains=@Spell
syn region htmlH3       start="^\s*###"                 end="\($\|#\+\)" contains=@Spell
syn region htmlH4       start="^\s*####"                end="\($\|#\+\)" contains=@Spell
syn region htmlH5       start="^\s*#####"               end="\($\|#\+\)" contains=@Spell
syn region htmlH6       start="^\s*######"              end="\($\|#\+\)" contains=@Spell
syn match  htmlH1       /^.\+\n=\+$/ contains=@Spell
syn match  htmlH2       /^.\+\n-\+$/ contains=@Spell

syn region mkdComment 	start="^\s*--"			end="$" contains=@Spell

" fold region for headings
syn region mkdHeaderFold
    \ start="^\s*\z(#\+\)"
    \ skip="^\s*\z1#\+"
    \ end="^\(\s*#\)\@="
    \ fold transparent contains=TOP

" fold region for references
syn region mkdReferenceFold
    \ start="^<!--\z(\S*\)-->"
    \ end="^<!--END\z1-->"
    \ fold transparent contains=TOP

" fold region for lists
"syn region mkdListFold
"    \ start="^\z(\s*\)\*\z(\s*\)"
"    \ skip="^\z1 \z2\s*[^#]"
"    \ end="^\(.\)\@="
"    \ fold transparent contains=TOP

" Maths highlighting (TeX)
" Accepts either multimarkdown bracket notation or $ notation.
" Allows use of literal dollars if they are escaped (\$). If you
" want literal dollars without escaping, you'll have to comment out
" the texinlinemaths line.
syntax include syntax/tex.vim
syn region mmddisplaymaths matchgroup=mkdMath start="\\\\\[" end="\\\\\]" contains=@texMathZoneGroup
syn region texdisplaymaths matchgroup=mkdMath start="\$\$" end="\$\$" skip="\\\$" contains=@texMathZoneGroup
syn region texdisplaymaths matchgroup=mkdMath start='\\begin{\z(.\{-\}\)}' end='\\end{\z1}' contains=@texMathZoneGroup
syn region mmdinlinemaths matchgroup=mkdMath start="\\\\(" end="\\\\)" contains=@texMathZoneGroup
" inline maths with $ ... $
" start is a $ not preceded by another $        - \(\$\)\@<!\$
" and not preceded by a \ (concat)              - \(\$\)\@<!\&\(\\\)\@<!\$
" and not followed by another $                 - \$\(\$\)\@!
" ending in a $ not preceded by a \             - \((\$\)\@<!\$
" skipping any \$                               - \\\$
" see :help \@<! for more
syn region texinlinemaths matchgroup=mkdMath start="\(\$\)\@<!\&\(\\\)\@<!\$\(\$\)\@!" end="\(\$\)\@<!\$" skip="\\\$" contains=@texMathZoneGroup
" restriction is that you can't have something like \$$maths$ - there
" has to be a space after all of the \$ (literal $)

" Also match \eqref{..} as tex commands
syn match mkdTeXCommand '\\eqref{.\{-\}}'   contains=mkdEqRef
syn match mkdEqRef	'{\zs.\{-\}\ze}'    contained


syn sync fromstart

"highlighting for Markdown groups
hi def link mkdString	    String
hi def link mkdCode          String
hi def link mkdBlockquote    Comment
hi def link mkdLineContinue  Comment
hi def link mkdComment	     Comment
hi def link mkdListItem      Identifier
hi def link mkdRule          Identifier
hi def link mkdLineBreak     Todo
hi def link mkdLink          htmlLink
hi def link mkdURL           htmlString
hi def link mkdInlineURL     htmlLink
hi def link mkdID            Identifier
hi def link mkdLinkDef       mkdID
hi def link mkdLinkDefTarget mkdURL
hi def link mkdLinkTitle     htmlString
hi def link mmdFootnoteMarker    Constant
hi def link mmdFootnoteIdentifier    Constant
hi def link mmdFootnoteText     String

hi def link mkdMetadataKey   Function
hi def link mkdTableCaption  String
hi def link mkdSourceDef     Statement
hi def link mkdSource        String
hi def link mkdLinkAttrib    Function

hi def link mkdDelimiter     Delimiter

hi def link mkdMath	    SpecialComment
hi def link mmddisplaymaths  mkdMath
hi def link texdisplaymaths  mkdMath
hi def link texinlinemaths   mkdMath
hi def link mmdinlinemaths   mkdMath

hi def link mkdTeXCommand    Statement
hi def link mkdEqRef	    SpecialComment

let b:current_syntax = "mmd"
" vim: ts=8
