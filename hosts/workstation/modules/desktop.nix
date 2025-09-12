{ config, lib, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # ========================================
    # WEB BROWSERS
    # ========================================
    chromium
    inputs.zen-browser.packages."${pkgs.system}".default

    # ========================================
    # FILE MANAGEMENT
    # ========================================
    nautilus                # GNOME Files manager
    
    # ========================================
    # COMMUNICATION & SOCIAL
    # ========================================
    slack                   # Team communication
    discord                 # Gaming/community chat
    # zoom-us
    
    # ========================================
    # DOCUMENT VIEWERS
    # ========================================
    zathura                 # Lightweight PDF viewer with vim-like keybindings
    
    # ========================================
    # UTILITIES
    # ========================================
    switcheroo              # App switcher
    localsend               # Local file sharing

    # ========================================
    # GRAPHICS & UI FRAMEWORKS
    # ========================================
    
    # Qt6 support (essential for Qt-based applications)
    qt6.qtbase              # Core Qt6 framework (includes qtwayland)
    qt6.qttools             # Qt6 development tools
    
    # GTK support
    hicolor-icon-theme      # Base icon theme (required)
    shared-mime-info        # MIME type support for applications
    adwaita-icon-theme      # Default GNOME icons (required for Nautilus)
    papirus-icon-theme      # Comprehensive icon theme with better app coverage
    gtk3                    # GTK3 runtime
    gtk4                    # GTK4 runtime
    glib                    # GLib runtime (required for GTK apps)
    
    # Graphics acceleration
    vulkan-tools            # Vulkan utilities

    # ========================================
    # GAMING & COMPATIBILITY
    # ========================================
    xwayland-satellite      # XWayland integration for gaming

    # ========================================
    # ARCHIVE & COMPRESSION
    # ========================================
    zip                     # ZIP compression
    xz                      # XZ compression
    unzip                   # ZIP extraction
    p7zip                   # 7-Zip compression

    # ========================================
    # UTILITIES & HELPERS
    # ========================================
    jq                      # JSON processor
  ];
}
