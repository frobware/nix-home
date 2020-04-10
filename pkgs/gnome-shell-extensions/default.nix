{ pkgs, ... }: {
  home.file.".local/share/gnome-shell/extensions/tilingnome@rliang.github.com".source = builtins.fetchGit {
    url = "https://github.com/rliang/gnome-shell-extension-tilingnome.git";
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell".enabled-extensions = ["tilingnome@rliang.github.com"];
    };
  };
}
