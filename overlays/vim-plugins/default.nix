final: prev:
{
  vimPlugins = prev.vimPlugins // {
    ryuki-snippets = final.vimUtils.buildVimPlugin {
      name = "ryuki-snippets";
      src = final.fetchFromGitHub {
        owner = "iRyukizo";
        repo = "snippets";
        rev = "5b8310600456a5cc4729743a47da942d6830e454";
        sha256 = "sha256-UP9DcI4nNLsNQb7bXYVJrgWK9lznws3pPvU5hOtu8ZU=";
      };
    };
    tiger-syntax = final.vimUtils.buildVimPlugin {
      name = "tiger-syntax";
      src = final.fetchFromGitHub {
        owner = "iRyukizo";
        repo = "tiger-syntax";
        rev = "c7304360d9e2914eea19bb9a3b7805a7ab171a6d";
        sha256 = "IWdEYadkWOKtuE+dueV9qSbXWGE5K/d6rkMNkKvZXZU=";
      };
    };
    gutentags-plus = final.vimUtils.buildVimPlugin {
      name = "gutentags_plus";
      src = final.fetchFromGitHub {
        owner = "skywind3000";
        repo = "gutentags_plus";
        rev = "a0157ca0092a21f0947917945506fde3859c9cd2";
        hash = "sha256-kUis49tTpJJ04F4MxQYIQyr6gfxAsWk3lnNrXB6K+yc=";
      };
    };
  };
}
