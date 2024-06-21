# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# possible improvements:
# Add Kanshi: https://haseebmajid.dev/posts/2023-07-25-nixos-kanshi-and-hyprland/
{
  config,
  lib,
  pkgs,
  ...
}: let
  local_cfg = builtins.fromJSON (builtins.readFile "/home/f44/dev/stuff/nix-files/config/locals.json");
  device_name = local_cfg.device_name;
  user = "f44";

  # us, de, uk, ...
  keymap = "us";

  testiblitz_s_ip = "192.168.8.104";
  testiblitz_b_ip = "192.168.8.105";
  testiblitz_n_ip = "192.168.8.242";

  neovimConfig = import ./configs/nvim/nvim.nix {pkgs = pkgs;};
  vscodeConfig = builtins.readFile ./configs/vscode/settings.json;

  keychain_timeout_time =
    if device_name == "um700"
    then "60"
    else "20";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware_configs/${device_name}.nix
    ./modules/protonvpn.nix
  ];

  boot.kernel.sysctl = {
    # Go delve can't attach to processes otherwise
    "kernel.yama.ptrace_scope" = 0;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.extraOptions = "experimental-features = nix-command flakes";

  networking.hostName = device_name; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalization properties.
  i18n.defaultLocale = "de_DE.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  security = {
    sudo = {
      extraConfig = with pkgs; ''
        Defaults:${user} timestamp_timeout=20
      '';
    };

    # https://github.com/NixOS/nixpkgs/issues/143365#issuecomment-1293871094
    pam.services.swaylock = {};
  };

  # https://www.drakerossman.com/blog/wayland-on-nixos-confusion-conquest-triumph
  # programs.sway.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Configure console keymap
  console.keyMap = keymap;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.Q
  hardware = {
    opengl.enable = true;
    pulseaudio.enable = false;
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
  };
  sound.enable = true;
  security.rtkit.enable = true;
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.blueman.enable = true;

  services.protonvpn = lib.mkIf local_cfg.vpn_enable {
    enable = true;
    interface.privateKeyFile = "/root/secrets/protonvpn";
    endpoint = {
      publicKey = local_cfg.vpn_pubkey;
      ip = local_cfg.vpn_ip;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    ${user} = {
      isNormalUser = true;
      description = "f44";
      extraGroups = ["networkmanager" "wheel" "docker" "vboxusers"];
      shell = pkgs.nushell;
    };
  };

  home-manager.users = {
    # Main user
    ${user} = {pkgs, ...}: {
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      home.packages = with pkgs; [
        joplin-desktop
        signal-desktop
        tdesktop
        vivaldi
        vivaldi-ffmpeg-codecs
        google-chrome
        fluffychat
        cmake
        gcc
        nixd
        just
        wcalc
        qrtool
        lsof
        bandwhich
        trashy
      ];

      gtk = {
        enable = true;
        # font.name = "TeX Gyre Adventor 10";
        theme = {
          name = "Juno";
          package = pkgs.juno-theme;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };

        gtk3.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };

        gtk4.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };
      };

      services = {
        swayidle = {
          enable = true;
          events = [
            {
              event = "before-sleep";
              command = "${pkgs.swaylock}/bin/swaylock -fF";
            }
            {
              event = "lock";
              command = "lock";
            }
          ];
          timeouts = [
            {
              timeout = 6;
              command = "${pkgs.swaylock}/bin/swaylock -fF";
            }
            {
              timeout = 9;
              command = "${pkgs.systemd}/bin/systemctl suspend";
            }
          ];
        };
      };

      programs = {
        atuin = {
          enable = true;
          enableNushellIntegration = true;
        };

        bash = {
          enable = true;
          historyControl = ["ignoredups" "ignorespace"];
          historyIgnore = ["ls" "cd" "exit" "code"];
        };

        obs-studio = {
          enable = true;
          plugins = [pkgs.obs-studio-plugins.wlrobs];
        };

        nushell = {
          enable = true;
          # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
          configFile.source = ./configs/nushell/config.nu;
          # for editing directly to config.nu

          extraConfig = ''
            def rebuild [] {
              cd ~/dev/stuff/nix-files/config/
              sudo nixos-rebuild switch --impure --flake .?submodules=1#${device_name}
            }

            def rebuild-dry [ --trace (-t) ] {
              cd ~/dev/stuff/nix-files/config/
              if $trace {
                sudo nixos-rebuild dry-activate --impure --flake .?submodules=1#${device_name} --show-trace
              } else {
                sudo nixos-rebuild dry-activate --impure --flake .?submodules=1#${device_name}
              }
            }

            def rebuild-upgrade [] {
              cd ~/dev/stuff/nix-files/config
              nix flake update
              sudo nixos-rebuild switch --impure --flake .?submodules=1#${device_name}
              cd -
            }

            def kill-port-process [port: string = "4040"] {
              let processes = lsof -i $":($port)" | detect columns

              if ($processes | is-not-empty)  {
                print "killing:"
                $processes | get PID | print
                $processes | get PID | into int | each { |it| kill $it }
              }
            }

            use ~/.config/nushell/nu_scripts/completions/nix/nix-completions.nu
            use ~/.config/nushell/nu_scripts/modules/docker/mod.nu
          '';

          shellAliases = {
            ports = "netstat -tulanp";
            ll = "ls -l";
            lla = "ls -la";
            mv = "mv -i";
            cp = "cp -i";
            readlink = "readlink -f";
            wifi-radio-on = "nmcli radio wifi on";
            wifi-radio-off = "nmcli radio wifi off";
            wifi-scan = "nmcli dev wifi list";
            wifi-connect = "sudo nmcli --ask dev wifi connect";
            wifi-show = "nmcli connection show";
            htop = "btm";
            c = "codium .";
            cod = "codium .";
            nv = "nvim";
            nd = "nix develop";
            ndn = "nix develop --command nu";
            ndnv = "nix develop --command nu -c 'nvim'";
            lg = "lazygit";
            calc = "wcalc";
            vivaldiollama = "vivaldi http://10.147.19.36:8080";
            vivaldifritzbox = "vivaldi http://192.168.178.1";
            qr = "qrtool encode -t terminal ";
            fzfp = "fzf --preview 'bat {}'";

            # Dev stuff
            devnixconfig = "cd ~/dev/stuff/nix-files/";

            # Dev Janostr stuff
            devjaspr = "cd ~/dev/stuff/jaspr";
            devjanostr = "cd ~/dev/janostr";
            devtodo = "cd ~/dev/stuff/todo_demo";

            # Dev Blitz stuff
            devblitz = "cd ~/dev/blitz/api/";
            devblitzmain = "cd ~/dev/blitz/api/dev";
            devblitznixosify = "cd ~/dev/blitz/api/nixosify";
            devblitzguimain = "cd ~/dev/blitz/gui/main";
            devblitzguinocompose = "cd ~/dev/blitz/gui/no-compose";
            devblitzdocs = "cd ~/dev/blitz/docs";
            devblitznix = "cd ~/dev/blitz/nixblitz";
            sshtestiblitzsmall = "sshpass -p test1234 ssh admin@${testiblitz_s_ip}";
            sshtestiblitzbig = "sshpass -p test1234 ssh admin@${testiblitz_b_ip}";
            sshtestiblitznix = "ssh admin@${testiblitz_n_ip}";
            sshollamabox = "ssh f44@10.147.19.36";
            vivalditestiblitzsmallapi = "vivaldi http://${testiblitz_s_ip}/api/latest/docs";
            vivalditestiblitzbigapi = "vivaldi http://${testiblitz_b_ip}/api/latest/docs";
            vivalditestiblitznixapi = "vivaldi http://${testiblitz_n_ip}/api/latest/docs";
            vivalditestiblitzsmallgui = "vivaldi http://${testiblitz_s_ip}";
            vivalditestiblitzbiggui = "vivaldi http://${testiblitz_b_ip}";
            vivalditestiblitznixgui = "vivaldi http://${testiblitz_n_ip}";
          };
        };

        starship = {
          enable = true;
          enableNushellIntegration = true;
          settings = {
            scan_timeout = 10;
          };
        };

        neovim = neovimConfig;

        vscode = {
          enable = true;
          package = pkgs.vscodium.fhs;
          extensions = [
            pkgs.vscode-extensions.vscodevim.vim
            pkgs.vscode-extensions.wakatime.vscode-wakatime
            pkgs.vscode-extensions.dart-code.flutter
            pkgs.vscode-extensions.rust-lang.rust-analyzer
            pkgs.vscode-extensions.vadimcn.vscode-lldb
            pkgs.vscode-extensions.yzhang.markdown-all-in-one
            pkgs.vscode-extensions.timonwong.shellcheck
            pkgs.vscode-extensions.skellock.just
            pkgs.vscode-extensions.serayuzgur.crates
            pkgs.vscode-extensions.jnoortheen.nix-ide
            pkgs.vscode-extensions.kamadorueda.alejandra
            pkgs.vscode-extensions.esbenp.prettier-vscode
            pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
            pkgs.vscode-extensions.christian-kohler.path-intellisense
            pkgs.vscode-extensions.equinusocio.vsc-material-theme
            pkgs.vscode-extensions.equinusocio.vsc-material-theme-icons
          ];
          userSettings = builtins.fromJSON vscodeConfig;
        };

        keychain = {
          enable = true;
          enableNushellIntegration = true;
          keys = ["id_ed25519"];
          extraFlags = ["--timeout ${keychain_timeout_time}"];
        };

        git = {
          enable = true;
          userName = "fusion44";
          userEmail = "some.fusion@gmail.com";
          aliases = {prettylog = "...";};
          extraConfig = {
            commit.gpgsign = true;
            gpg.format = "ssh";
            user.signingkey = "~/.ssh/id_ed25519.pub";
            core.editor = "nvim";
            color.ui = true;
            push.default = "simple";
            pull.ff = "only";
            init.defaultBranch = "main";
          };
          ignores = [".DS_Store" "*.pyc"];
          delta = {
            enable = true;
            options = {
              navigate = true;
              line-numbers = true;
              syntax-theme = "GitHub";
            };
          };
        };

        bat = {
          enable = true;
          config = {
            theme = "GitHub";
            italic-text = "always";
          };
        };

        lazygit = {
          enable = true;
        };

        yazi = {
          enable = true;
          enableNushellIntegration = true;
        };

        zellij = {
          enable = true;
        };

        zoxide = {
          enable = true;
          enableBashIntegration = true;
        };
      };

      home.stateVersion = "23.05";
      home.file = {
        ".wakatime.cfg" = lib.mkIf local_cfg.wakapi_enable {
          text = ''
            [settings]
            # Your Wakapi server URL or 'https://wakapi.dev' when using the cloud server
            api_url = ${local_cfg.wakapi_url}
            # Your Wakapi API key (get it from the web interface after having created an account)
            api_key = ${local_cfg.wakapi_api_key}
          '';
        };
        ".config/alacritty/alacritty.toml" = {
          source = ./configs/alacrity/alacritty.toml;
        };
        ".config/hypr" = {
          source = ./configs/hypr;
          recursive = true;
        };
        ".config/ranger" = {
          source = ./configs/ranger;
          recursive = true;
        };
        ".config/ranger/launch.sh" = {
          source = ./configs/ranger/scope.sh;
          executable = true;
        };
        ".config/rofi" = {
          source = ./configs/rofi;
          recursive = true;
        };
        ".config/waybar" = {
          source = ./configs/waybar;
          recursive = true;
        };
        ".config/zellij" = {
          source = ./configs/zellij;
          recursive = true;
        };
        ".config/swaylock" = {
          source = ./configs/swaylock;
          recursive = true;
        };
        ".config/wlogout" = {
          source = ./configs/wlogout;
          recursive = true;
        };
        ".config/nushell/nu_scripts/completions" = {
          source = ../external/nu_scripts/custom-completions;
          recursive = true;
        };
        ".config/nushell/nu_scripts/menus" = {
          source = ../external/nu_scripts/custom-menus;
          recursive = true;
        };
        ".config/nushell/nu_scripts/modules" = {
          source = ../external/nu_scripts/modules;
          recursive = true;
        };
        "extra-space/.keep" = {
          source = builtins.toFile "keep" "";
        };
      };
    };
  };

  services = {
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    devmon.enable = true;
    gvfs.enable = true;

    # enable a redis service for Blitz API development
    # replace with https://github.com/Mic92/nixos-shell
    redis = {
      servers."".enable = true;
    };

    # Enable syncthing to sync files between computers
    # https://nixos.wiki/wiki/Syncthing
    syncthing = {
      enable = true;
      user = user;
      configDir = "/home/${user}/.config/syncthing";
    };

    gnome = {
      # Enable gnome-keyring to store passwords.
      # E.g. allows VScode to store credentials locally after logging in to GitHub.
      gnome-keyring.enable = true;
    };

    zerotierone = lib.mkIf local_cfg.zt_enable {
      enable = true;
      joinNetworks = [local_cfg.zt_network];
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {fonts = ["FiraCode" "Hack"];})
  ];

  programs.dconf.enable = true;

  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint Electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    firefox
    pfetch # get hardware config
    git
    jq
    alacritty
    ranger
    pavucontrol
    killall
    ffmpeg
    mpv # Media player; Fork of mplayer
    youtube-dl
    libsForQt5.breeze-gtk
    gnome.adwaita-icon-theme
    gnome.seahorse # Key manager GUI application. Uses gnome-keyring
    gnomeExtensions.appindicator
    docker-compose
    gnumake
    entr # Run arbitrary commands when files change
    direnv # unclutter your .profile
    ripgrep # ripgrep recursively searches directories for a regex pattern while respecting your gitignore
    fd # A simple, fast and user-friendly alternative to 'find'
    nil # nix language server
    nixpkgs-fmt # nix lang formatter
    magic-wormhole # send files from one computer to another, securely...
    keepassxc
    unzip
    udisks
    cacert
    bottom # htop alternative
    fastgron # https://github.com/adamritter/fastgron
    fzf # fuzzy finder

    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin

    # Hyprland
    hyprpaper
    waybar
    dunst
    libnotify
    swww # wallpaper stuff
    rofi-wayland
    pywal # needed for dynamic colors in waybar
    wlogout
    wl-clipboard
    swaylock-effects
    swayidle

    # Note, this is a hack... first take a screenshot with
    # hyprshot and then annotate is with ksnip:
    # ---------------------------------------------------
    # hyprshot -m region -o /tmp -f hyprshot.png
    # ksnip /tmp/hyprshot.png
    hyprshot # screenshot utility
    ksnip # screenshot tool to annotate
  ];

  # this creates file /etc/currentSystemPackages.txt with list of all
  # packages with their versions
  environment.etc."currentSystemPackages.txt".text = let
    sysPackages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    homePackages = builtins.map (p: "${p.name}") config.home-manager.users.${user}.home.packages;
    # TODO: implement NeoVim plugins somehow.
    nvimPlugins = config.home-manager.users.${user}.home.packages.neovim.plugins;
    packages = pkgs.lib.lists.unique sysPackages ++ homePackages;
    sortedUnique = builtins.sort builtins.lessThan packages;
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [
    22000 # Syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    22000 # Syncthing
    21027 # Syncthing
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  # system.autoUpgrade.enable = true;

  # garbage collect
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "delete-older-than 7d";
    };
  };
}
