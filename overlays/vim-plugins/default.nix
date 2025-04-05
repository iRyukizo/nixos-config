final: prev:
{
  vimPlugins = prev.vimPlugins // {
    ryuki-snippets = final.vimUtils.buildVimPlugin {
      name = "ryuki-snippets";
      src = final.fetchFromGitHub {
        owner = "iRyukizo";
        repo = "snippets";
        rev = "b7103bf46ebe7cb51a45c2ba72fd49209c4391a8";
        sha256 = "btsmJ/0/nGe4G0Uddco/kUwPyHzcoYwdHEOsgfLjtFs=";
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
