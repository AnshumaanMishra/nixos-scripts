# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, system, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./flakes/hardware-configuration.nix
    ];

  programs.nix-ld.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/EFI/";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };
  
  boot.kernelParams = [
    "modprobe.blacklist=nouveau"
    "nvidia-drm.modeset=1"
  ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment + Hyprland.
  # services.displayManager.sddm.enable = true;
  services.displayManager.gdm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  services.desktopManager.gnome.enable = true;
  # programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Enable sound with PipeWire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # boot.kernelModules = [ "kvm" "kvm_intel" "kvm_amd" ];

  # User account
  users.users.anshumaan = {
    isNormalUser = true;
    description = "Anshumaan Mishra";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = [
    # Essentials
    pkgs.neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.wget
    (pkgs.lshw.override { withGUI = true; })
    pkgs.fish
    # pkgs.kitty
    pkgs.fastfetch
    # pkgs.ntfs3g
    pkgs.unzip
    # pkgs.xclip
    pkgs.wl-clipboard-rs
    # pkgs.input-remapper
    # pkgs.libinput
    # inputs.inputactions.packages.${pkgs.system}.inputactions-kwin
    # pkgs.kdePackages.qtbase
    # pkgs.gnome-themes-extra
    # pkgs.adwaita-icon-theme
    pkgs.bat
    # pkgs.pavucontrol
    # pkgs.pulseaudio
    # pkgs.wireplumber
    # pkgs.libnotify
    
    # neovim
    pkgs.lua54Packages.luarocks	
    pkgs.ripgrep
    pkgs.fd
    pkgs.lazygit
    pkgs.ghostscript
    pkgs.tectonic
    pkgs.mermaid-cli

    # Devtools
    pkgs.git
    pkgs.gh
    pkgs.gcc
    pkgs.gdb
    pkgs.gnumake
    pkgs.python311
    # pkgs.uv
    pkgs.jdk21_headless	
    pkgs.rust-analyzer
    pkgs.rustup
    pkgs.bun
    # pkgs.go
    # pkgs.ruby
    # pkgs.php
    # pkgs.julia
    pkgs.vscode
    pkgs.zed-editor
    pkgs.ollama
    # pkgs.qemu
    # pkgs.qemu_kvm
    # pkgs.ollama-cuda
    pkgs.rustlings
    # Utilities
    pkgs.obsidian
    pkgs.slack
    pkgs.discord
    # pkgs.input-remapper
    # pkgs.auto-cpufreq
    pkgs.cloudflared
    pkgs.cloudflare-cli
    pkgs.cloudflare-warp
    # pkgs.darkly
    pkgs.distrobox
    pkgs.podman
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.vlc

    # NVIDIA
    pkgs.nvtopPackages.nvidia
    pkgs.cudaPackages.cudatoolkit
    # pkgs.nvtopPackages.intel
    pkgs.nvidia-container-toolkit
    pkgs.intel-gpu-tools
  ];

  # environment.variables = {
  #   LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/current-system/sw/lib";
  #   GTK_THEME = "Adwaita:dark";
  #   XCURSOR_THEME = "Adwaita";
  #   XDG_CURRENT_DESKTOP = "GNOME";
  # };

  # Docker
  # virtualisation.docker = {
  #   enable = true;
  #   daemon.settings = {
  #     experimental = true;
  #     default-address-pools = [
  #       { base = "172.30.0.0/16"; size = 24; }
  #     ];
  #   };
  # };

  # Ollama
  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  # };

  # Warp daemon
  # systemd.services.warp-svc = {
  #   description = "Cloudflare Warp Daemon";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
  #     Restart = "always";
  #   };
  # };

  # Input-remapper as user service
  # systemd.user.services.input-remapper = {
  #   description = "Input Remapper (user service)";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --command autoload";
  #     Restart = "on-failure";
  #   };
  #   wantedBy = [ "default.target" ];
  # };

  # Touchpad gesture + USB autosuspend fix
  # services.udev.extraRules = ''
  #   ENV{ID_INPUT_TOUCHPAD}=="1", TAG+="uaccess"
  #   ACTION=="add", SUBSYSTEM=="usb", ATTR{power/autosuspend}="-1"
  # '';

  # services.libinput = {
  #   enable = true;
  #   touchpad = {
  #     naturalScrolling = true;
  #     clickMethod = "clickfinger";
  #     disableWhileTyping = true;
  #   };
  # };

  # Bluetooth
  # services.blueman.enable = true;

  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;
  # hardware.bluetooth.settings = {
  #   General = {
  #     Enable = "Source,Sink,Media,Socket";
  #     Experimental = true;
  #   };
  # };

  # PipeWire Bluetooth tweaks
  # services.pipewire.extraConfig.pipewire."92-bluez-hfp" = {
  #   "bluez5.codecs" = [ "sbc" "mSBC" ];
  #   "bluez5.roles"  = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
  # };

  # Prefer A2DP by default, HFP only when switched
  # services.pipewire.wireplumber.extraConfig."11-bluez-default-profile" = {
  #   "monitor.bluez.rules" = [
  #     { matches = [ { "profile" = "headset_head_unit"; } ];
  #       actions = { "quirks.profile-priority" = 10; };
  #     }
  #     { matches = [ { "profile" = "a2dp_sink"; } ];
  #       actions = { "quirks.profile-priority" = 100; };
  #     }
  #   ];
  # };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Default shell
  programs.fish.enable = true;
  # users.defaultUserShell = pkgs.fish;

  system.stateVersion = "25.05";

  # Graphics
  hardware.graphics.enable = true;
  # services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

