{
  config,
  pkgs,
  ...
}: let
  libt = import ./lib {inherit pkgs;};
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
    ./postgres.nix
    ./autosleep.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "mvxmt"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.miaf = {
    isNormalUser = true;
    description = "Mia";
    extraGroups = ["networkmanager" "wheel" "docker"];
    openssh.authorizedKeys.keyFiles = [
      (libt.fetchGithubKeys {
        username = "Plixelated";
        hash = "sha256-ff4A0dwzoXgoYlJiDIRJ0/tz2CdG/RtNVNA6xWiV6Fg=";
      })
    ];
  };

  users.users.kiki = {
    isNormalUser = true;
    description = "Michael";
    extraGroups = ["networkmanager" "wheel" "docker"];
    openssh.authorizedKeys.keyFiles = [
      (libt.fetchGithubKeys {
        username = "viewtifultiger";
        hash = "sha256-4pBX5df+aDZvaPU872FNP4cdjH3t69D+0X4D4vXXTZc=";
      })
    ];
  };

  users.users.valmm = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Valerie";
    extraGroups = ["networkmanager" "wheel" "docker"];
    openssh.authorizedKeys.keyFiles = [
      (libt.fetchGithubKeys {
        username = "valmmun";
        hash = "sha256-LlW/uj3FkJ76RGdCP+H/abH+vJSWq/5OboBy9erNNew=";
      })
    ];
  };

  users.users.ninjawarrior1337 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Tyler";
    extraGroups = ["networkmanager" "wheel" "docker"];
    openssh.authorizedKeys.keyFiles = [
      (libt.fetchGithubKeys {
        username = "ninjawarrior1337";
        hash = "sha256-PqaM+mjJc5TC3EN5AhP2uStsV5MhOqbPazbj1iET/JM=";
      })
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    shells = with pkgs; [
      zsh
    ];
  };

  environment.systemPackages = with pkgs; [
    starship
    btop
    htop
    bwm_ng
    curl
    jq
    wget
    just
    fastfetch
    zip
    xz
    unzip
    file
    zstd
    iftop
    iotop
    python3
    git
    tmux
    mosh
    nethogs
    lsof
    micro
    iperf3
    dive
    ncdu
    nvtopPackages.full
    distrobox
    duf
    dua
    (pkgs.writeShellScriptBin "nixos-distro-sync" ''
      sudo nixos-rebuild --flake github:mvxmt/server#mvxmt switch --refresh
    '')
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.git.enable = true;
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "kubectl"
        "docker"
      ];
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  programs.nix-ld.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  };
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    11434
    3000
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
