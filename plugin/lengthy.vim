" Maintainer:	Israel Chauca F. <israelchauca@gmail.com>
" Description:	Long description.
" License:	Vim License (see :help license)
" Website:	https://github.com/Raimondi/vim-lengthy

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" Private Functions: {{{1
function! s:lengthy(mode) "{{{2
  if a:mode == 'toggle'
    if &syntax == 'lengthy'
      call s:lengthy('off')
    else
      call s:lengthy('on')
    endif
  elseif a:mode == 'on' && !exists('b:lengthy_prev_syntax')
    let b:lengthy_prev_syntax = &syntax
    set syntax=lengthy
  elseif a:mode == 'off' && exists('b:lengthy_prev_syntax')
    let &syntax = b:lengthy_prev_syntax
    unlet! b:lengthy_prev_syntax
  endif
endfunction

" Commands: {{{1
command! -bar Lengthy call s:lengthy('toggle')
command! -bar LengthyToggle call s:lengthy('toggle')
command! -bar LengthyOn call s:lengthy('on')
command! -bar LengthyOff call s:lengthy('off')

" Highlighting: {{{1

if get(g:, 'lengthy_custom_highlight', 0)
  " The user is defining the highlighting colors, bail out.
  let &cpo = s:save_cpo
  finish
endif

let s:hi_template = 'hi Lengthy%s ctermbg=%s ctermfg=%s guibg=%s guifg=%s'
" What color to use for the foreground.
let s:cfg = get(g:, 'lengthy_foreground', 'black') ==? 'black' ? 0         : 15
let s:gfg = get(g:, 'lengthy_foreground', 'black') ==? 'black' ? '#000000' : '#ffffff'
" List of values to use for the highlighting groups.
" TODO Pick better colors.
let s:bgs = [
      \[ 1,  9, 'Red'],
      \[ 2, 10, 'Green'],
      \[ 3, 11, 'Cyan'],
      \[ 4, 12, 'LightRed'],
      \[ 5, 13, 'LightMagenta'],
      \[ 6, 14, 'Yellow'],
      \[ 7,  1, 'LightGreen'],
      \[ 8,  2, 'DarkYellow'],
      \[ 9,  3, 'LightCyan'],
      \[10,  4, 'DarkCyan'],
      \[11,  5, 'LightYellow'],
      \[12,  6, 'Orange'],
      \[13,  7, 'LightBlue'],
      \]
for [s:i, s:cbg, s:gbg] in s:bgs
  exec printf('hi clear Lengthy%s', s:i)
  exec printf(s:hi_template, s:i, s:cbg, s:cfg, s:gbg, s:gfg)
endfor

" CleanUp: {{{1
let &cpo = s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
