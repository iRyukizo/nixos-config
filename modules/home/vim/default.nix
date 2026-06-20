{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf optional optionals;
  inherit (lib.strings) optionalString;
  inherit (pkgs) fetchFromGitHub vimUtils;
  inherit (vimUtils) buildVimPlugin;

  cfg = config.my.home.vim;
in
{
  options.my.home.vim = {
    enable = mkEnableOption "Home vim configuration";
    clangFormatSupport = mkEnableOption "Home vim-clang-format support" // { default = true; };
    goSupport = mkEnableOption "Home vim-go support" // { default = true; };
    ctagsSupport = mkEnableOption "Home vim ctags support" // { default = true; };
  };

  config = mkIf cfg.enable {
    my.home = {
      go.enable = mkDefault cfg.goSupport;
      ctags.enable = mkDefault cfg.ctagsSupport;
    };

    home.packages = with pkgs; [ ] ++ optional cfg.clangFormatSupport pkgs.clang-tools;

    programs.vim = {
      enable = true;
      packageConfigurable = pkgs.vim-full.override {
        pythonSupport = true;
        perlSupport = true;
      };
      plugins = with pkgs.vimPlugins; [
        nerdtree
        nord-vim
        ryuki-snippets
        tiger-syntax
        ultisnips
        vim-airline
        vim-airline-themes
        vim-commentary
        vim-gitgutter
        vim-fugitive
        vim-nix
        vim-obsession
        vim-operator-user
        vim-snippets
        vim-surround
        vim-tmux-navigator
      ] ++ optional cfg.clangFormatSupport pkgs.vimPlugins.vim-clang-format
      ++ optional cfg.goSupport pkgs.vimPlugins.vim-go
      ++ optionals cfg.ctagsSupport [
        tagbar
        vim-gutentags
        gutentags-plus
      ];
      settings = {
        number = true;
        expandtab = true;
        background = "dark";
        mouse = "a";
      };
      extraConfig = ''
        set autoindent
        set smartindent
        set smarttab
        set cc=80
        set cursorline
        set incsearch
        set hlsearch
        set list
        set ruler

        set tabstop=8
        set shiftwidth=4
        set softtabstop=4

        scriptencoding utf-8
        set encoding=utf8

        set backspace=indent,eol,start
        set listchars=tab:>-,eol:¬,trail:-

        set nobackup
        set nowb
        set noswapfile

        if has("syntax")
          syntax on
        endif

        filetype on
        filetype plugin on
        filetype indent on

        colorscheme nord
        set t_Co=256
        let g:airline_powerline_fonts = 1
        let g:airline_theme='nord'
        " let g:airline#extensions#whitespace#show_message = 0
        " let g:airline_extensions = ['wordcount', 'searchcount', 'obsession', 'tabline']
        let g:airline#extensions#whitespace#enabled = 0
        let g:airline#extensions#obsession#enabled = 1
        let g:airline#extensions#branch#enabled = 0
        set laststatus=1

        " Fix visual colors
        if (has("termguicolors"))
          set termguicolors
          hi Normal guibg=NONE ctermbg=NONE
        endif

        " Weird bug where plugins are not loaded correctly, obliged to manually
        " update the `runtimepath`, must create an issue on home-manager.
        set runtimepath^=${pkgs.vimPlugins.vim-airline}
        let g:airline#extensions#obsession#indicator_text = ''
        let g:airline_section_z = airline#section#create(['%{airline#util#wrap(airline#extensions#obsession#get_status(),0)}', "\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])

        set guifont=MesloLGL\ Nerd\ Font\ 10

        " toggle NerdTree
        map <C-n> :NERDTreeToggle <CR>

        autocmd FileType c,cpp set comments+=s0:/*,mb:**,ex:*/

        " Set ultisnips triggers
        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
        let g:UltiSnipsListSnippets="<c-tab>"
        let g:snips_author="Hugo Moreau"

        " Don't use sensible, for some reason sensible is installed
        " TODO: figure out why there is sensible, may think because 
        " it's the default option on home-manager for plugins
        let g:loaded_sensible="no"
      '' + optionalString cfg.clangFormatSupport ''
        " Set Clang-Format
        autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
      '' + optionalString cfg.goSupport ''
        autocmd FileType go map <Leader>x :GoFmt<CR>
        autocmd FileType go map <Leader>j :GoAddTags<CR>
      '' + optionalString cfg.ctagsSupport ''
        set tags=./tags;/

        let g:tagbar_position = 'leftabove vertical'
        nmap <C-a> :TagbarToggle<CR>

        let g:gutentags_modules = ['ctags', 'gtags_cscope']
        let g:gutentags_project_root = ['.root', '.git', '.svn']
        let g:gutentags_cache_dir = expand('~/.cache/tags')
        let g:gutentags_plus_switch = 1

        function! MyGutentagsRootFinder(path) abort
          let l:dir = fnamemodify(a:path, ':p:h')

          while l:dir !=# '/' && l:dir !=# ''''''
            if filereadable(l:dir . '/.root')
              return l:dir
            endif

            let l:dir = fnamemodify(l:dir, ':h')
          endwhile

          return gutentags#default_get_project_root(a:path)
        endfunction
        let g:gutentags_project_root_finder = 'MyGutentagsRootFinder'

        nnoremap <C-W><C-[> :execute 'vert stag ' . expand('<cword>')<CR>
        nnoremap <C-W>[ :execute 'vert stag ' . expand('<cword>')<CR>
        nnoremap g[ :execute 'vert stselect ' . expand('<cword>')<CR>
        nnoremap <C-W>{ :execute 'ptselect ' . expand('<cword>')<CR>
      '';
    };
  };
}
