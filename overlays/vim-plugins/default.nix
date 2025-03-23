final: prev:
{
  vimPlugins = prev.vimPlugins // {
    ryuki-snippets = final.vimUtils.buildVimPlugin {
      name = "ryuki-snippets";
      src = final.fetchFromGitHub {
        owner = "iRyukizo";
        repo = "snippets";
        rev = "4371d313978f337397b17ccef462a2d4cf4bd603";
        sha256 = "4Q6Sg4ooIdXHN0aGFXdbzwxg7XmbijN3KYotlipPzh8=";
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
