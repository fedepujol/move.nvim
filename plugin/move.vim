" prevent loading file twice
if exists('g:loaded_move') | finish | endif

" save user coptions
let s:save_cpo = &cpo 
" reset them to defaults
set cpo&vim 

" command to run our plugin
command! -nargs=1 			MoveLine 	lua require('move').MoveLine(<args>)
command! -nargs=1 -range=%	MoveBlock 	lua require('move').MoveBlock(<args>, <line1>, <line2>)
command! -nargs=1 			MoveHChar	lua require('move').MoveHChar(<args>)
command! -nargs=1 -range=%	MoveHBlock	lua require('move').MoveHBlock(<args>)

" and restore after
let &cpo = s:save_cpo 
unlet s:save_cpo

let g:loaded_move = 1
