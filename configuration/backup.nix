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
  # boot.loader.efi.canTouchEfiVariables = true;
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
    theme = "nixos";  # or whatever theme name you want
  };
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
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
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
  users.users.anshumaan = {
    isNormalUser = true;
    description = "Anshumaan Mishra";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    # packages = with pkgs; [
    #  kdePackages.kate
    #  thunderbird
    # ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    # Essentials
    pkgs.neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.wget
    (pkgs.lshw.override { withGUI = true; })
    pkgs.fish
    pkgs.kitty
    pkgs.fastfetch
    pkgs.ntfs3g
    pkgs.unzip
    pkgs.xclip
    pkgs.wl-clipboard-rs
    pkgs.input-remapper
    pkgs.libinput
    inputs.inputactions.packages.${pkgs.system}.inputactions-kwin
    pkgs.kdePackages.qtbase
    pkgs.bat
    
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
    pkgs.darkly
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

  # Enable Docker service
  # services.docker.enable = true;
  environment.variables.LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/current-system/sw/lib";
  virtualisation.docker = {
    enable = true;
    # Set up resource limits
    daemon.settings = {
      experimental = true;
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ]; 
    };
  };
  
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  # Allow your user to run Docker without sudo
  systemd.services.warp-svc = {
    description = "Clouflare Warp Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
      Restart = "always";
    };
  };

  # Define input-remapper as a user service
  systemd.user.services.input-remapper = {
    description = "Input Remapper (user service)";
    serviceConfig = {
      ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --command autoload";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };

  # Touchpad Gesture Setup
  services.udev.extraRules = ''
    # Touchpad access
    ENV{ID_INPUT_TOUCHPAD}=="1", TAG+="uaccess"

    # Prevent USB autosuspend for Bluetooth
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/autosuspend}="-1"
  '';


  services.libinput = {
    enable = true;
    touchpad = {
      # enable = true;
      # tapToClick = true;       # already works
      naturalScrolling = true;  # optional
      clickMethod = "clickfinger"; # options: "none", "clickfinger", "buttonareas"
    };
  };

  services.blueman.enable = true; # nice GUI + manages reconnections

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;  # enables newer features like battery level + codec switching
    };
  };
  services.pipewire.wireplumber.extraConfig."10-bluez" = {
    "monitor.bluez.rules" = [
      { matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.codecs" = [ "aac" "ldac" "aptx" "aptx_hd" "sbc" ];
          };
        };
      }
    ];
  };





  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # services.flatpak.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
   # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  
  services.xserver.videoDrivers = [
    # "modesetting"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;

    # Power management options
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Open-source module? (usually false for NVIDIA)
    open = false;

    # Enable nvidia-settings menu
    nvidiaSettings = true;
  };


  # nixpkgs.config.cudaSupport = true;	
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Replace the offload with this line to use nvidia always
    # sync.enable = true;
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  };
 
  # nix.settings.substituters = [
  #   "https://cache.nixos.org/"
  #   "https://cuda-maintainers.cachix.org"
  # ];
  # nix.settings.trusted-public-keys = [
  #   "cuda-maintainers.cachix.org-1:5ZmvfHRxlWcYw4XsyS4fp2EBYV/8sHdNvz0Z7mx6bYg="
  # ];

}
