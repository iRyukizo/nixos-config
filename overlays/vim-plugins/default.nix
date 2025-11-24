final: prev:
{
  vimPlugins = prev.vimPlugins // {
    ryuki-snippets = final.vimUtils.buildVimPlugin {
      name = "ryuki-snippets";
      src = final.fetchFromGitHub {
        owner = "iRyukizo";
        repo = "snippets";
        rev = "5b8310600456a5cc4729743a47da942d6830e454";
        sha256 = "b4jP6se/H/K53x7VTeM0GTBD6D/Du662mJcM++U6eAE=";
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
  };
}
