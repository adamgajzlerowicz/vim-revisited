call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'drmingdrmer/vim-toggle-quickfix'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-janah'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'runoshun/tscompletejob'
Plug 'prabirshrestha/asyncomplete-tscompletejob.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'


call plug#end()

syntax on
set ignorecase
set smartcase
set hidden
set number
set nobackup
set nospell
set nowritebackup
set smarttab
set cindent
set nowrap
set tabstop=2
set noswapfile
set hlsearch
set shiftwidth=2
set expandtab


au FocusLost * silent! wa

let mapleader=" "

imap jj <Esc>
map <leader>xx <plug>NERDCommenterToggle
nmap <S-Tab> :NERDTreeToggle<CR>
noremap <c-p> :Files <CR>

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

colorscheme janah

function LintAndSave()
  wall
  "ALEFix
  echo "saved"
endfunction

nmap <leader>l :call LintAndSave() <cr>

function EscActions() 
  call feedkeys( ":nohlsearch\<CR>" )
  wall
  lclose
  echo "Saved"
endfunction

nnoremap <Esc><Esc> :call EscActions() <cr>

set autowriteall

let g:fzf_layout = { 'window': { 'width': 1, 'height': 1 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4"

let g:fzf_preview_window = 'right:60%'
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'options': ['--preview', 'COLORTERM=truecolor bat -p --color  always {}']}, <bang>0)

function! s:getVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)

    if len(lines) == 0
        return ""
    endif

    let lines[-1] = lines[-1][:column_end - (&selection == "inclusive" ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]

    return join(lines, "\n")
endfunction

vnoremap <silent><leader>f <Esc>:Ag <C-R>=<SID>getVisualSelection()<CR><CR>
autocmd BufNewFile,BufRead .eslintrc set syntax=json
autocmd BufNewFile,BufRead *.js set syntax=typescriptreact

set laststatus=2

set statusline=
set statusline+=%f
set statusline+=\ %=%{fugitive#head()}
set statusline+=\ [line\ %l\/%L]          

let g:ale_fixers = {
 \ 'typescript': ['eslint'],
 \ 'javascript': ['eslint']
 \ }

let g:ale_disable_lsp = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_fix_on_save = 1
let g:ale_fixers = ['eslint']

autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
highlight ALEError ctermbg=none gui=underline guisp=red

" Progress bar start
func! STL()
  let stl = '%f [%{(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")}%M%R%H%W] %y [%l/%L,%v] [%p%%]'
  let barWidth = &columns - 65 " <-- wild guess
  let barWidth = barWidth < 3 ? 3 : barWidth

  if line('$') > 1
    let progress = (line('.')-1) * (barWidth-1) / (line('$')-1)
  else
    let progress = barWidth/2
  endif

  " line + vcol + %
  let pad = strlen(line('$'))-strlen(line('.')) + 3 - strlen(virtcol('.')) + 3 - strlen(line('.')*100/line('$'))
  let bar = repeat(' ',pad).' [%1*%'.barWidth.'.'.barWidth.'('
        \.repeat('-',progress )
        \.'%2*0%1*'
        \.repeat('-',barWidth - progress - 1).'%0*%)%<]'

  return stl.bar
endfun

hi def link User1 DiffAdd
hi def link User2 DiffDelete
set stl=%!STL()

" Progress bar end

" start lsp
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" end lsp

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

nmap <Tab><Tab> :Buffers<CR>


call asyncomplete#register_source(asyncomplete#sources#tscompletejob#get_source_options({
    \ 'name': 'tscompletejob',
    \ 'allowlist': ['typescript'],
    \ 'completor': function('asyncomplete#sources#tscompletejob#completor'),
    \ }))

imap <c-space> <Plug>(asyncomplete_force_refresh)

