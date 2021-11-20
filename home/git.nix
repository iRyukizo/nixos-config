{ ... }:

{
  programs.git = {
    enable = true;

    userEmail = "hugo.moreau@epita.fr";
    userName = "Hugo Moreau";

    extraConfig = {
      commit = { verbose = true; };
      color = { ui = true; };
      core = {
        editor = "vim";
        pager = "less -iXFR --mouse";
      };
      pager = { branch = false; };
      init = { defaultBranch = "master"; };
      push = { default = "simple"; };
      pull = { rebase = true; };
    };

    includes = [
      {
        condition = "gitdir:~/EPITA/LRDE";
        contents = {
          user = {
            email = "hmoreau@lrde.epita.fr";
          };
        };
      }
      {
        condition = "gitdir:~/EPITA/ASSISTANTS";
        contents = {
          init = {
            defaultBranch = "main";
          };
        };
      }
    ];
  };
}
