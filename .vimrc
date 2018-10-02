" https://github.com/h-east/dotfiles_simple/blob/master/.vimrc より
" Vim8用サンプル vimrcを改変
"


"文字コードをUFT-8に設定
set fenc=utf-8
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される

" 推奨設定の読み込み (:h defaults.vim) 推奨設定が見つからねぇのでオフにしておく
"unlet! skip_defaults_vim
"source $VIMRUNTIME/defaults.vim

"===============================================================================
" 設定の追加はこの行以降でおこなうこと！
" 分からないオプション名は先頭に ' を付けてhelpしましょう。例:
" :h 'helplang

"packadd! vimdoc-ja                " 日本語help の読み込み
"set helplang=ja,en                " help言語の設定

set scrolloff=0
set laststatus=2                  " 常にステータス行を表示する
"set cmdheight=2                   " hit-enter回数を減らすのが目的
if !has('gui_running')            " gvimではない？ (== 端末)
  set ttimeoutlen=0               " モード変更時の表示更新を最速化
endif
set nofixendofline                " Windowsのエディタの人達に嫌われない設定
set ambiwidth=double              " ○, △, □等の文字幅をASCII文字の倍にする
set directory-=.                  " swapファイルはローカル作成がトラブル少なめ
set formatoptions+=mM             " 日本語の途中でも折り返す
let &grepprg="grep -rnIH --exclude=.git --exclude-dir=.hg --exclude-dir=.svn --exclude=tags"
let loaded_matchparen = 1         " カーソルが括弧上にあっても括弧ペアをハイライトさせない

 " 入力中のコマンドをステータスに表示する
set showcmd
" " 編集中のファイルが変更されたら自動で読み直す
set autoread

syntax enable


" " 検索系
" " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" " 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" " 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" " 検索時に最後まで行ったら最初に戻る
set wrapscan
" " 検索語をハイライト表示
set hlsearch
" " ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" :grep 等でquickfixウィンドウを開く (:lgrep 等でlocationlistウィンドウを開く)
"augroup qf_win
"  autocmd!
"  autocmd QuickfixCmdPost [^l]* copen
"  autocmd QuickfixCmdPost l* lopen
"augroup END

" マウスの中央ボタンクリックによるクリップボードペースト動作を抑制する
noremap <MiddleMouse> <Nop>
noremap! <MiddleMouse> <Nop>
noremap <2-MiddleMouse> <Nop>
noremap! <2-MiddleMouse> <Nop>
noremap <3-MiddleMouse> <Nop>
noremap! <3-MiddleMouse> <Nop>
noremap <4-MiddleMouse> <Nop>
noremap! <4-MiddleMouse> <Nop>

"-------------------------------------------------------------------------------
"見た目系
" " 行番号を表示
set number
" " 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" " インデントはスマートインデント
set smartindent
" " ビープ音を可視化
" " カーソルが重い原因はこいつだった
" set visualbell
" " 括弧入力時の対応する括弧を表示
set showmatch

" " Tab系
" " 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" " Tab文字を半角スペースにする
set expandtab
" " 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" " 行頭でのTab文字の表示幅
set shiftwidth=4
"-------------------------------------------------------------------------------
" ステータスライン設定
" let &statusline = "%<%f %m%r%h%w[%{&ff}][%{(&fenc!=''?&fenc:&enc).(&bomb?':bom':'')}] "
" if has('iconv')
"   let &statusline .= "0x%{FencB()}"

"   function! FencB()
"     let c = matchstr(getline('.'), '.', col('.') - 1)
"     if c != ''
"       let c = iconv(c, &enc, &fenc)
"       return s:Byte2hex(s:Str2byte(c))
"     else
"       return '0'
"     endif
"   endfunction
"   function! s:Str2byte(str)
"     return map(range(len(a:str)), 'char2nr(a:str[v:val])')
"   endfunction
"   function! s:Byte2hex(bytes)
"     return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
"   endfunction
" else
"   let &statusline .= "0x%B"
" endif
" let &statusline .= "%=%l,%c%V %P"

"-------------------------------------------------------------------------------
" ファイルエンコーディング検出設定
let &fileencoding = &encoding
if has('iconv')
  if &encoding ==# 'utf-8'
    let &fileencodings = 'iso-2022-jp,euc-jp,cp932,' . &fileencodings
  else
    let &fileencodings .= ',iso-2022-jp,utf-8,ucs-2le,ucs-2,euc-jp'
  endif
endif
" 日本語を含まないファイルのエンコーディングは encoding と同じにする
if has('autocmd')
  function! AU_ReSetting_Fenc()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding = &encoding
    endif
  endfunction
  augroup resetting_fenc
    autocmd!
    autocmd BufReadPost * call AU_ReSetting_Fenc()
  augroup END
endif

"-------------------------------------------------------------------------------
" カラースキームの設定
set background=dark
"colorscheme solarized

try
  silent hi CursorIM
catch /E411/
  " CursorIM (IME ON中のカーソル色)が定義されていなければ、紫に設定
  hi CursorIM ctermfg=16 ctermbg=127 guifg=#000000 guibg=#af00af
endtry

" vim:set et ts=2 sw=0:


" setting
" 参考https://qiita.com/morikooooo/items/9fd41bcd8d1ce9170301
" set fileformats=unix,mac,dos " 改行コードの自動判別. 左側が優先される
" set hidden


" " 見た目系
" " 折り返し時に表示行単位での移動できるようにする
" nnoremap j gj
" nnoremap k gk
" nnoremap <down> gj
" nnoremap <up> gk






" 自分の設定
" emacs keybind
inoremap <silent> <C-b> <Left>
inoremap <silent> <C-f> <Right>
inoremap <silent> <C-p> <Up>
inoremap <silent> <C-n> <Down>
inoremap <silent> <C-a> <ESC>I
inoremap <silent> <C-e> <End>
inoremap <silent> <C-d> <Del>
" escape遠い
"inoremap <silent> <C-m> <ESC>
" 保存などを爆速で行いたい
nnoremap <Space>w :<C-u>write<Cr>
nnoremap <Space>q :<C-u>quit<Cr>

"---------------------------------------------------------------------------
"vim-plug

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
" NEARDTreeのインストール
Plug 'scrooloose/nerdtree'
" lightlineのインストール
Plug 'itchyny/lightline.vim'
" Initialize plugin system
call plug#end()