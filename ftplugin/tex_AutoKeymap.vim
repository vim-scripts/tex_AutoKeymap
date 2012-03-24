" Vim Tex / LaTeX ftplugin to automatically change keymap.
" Maintainor:	  Artem Shcherbina <artshchrebina@gmail.com>
" Created:	    2011-11-19
" Last Changed:	2012-03-24
" Version:	    0.9
" Installation: Put file tex_AutoKeymap.vim into ftplugin folder.
"
" Description:
" This script will be useful for users, who edit tex files with text not in
" English language. With this script you will no longer need to change
" system language when editing usual text and formulas. Internal vim
" language (see keymap) will change automatically based on cursor position.
"
" For example, if you set in your .vimrc or tex.vim file 
"
"    let g:tex_Keymap = 'ru'
"
" then in text zone your keymap will be 'ru', and if you start edit a
" formula keymap will be changed to default automatically.
"
" It is based on default tex sintax information and some regular expressions.
" 
" To disable script you can commentify the string
"
"    let g:tex_Keymap = 'ru'
"
" Use <C-J> to manually change keymap
"
" Suggestions and improvements are appreciated.
"
"
" Changelog:
" 0.7 initial upload
" 0.9 language detection and switching improved


" Check for g:tex_Keymap
if !exists('g:tex_Keymap')
  finish
endif


inoremap <buffer> \ \<Esc>:let &keymap = '' <CR>a
nnoremap <buffer> o :call ResetMode()<CR>o
nnoremap <buffer> O :call ResetMode()<CR>O
nnoremap <buffer> a :call ResetMode()<CR>a
nnoremap <buffer> i :call ResetMode()<CR>i
nnoremap <buffer> s :call ResetMode()<CR>cw
nnoremap <buffer> A $:call ResetMode()<CR>a

inoremap <buffer> <C-J> <Esc>:call ResetKeymap()<CR>a
nnoremap <buffer> <C-J> :call ResetKeymap()<CR>


" Some useful mappings
" move cursor right
"inoremap <buffer> <C-L> <Right><Esc>:call ResetMode()<CR>a
" start an inline equation
"inoremap <buffer> <C-O> \(\)<Esc><Left>:let &keymap = ''<CR>i


function! ResetMode()
  let &keymap = g:tex_Keymap
  for id in synstack(line('.'), max([1, col('.')]))
    if synIDattr(id, "name") =~ 'Math\|texStatement\|texCmdBody\|texLigature\|texParen'
      let &keymap = ''
    endif
  endfor

  if search('\(\\\(begin\|end\)\s*{.*\%#.*}\)\|[a-zA-Z]\%#\|\\k*\%#\|\%#\', 'cn')
    let &keymap = ''
  endif
endfunction


function! ResetKeymap()
  let &keymap = &keymap == '' ? g:tex_Keymap : ''
  return ''
endfunction


" For debug
function! PrintMode()
  for id in synstack(line('.'), max([1, col('.')-1]))
    exec 'normal! o' . synIDattr(id, "name")
  endfor
endfunction

