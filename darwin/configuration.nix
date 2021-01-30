{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nix-darwin>
    ../config/go.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.allowUnfree = true;

  # https://github.com/LnL7/nix-darwin/issues/165#issuecomment-749682749
  environment.etc = {
    "sudoers.d/10-nix-commands".text = ''
      %admin ALL=(ALL:ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild, \
                                     /run/current-system/sw/bin/nix*, \
                                     /run/current-system/sw/bin/ln, \
                                     /nix/store/*/activate, \
                                     /bin/launchctl
    '';
  };

  environment.systemPackages = [
    pkgs.home-manager
    pkgs.ncdu
    pkgs.ag
    #pkgs.emacs
    pkgs.vim
    pkgs.wget
    # pkgs.home-manager
    pkgs.gnupg
    pkgs.direnv
    pkgs.pinentry
    pkgs.alacritty
    pkgs.pinentry_mac
    # pkgs.pinentry

    pkgs.autoconf
    pkgs.watchexec

    pkgs.awscli2
    pkgs.google-cloud-sdk
    pkgs.azure-cli
    pkgs.pass

    # pkgs.go
    # pkgs.goimports
    # pkgs.gopls
    # pkgs.jq
    # pkgs.yq

    pkgs.mtr

    pkgs.htop
    pkgs.tmux

    pkgs.tree
    pkgs.perl

    pkgs.gnuplot

    pkgs.git-crypt
    pkgs.mercurial

    # pkgs.rust
    # pkgs.cargo
    pkgs.wireshark
    pkgs.termshark


    pkgs.watch

    pkgs.netcat
    pkgs.pv

    pkgs.aspell
    pkgs.aspellDicts.en
    pkgs.aspellDicts.en-computers
    pkgs.aspellDicts.en-science
    pkgs.hunspell
    pkgs.hunspellDicts.en-gb-ise
    pkgs.hunspellDicts.en-us
    pkgs.ispell
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  #services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # services.gpg-agent = {
    #   enable = true;
    #   enableSshSupport = true;
    #   grabKeyboardAndMouse = false;
    #   pinentryFlavor = "tty";
    #   extraConfig = ''
    #     allow-loopback-pinentry
    #     allow-emacs-pinentry
    #   '';
    # };

    nix.useDaemon = false;

    programs.gnupg.agent.enable = true;
    programs.gnupg.agent.enableSSHSupport = true;

    system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
    system.defaults.NSGlobalDomain.KeyRepeat = 1;
    system.defaults.NSGlobalDomain.NSWindowResizeTime = "0.001";
    system.defaults.dock.orientation = "right";

    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToControl = true;

    documentation.enable = true;
    documentation.man.enable = true;
    documentation.info.enable = true;
    documentation.doc.enable = true;

    home-manager.users.amcdermo = { pkgs, ... }: {
      programs.direnv.enable = true;

      programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        oh-my-zsh.enable = true;

        plugins = [
          # {
          #   name = "pi-theme";
          #   file = "pi.zsh-theme";
          #   src = pkgs.fetchFromGitHub {
          #     owner = "tobyjamesthomas";
          #     repo = "pi";
          #     rev = "96778f903b79212ac87f706cfc345dd07ea8dc85";
          #     sha256 = "0zjj1pihql5cydj1fiyjlm3163s9zdc63rzypkzmidv88c2kjr1z";
          #   };
          # }
        ];
      };
    };
}
