# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, system, ... }:
with pkgs; let
  patchDesktop = pkg: appName: from: to: lib.hiPrio (
    pkgs.runCommand "$patched-desktop-entry-for-${appName}" {} ''
      ${coreutils}/bin/mkdir -p $out/share/applications
      ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      '');
  GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader = {
    timeout=5;
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };
  boot.extraModprobeConfig = ''
    options usbcore autosuspend=-1
  '';
  
  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };
  
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
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.kernelModules = [ "kvm" "kvm_intel"];

  # Enable fractional scaling
  environment.sessionVariables = {
    # Required for Wayland fractional scaling
    "WLR_DRM_NO_MODIFIERS" = "1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs.neovim
    pkgs.wget
    (pkgs.lshw.override { withGUI = true; })
    pkgs.fish
    pkgs.kitty
    pkgs.ollama-cuda
    pkgs.fastfetch
    pkgs.ntfs3g
    pkgs.unzip
    pkgs.xclip
    pkgs.wl-clipboard-rs
    pkgs.libinput
    # inputs.inputactions.packages.${pkgs.system}.inputactions-kwin
    # pkgs.kdePackages.qtbase
    # pkgs.gnome-themes-extra
    # pkgs.adwaita-icon-theme
    pkgs.bat
    pkgs.croc
    pkgs.gnome-tweaks
    pkgs.appimage-run
    # pkgs.pavucontrol
    # pkgs.pulseaudio
    # pkgs.wireplumber
    # pkgs.libnotify
    pkgs.zotero
    
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
    # pkgs.bun
    # pkgs.go
    # pkgs.ruby
    # pkgs.php
    # pkgs.julia
    pkgs.vscode
    pkgs.zed-editor
    pkgs.ollama
    pkgs.ollama-cuda
    pkgs.qemu
    pkgs.qemu_kvm
    pkgs.rustlings
    # Utilities
    pkgs.obsidian
    pkgs.slack
    pkgs.discord
    pkgs.input-remapper
    # pkgs.auto-cpufreq
    pkgs.cloudflared
    pkgs.cloudflare-cli
    pkgs.cloudflare-warp
    pkgs.nodejs_24
    # pkgs.darkly
    pkgs.distrobox
    pkgs.podman
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.vlc

    # CTF
    pkgs.wireshark
    pkgs.radare2
    pkgs.binaryninja-free
    pkgs.ghidra
    pkgs.hashcat
    pkgs.nmap
    pkgs.burpsuite
    pkgs.binwalk
    pkgs.file
    pkgs.exiftool
    
    # NVIDIA
    pkgs.nvtopPackages.nvidia
    pkgs.cudaPackages.cudatoolkit
    # pkgs.nvtopPackages.intel
    pkgs.nvidia-container-toolkit
    pkgs.intel-gpu-tools
  ];

  # Docker
  virtualisation.docker = {
    enable = true;
    rootless.daemon.settings.features.cdi = true;
    daemon.settings = {
      features.cdi = true;
      experimental = true;
      default-address-pools = [
        { base = "172.30.0.0/16"; size = 24; }
      ];
    };
  };

  # Ollama
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  
  # Warp daemon
  systemd.services.warp-svc = {
    description = "Cloudflare Warp Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
      Restart = "always";
    };
  };
  
  # Input-remapper as user service
  services.input-remapper = {
    enable = true;
    enableUdevRules = true;
  };
  systemd.user.services.input-remapper = {
    description = "Input Remapper (user service)";
    serviceConfig = {
      ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --command autoload";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };
  
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  
  # services.auto-cpufreq.enable = true;
  # services.auto-cpufreq.settings = {
  #   battery = {
  #      governor = "powersave";
  #      turbo = "never";
  #   };
  #   charger = {
  #      governor = "performance";
  #      turbo = "auto";
  #   };
  # };

  # services.power-profiles-daemon.enable = false;
  # services.thermald.enable = true;
  powerManagement.powertop.enable = true;
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

  #     USB_AUTOSUSPEND_DISABLE_ON_BLUETOOTH = true;
  #     USB_AUTOSUSPEND = 0;
  #     USB_BLACKLIST = "32c2:0018";

  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 20;

      # Optional helps save long term battery health
      # START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
  #     STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

  #   };
  # };


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
  
  # NVIDIA Seutp
  hardware.graphics = {
    enable = true;
  };
  
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  };
}
