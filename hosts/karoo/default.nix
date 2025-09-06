{ config, lib, pkgs, self, nixpkgs, ...}:

{
  imports = [
    "${self}/platforms/rpi4"
  ];

  # system
  services.mingetty.autologinUser = "karoo";
  boot.loader.grub.enable = false;  

  users.users.karoo = {
    isNormalUser = true;
    description = "default user service";
    extraGroups = [ "networkmanager" "wheel" ];
    #### SSH keys
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbeAJB6vJoITjVO55R0eE7Pt69APBbO3642XHk/GA2L brosin@brosin-pc"];
  };

  # networking
  networking.hostName = "karoo";

  #### Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";

  #### Users
  users.users.luffy = {
    isNormalUser = true;
    description = "luffy";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = "$6$Iv1nW1Wq9IlaNymT$2mpNJKXbku1TtpHkoM4hTbpv2zT8NwKKl4Azdu5lKKkQ/sxtwfqirnwMcdK4QUIDlYA0IVjidhx6VMGmIyZ1/.";
    #### SSH Keys
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQ1MzzeEYW5yAoVv58u7XlWK3eYrCtn3GeegrXr0PUy brosin@brosin-pc"];
  };

  #### Networking
  networking.networkmanager.wifi.powersave = false;
  networking.firewall = {
    enable = true;

    trustedInterfaces = ["tailscale0"];

    allowedTCPPorts = [ 22 ];
  };


  #### System
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    # don't forget editor. nano installed by default.
    vim
    tmux

    # networking
    wget
    curl

    # git
    git

    # compression
    unzip

    # disk management
    parted

    # tailscale
    tailscale
  ];

  #### Ssh
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  #### Tailscale
  services.tailscale.enable = true;

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # ensure tailscale is running
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with pkgs; ''
      # do as told
      sleep 2

      #  check we're not already authed
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      if [ -f /persist/secrets/tailscale ]; then
        ${tailscale}/bin/tailscale up -authkey file:/persist/secrets/tailscale
      else
        echo "TS AuthKey file not found in /persist/secrets/tailscale"
        exit 1
      fi
    '';
  };
}
