" Vim Tex / LaTeX ftplugin to automatically change keymap.
" Maintainor:	  Artem Shcherbina <artshchrebina@gmail.com>
" Created:	    2011-11-19
" Last Changed:	2011-11-19
" Version:	    0.7
"
" Description:
"   This script will be useful for users, who edit tex files with text not in
"   English language. When editing tex file you will not need to change system
"   languages. Internal vim language (see keymap) will change automatically
"   based on cursor position. For example, if you set in your .vimrc or
"   tex.vim file 
"      let tex_Keymap = 'ru'
"   then in text zone your keymap will be 'ru', and if you start edit a
"   formula keymap will automatically change to 'en'.
"
"   It is based on default tex sintax information.
"   
"   To disable script you can set in your config 
"      let b:loaded_tex_AutoKeymap = 1
"
"   To improve performance of the script, install vim version 7.3 with patch
"   196 or later.
"   
"   Suggestions and improvements are appreciated.

" Provide load control
if exists('b:loaded_tex_AutoKeymap')
  finish
endif
let b:loaded_tex_AutoKeymap = 1

" Check for g:tex_Keymap
if !exists('g:tex_Keymap')
  echoerr 'Your g:tex_Keymap is not inited!'
  finish
endif

if v:version > 703 || v:version == 703 && has("patch196")
  autocmd InsertCharPre *.tex call ResetMode("\<Esc>a")
endif
autocmd CursorMoved *.tex call ResetMode()

inoremap \ \<Esc>a

function! ResetMode(...)
  let new_keymap = g:tex_Keymap
  for id in synstack(line('.'), max([1, col('.')]))
    if synIDattr(id, "name") =~ 'Math\|texStatement\|texCmdBody\|texLigature' || search('\\k*\%#\|\%#\', 'cn')
      let new_keymap = ''
    endif
  endfor

  if new_keymap != &keymap
    let &keymap = new_keymap
    call feedkeys(a:0 > 0 ? a:1 : '')
  endif
endfunction

" For debug
function! PrintMode()
  for id in synstack(line('.'), max([1, col('.')-1]))
    exec 'normal! o' . synIDattr(id, "name")
  endfor
endfunction
