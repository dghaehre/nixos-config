" ################ Defaults #################
"""""""""""""""""""""""""""""""""""""""""""""

:set expandtab
:set shiftwidth=2
:set softtabstop=2
:set tabstop=2
:set autoindent
:set smartindent

set wrap
set linebreak
set textwidth=0
set wrapmargin=0
" ^ word wrap

" Store undoes
set undodir=~/.vim/undo-dir
set undofile

set foldmethod=manual
set foldlevel=0
set foldlevelstart=20
set nocompatible
filetype plugin on
syntax on
:set number relativenumber
:set nu rnu


" ################ Default keys/commands #################
"""""""""""""""""""""""""""""""""""""""""""""""
" Set leader
:let mapleader = " "

"== Copy to clipboard
let @y = "\"+y"

" close all folds
nmap <Leader>fj zM
" open all folds
nmap <Leader>fk zR
" toggle fold from cursor
nmap <Leader>ff zA
" start to make a manual fold
nmap <Leader>fm zf

" toggles between buffers
nnoremap <leader><leader> <c-^>

" enable spelling
command! SpellUs execute "set spell spelllang=en_us"
command! SpellNb execute "set spell spelllang=nb"
" disable: `:set nospell`

" Change word, and press . for changing next word.
nnoremap <leader>x *``cgn
vnoremap <leader>x y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn

" Set current file as current dir
nmap <Leader>cd :cd %:p:h<cr>:pwd<cr>

" write dts to insert date and time
:iab <expr> dts strftime("%d/%m/%y %H:%M:%S")


" ################ Snippets #################
""""""""""""""""""""""""""""""""""""""""""""
abbr newp new Promise((resolve, reject) => {<CR><CR><esc>0i})<esc>0k
abbr iferr if err != nil {<CR><CR>}<esc>kddko




" ################ File manager #################
""""""""""""""""""""""""""""""""""""""""""""
" nnn
let g:nnn#action = { '<c-e>': 'vsplit' }




" ######### DISPLAY #############
""""""""""""""""""""""""""""""""""
set background=dark
set t_Co=256
let g:airline_powerline_fonts = 0
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.dirty = ' !'
let g:airline_theme='atomic'
set fillchars=""
highlight VertSplit cterm=NONE
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set number
set numberwidth=5
:set cursorline
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
highlight CursorLine cterm=NONE ctermbg=Black ctermfg=NONE guibg=NONE guifg=NONE



" #################### Startify ########################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_bookmarks = [ {'c': '~/.vimrc'}, {'z': '~/.zshrc'}, {'s': '~/.ssh/config'}, {'g': '~/.gitconfig'}, {'t': '~/Dropbox/todotxt/todo.txt'}, {'d': '~/Dropbox/todotxt/done.txt'} ]



" ################ Coc language server #################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bug: higlight only takes effect after sourcing .vimrc
highlight CocFloating ctermfg=NONE
function! s:check_back_space() abort
  let col = col('.') - 1
   return !col || getline('.')[col - 1]  =~ '\s'
   endfunction

inoremap <silent><expr> <Tab>
     \ pumvisible() ? "\<C-n>" :
     \ <SID>check_back_space() ? "\<Tab>" :
     \ coc#refresh()

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction





" ########## FZF ###########
"""""""""""""""""""""""""""""
nmap <Leader>b :Buffers<Enter>
nmap <Leader>s :Files<Enter>
nmap <Leader>m :Marks<Enter>
nmap <Leader>g :Rg<Enter>
" Let you enter <Leader>g to search higlighted text in whole project
" A quick and dirty trick if tags or coc is missing
nmap <Leader>/ viwy:Rg <C-R>=escape(@",'/\')<CR><CR>





" ############# NAVIGATION ##########
"""""""""""""""""""""""""""""""""""""
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nmap <Leader>e :vsp<Enter>
nmap <Leader>E :sp<Enter>





" ############ Resizing ############
""""""""""""""""""""""""""""""""""""
nmap <Leader>rk :resize +20<Enter>
nmap <Leader>rj :resize -20<Enter>
nmap <Leader>rh :vertical resize +20<Enter>
nmap <Leader>rl :vertical resize -20<Enter>



" ################ Language specific #################
"----------------------------------------------------"

" ################ Haskell #################
""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType haskell setlocal shiftwidth=2 tabstop=2 expandtab
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
" https://github.com/chrisdone/hindent#vim
" Using Hindent in V mode: gq



" ################ Vimwiki #################
""""""""""""""""""""""""""""""""""""""""""""
let g:vimwiki_list = [
      \{'path': '~/wikis/work/', 'syntax': 'markdown', 'ext': '.md'},
      \{'path': '~/wikis/personal/', 'syntax': 'markdown', 'ext': '.md'}]
" let g:vimwiki_folding='expr'
:nmap <Leader>wsp <Plug>VimwikiSplitLink
" Create link
:vmap <Leader>l di[](<Esc>pa)<Esc>f[,a
" Handle lists
:map <Leader>tt <Plug>VimwikiToggleListItem
:nmap <Leader>tj <Plug>VimwikiIncrementListItem
:vmap <Leader>tj <Plug>VimwikiIncrementListItem
:nmap <Leader>tk <Plug>VimwikiDecrementListItem
:vmap <Leader>tk <Plug>VimwikiDecrementListItem
" Table
:map <Leader>ta :VimwikiTable<Enter>


" ################ Vue #################
""""""""""""""""""""""""""""""""""""""""
let g:vue_pre_processors = []


" ################ Bugs #################
"""""""""""""""""""""""""""""""""""""""""
" Fix crontab bug
autocmd filetype crontab setlocal nobackup nowritebackup
