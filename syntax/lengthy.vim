" Language:	Lengthy
" Maintainer:	Israel Chauca F. <israelchauca@gmail.com>
" License:	Vim License (see :help license)
" Website:	https://github.com/Raimondi/vim-lengthy

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" TODO Make sure the intervals are appropiate.
let s:limits = copy(get(g:, 'lengthy_limits',
      \ [2, 5, 8, 11, 14, 18, 22, 26, 30, 35, 40, 45]))
let s:lower = 0
let s:upper = 0
let s:priority = -1 * (1 + len(s:limits))
let s:group_template = 'Lengthy%s'
let s:i = 1
" Characters that mark the end of a sentence.
let s:eos = get(g:, 'lengthy_eos', '.!?')
" Paragraph ends with a single or double CR.
let s:eop = get(g:, 'lengthy_eop', 'double') == 'single' ? '\n' : '\n\n'
let s:spc = get(g:, 'lengthy_eop', 'double') == 'single' ? '\s'  : '\_s'
let s:pattern_template =
      \ '\%%('
        \ . '\%%('.s:spc.'\+\|\%%^\s*\|^\s*\)'
        \ . '\%%('
            \ . '\.\?\%%(\a\+\.\)\+\S*\|'
            \ . '[^ \t'.s:eos.']*\d\+\%%(\.\d\+\)\+[^ \t'.s:eos.']*\|'
            \ . '[^ \t'.s:eos.']\+'
        \ . '\)'
      \ . '\)\{%s,%s}\%%(['.s:eos.']\S*\|'.s:eop.'\|\%$\)'

syn sync minlines=50
" Define syntax
while !empty(s:limits)
  let s:lower = s:upper + 1
  let s:upper = remove(s:limits, 0)
  let s:pattern = printf(s:pattern_template, s:lower, s:upper)
  let s:group = printf(s:group_template, s:i)
  exec printf('syn match %s /%s/', s:group, s:pattern)
  let s:priority += 1
  let s:i += 1
endwhile
let s:group = printf(s:group_template, s:i)
let s:pattern = printf(s:pattern_template, (s:upper + 1), '')
exec printf('syn match %s /%s/', s:group, s:pattern)

let b:current_syntax = "lengthy"

let &cpo = s:save_cpo
unlet s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
