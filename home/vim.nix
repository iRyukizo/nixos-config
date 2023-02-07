{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf optional;
  inherit (lib.strings) optionalString;
  inherit (pkgs) fetchFromGitHub vimUtils;
  inherit (vimUtils) buildVimPlugin;

  cfg = config.my.home.vim;

  customPlugins = {
    ryuki-snippets = buildVimPlugin {
      name = "ryuki-snippets";
      src = fetchFromGitHub {
        owner = "iRyukizo";
        repo = "snippets";
        rev = "7ce071c554c56e4f619bc74a26fe8057cf34940b";
        sha256 = "2soBRVsKAf/11SMsm6TiALTLJM+VhUdbDL5FfDr2fYI=";
      };
    };
    tiger-syntax = buildVimPlugin {
      name = "tiger-syntax";
      src = fetchFromGitHub {
        owner = "iRyukizo";
        repo = "tiger-syntax";
        rev = "c7304360d9e2914eea19bb9a3b7805a7ab171a6d";
        sha256 = "IWdEYadkWOKtuE+dueV9qSbXWGE5K/d6rkMNkKvZXZU=";
      };
    };
  };
in
{
  options.my.home.vim = {
    enable = mkEnableOption "Home vim configuration";
    clangFormatSupport = mkEnableOption "Home vim-clang-format support" // { default = true; };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [] ++ optional cfg.clangFormatSupport pkgs.clang-tools;

    programs.vim = {
      enable = true;
      packageConfigurable = pkgs.vim_configurable.override {
        pythonSupport = true;
        perlSupport = true;
      };
      plugins = with pkgs.vimPlugins // customPlugins; [
        nerdtree
        nord-vim
        ryuki-snippets
        tiger-syntax
        UltiSnips
        vim-airline
        vim-airline-themes
        vim-gitgutter
        vim-go
        vim-nix
        vim-operator-user
        vim-snippets
      ] ++ optional cfg.clangFormatSupport pkgs.vimPlugins.vim-clang-format;
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
        set hlsearch
        set list
        set ruler

        set tabstop=8
        set shiftwidth=4
        set softtabstop=4

        scriptencoding utf-8
        set encoding=utf8

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
        let g:airline#extensions#whitespace#show_message = 0
        set laststatus=1

        " Weird bug where plugins are not loaded correctly, obliged to manually
        " update the `runtimepath`, must create an issue on home-manager.
        set runtimepath^=${pkgs.vimPlugins.vim-airline}
        let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])

        set guifont=MesloLGL\ Nerd\ Font\ 10

        " toggle NerdTree
        map <C-n> :NERDTreeToggle <CR>

        autocmd FileType c,cpp set comments+=s0:/*,mb:**,ex:*/

        autocmd FileType go map <Leader>x :GoFmt<CR>
        autocmd FileType go map <Leader>j :GoAddTags<CR>

        " Set ultisnips triggers
        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
        let g:UltiSnipsListSnippets="<c-tab>"
        let g:snips_author="iRyukizo"

        " Don't use sensible, for some reason sensible is installed
        " TODO: figure out why there is sensible, may think because 
        " it's the default option on home-manager for plugins
        let g:loaded_sensible="no"
      '' + optionalString cfg.clangFormatSupport ''
        " Set Clang-Format
        autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
      '';
    };
  };
}
