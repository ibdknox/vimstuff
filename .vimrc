filetype plugin on
filetype indent on

"runtime! syntax/redox.vim

" , as the leader character instead of \
let mapleader = ","

set background=dark
colorscheme mine
syntax enable
set t_Co=256
set backspace=eol,start,indent
set whichwrap=h,l,~,[,]
set incsearch
set ruler
set autowrite
set backspace=2
set laststatus=2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set showmode
set showcmd
set showmatch
set t_vb=
set wildchar=<TAB>
set scrolloff=4
set updatecount=50
set nowrap
set enc=UTF-8
set cursorline
set fo-=tc
set go-=T
set ignorecase
set smartcase
set expandtab

" smart indenting
set cindent
set formatoptions=tcqor
set cino=:0,g0,+0,:0
set nolist

"
" Per-system clipboard settings
"
if has("mac")
    vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
    nmap <C-v> :call setreg("\"",system("pbpaste"))<CR>p
elseif has("msdos")
    " msdos {{{
    " backspace in Visual mode deletes selection
    vnoremap <BS> d
 
    " CTRL-X and SHIFT-Del are Cut
    vnoremap <C-X> "+x
    vnoremap <S-Del> "+x
 
    " CTRL-C and CTRL-Insert are Copy
    vnoremap <C-C> "+y
    vnoremap <C-Insert> "+y
 
    " CTRL-V and SHIFT-Insert are Paste
    map <C-V>    "+gP
    map <S-Insert>    "+gP
 
    cmap <C-V>    <C-R>+
    cmap <S-Insert>    <C-R>+
 
    " Pasting blockwise and linewise selections is not possible in Insert and
    " Visual mode without the +virtualedit feature. They are pasted as if they
    " were characterwise instead.
    " Uses the paste.vim autoload script.
 
    exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
    
    " Use CTRL-Q to do what CTRL-V used to do
    noremap <C-Q>    <C-V>
    " }}} msdos
endif


" Don't keep around a permanent backup, but do keep around the temporary
" " backups while a file is being edited (they get deleted on save/exit)
set nobackup
set writebackup

" When wordwrap is on, don't break in the middle of words
set linebreak
set showbreak=+

" list trailing spaces as asterisks
set listchars=tab:>-,trail:*,eol:$

" To get rid of the highlights
nmap <silent> <leader>n :silent :nohlsearch<CR>

" Opening new files
if has("unix")
     map <leader>e :tabe <C-R>=expand("%:p:h") . "/" <CR>
else
	 map <leader>e :tabe <C-R>=expand("%:p:h") . "\\" <CR>
endif
          
" For NERD tree
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" ,s to turn on/off show whitespace
nmap <silent> <leader>s :set nolist!<CR>

map <leader>b ,be


"Nicer filename/command completion with tab
set wildmenu
set wildmode=list:longest

"key mappings

    "make tab work with indentation
    vnoremap <C-T> >
    vnoremap <C-D> <LT>
    nnoremap <Tab> >>
    nnoremap <S-Tab> <lt><lt>

    "change backspace to be kill word
    imap <D-BS> <C-W>

    "change space to be page down and backspace to be page up
    nnoremap <Space> <C-D>
    nnoremap <BS> <C-U>

    "change brackets to auto insert
    "imap { {}<ESC>i
    "imap ( ()<ESC>i
    "imap [ []<ESC>i

    "remap movement keys
    nmap j gj
    nmap k gk
    nmap 0 ^
    nmap - $

    "remap shift tab to be omni-complete
    inoremap <S-TAB> <C-X><C-O>

    "remap gw to goto window
    nmap gw <C-W>w
   
    "spell checking mappings
    nmap <leader>ger :set spell spelllang=de<CR>
    nmap <leader>eng :set spell spelllang=en_us<CR>

    "git mappings
    nmap ,go :!git checkout
    nmap ,gc :!git commit -a -s<CR>   
    nmap ,gs :!git status<CR>
    nmap ,ga :!git add .<CR>
    nmap ,gi :!git init<CR>
   
    inoremap ^ <ESC>bywi<LT><ESC>ea><LT>/<ESC>pa><ESC>bba

	"make enter inset a new line
	nmap <CR> o<ESC>
"functions

function! Find(type, name)
    let s:filetype = 'app/controllers'
    if(a:type == "c")
        let s:filetype = 'app/controllers'
    elseif(a:type == 'm')
        let s:filetype = 'app/models'
    elseif(a:type == 'v')
        let s:filetype = 'app/views'
    elseif(a:type == 'p')
        let s:filetype = 'app/views/_partials'
    elseif(a:type == 'l')
        let s:filetype = 'app/views/_layouts'
    elseif(a:type == 'css')
        let s:filetype = 'public/_css'
    elseif(a:type == 'js')
        let s:filetype = 'public/_js'
    elseif(a:type == 'val')
        execute ':w'
        execute ':e app/support/validator.php'
        return
    elseif(a:type == 'priv')
        execute ':w'
        execute ':e app/support/privileges.php'
        return
    endif
  let l:list=system("find ".s:filetype." -name '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif

  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")

    if strlen(l:input)==0
      return
    endif

    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif

    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif

    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif

  let l:line=substitute(l:line, "^[^\t]*\t", "", "")
  execute ":e ".l:line
endfunction

function! Rxget(type, name)
    call Find(a:type, a:name.'*')
endfunction
command! -nargs=+ -complete=file Rxget :call Rxget(<f-args>)

map gr <esc>:Rxget

function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
:inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

function! Komment()
  if getline(".") =~ '\/\/'
    let hls=@/
    s/^\/\///
    let @/=hls
  else
    let hls=@/
    s/^/\/\//
    let @/=hls
  endif
endfunction
map ,/ :call Komment()<CR>

