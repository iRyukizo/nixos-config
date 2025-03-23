final: prev:
{
  vimPlugins = prev.vimPlugins // {
    ryuki-snippets = final.vimUtils.buildVimPlugin {
      name = "ryuki-snippets";
      src = final.fetchFromGitHub {
        owner = "iRyukizo";
        repo = "snippets";
        rev = "f036a16f40614e0e92ef925dcc6cb65c4fbf4765";
        sha256 = "PILoQsXHkUBnQQWsS9GSOx9WNoMotuWkReGGrktmda8=";
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
