# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # Nix
  nix.buildCores = 4;

  networking.hostName = "troymac"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.enableIPv6 = false; # Disable IPv6

  # Select internationalisation properties.
  console = {
    font = "latarcyrheb-sun32";
    keyMap = "us";
  };
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Kiev";

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    pciutils binutils gcc wget git ruby perl python curl links2
    firefox-bin rxvt_unicode xorg.xbacklight xclip xorg.xdpyinfo compton rofi feh
    vim_configurable redshift lm_sensors
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.useGlamor = true;
  services.xserver.dpi = 227;
  services.xserver.layout = "us,ru,ge";
  services.xserver.xkbOptions = "grp:win_space_toggle,ctrl:nocaps";
  services.xserver.autoRepeatDelay = 500;

  # LightDM Display Manager
  services.xserver.displayManager.defaultSession = "none+bspwm";
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.enso.enable = true;
  };

  # BSPWM
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.windowManager.bspwm.configFile = "/home/troydm/.dotcentral/configurations/troymac/bspwmrc";
  services.xserver.windowManager.bspwm.sxhkd.configFile = "/home/troydm/.dotcentral/configurations/troymac/sxhkdrc";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.tappingDragLock = false;
  services.xserver.libinput.accelSpeed = "0.6";
  services.xserver.libinput.additionalOptions = ''
    Option "TappingDrag" "0"
  '';

  # Enable the KDE Desktop Environment. 
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  systemd.services.mbp-fixes = {
    description = "Fixes for MacBook Pro";
    wantedBy = [ "multi-user.target" "suspend.target" ];
    before = [ "multi-user.target"];
    after = [ "suspend.target" ];
    script = ''
        echo 30 > /sys/class/leds/smc::kbd_backlight/brightness
        if ${pkgs.gnugrep}/bin/grep -q '\bXHC1\b.*\benabled\b' /proc/acpi/wakeup; then
          echo XHC1 > /proc/acpi/wakeup
        fi
        echo 69 > /sys/class/backlight/intel_backlight/brightness
    '';
    serviceConfig.Type = "oneshot";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.troydm = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel"];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?

}
