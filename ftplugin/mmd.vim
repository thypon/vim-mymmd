" VIM ftplugin for mail
" Author:   Gautam Iyer <gautam@math.uchicago.edu>
" Created:  Tue 25 Feb 2014 04:23:18 PM EST
" Modified: Wed 26 Feb 2014 03:21:59 PM EST

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = "setl tw< fo< com<"

setl ai tw=78 fo+=n2c fdm=syntax et

" Set header markers and list markers as comments.
setl com=fb:######,fb:#####,fb:####,fb:###,fb:##,fb:# "Headers
setl com+=b:>	" Block quotes
setl com+=fb:*,fb:-,fb:+ " Lists
" fo+=tcql 
