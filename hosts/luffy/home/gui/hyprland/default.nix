{ pkgs, ... }:
{
  # Essential Wayland/Hyprland packages
  home.packages = with pkgs; [
    # Wayland utilities
    wl-clipboard      # Clipboard utilities for Wayland
    wlr-randr        # Display configuration tool
    
    # Screenshot and screen recording
    grim             # Screenshot utility
    slurp            # Screen area selection
    swappy           # Screenshot annotation
    
    # Application launcher and menu
    rofi             # Application launcher
    
    # Notification daemon
    mako             # Lightweight notification daemon
    
    # Status bar
    waybar           # Highly customizable status bar
    
    # Terminal
    kitty            # GPU-accelerated terminal
    
    # File manager
    nautilus         # GNOME file manager
  ];

  # Enable Hyprland but use traditional config file
  wayland.windowManager.hyprland = {
    enable = true;
    # Use the config file instead of Nix settings
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  # Configure related services
  services = {
    # Notification daemon
    mako = {
      enable = true;
      backgroundColor = "#1e1e2e";
      borderColor = "#89b4fa";
      borderRadius = 10;
      borderSize = 2;
      textColor = "#cdd6f4";
      defaultTimeout = 5000;
    };
  };

  # Terminal configuration
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = 12;
      background_opacity = "0.8";
      
      # Catppuccin color scheme
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      selection_background = "#313244";
      selection_foreground = "#cdd6f4";
      cursor = "#f5e0dc";
      cursor_text_color = "#1e1e2e";
    };
  };
}
