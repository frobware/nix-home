{ pkgs, ... }:

{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Andrew McDermott";
    userEmail = "aim@frobware.com";
    lfs.enable = true;
  };

  programs.git.extraConfig = {
    github = {
      user = "frobware";
    };

    # "protocol \"keybase\"" = {
    #   allow = "always";
    # };
  };

  home.packages = with pkgs; [
    git-crypt
    gitAndTools.gh
    gitAndTools.hub
    gitAndTools.delta
  ];
}
