# Session Variables Configuration
{ config, lib, pkgs, ... }:
{
  home.sessionVariables = {
    # Cursor theme
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "28";
    
    # Core environment
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "ghostty";
    
    # Terminal and color support
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
    
    # Wayland environment (for better app compatibility)
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
    MOZ_ENABLE_WAYLAND = "1";  # Enable Wayland for Firefox
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    
    # Development environment
    DEVELOPMENT_MODE = "1";
    
    # Node.js and npm
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    NODE_OPTIONS = "--max-old-space-size=4096";  # Increase Node.js memory
    
    # Python
    PYTHONDONTWRITEBYTECODE = "1";
    PYTHONUNBUFFERED = "1";
    PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH";
    
    # Rust
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    RUST_BACKTRACE = "1";  # Better error messages
    
    # Go
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    GO111MODULE = "on";  # Modern Go modules
    
    # Development tools
    DOCKER_BUILDKIT = "1";  # Enable BuildKit for Docker
    COMPOSE_DOCKER_CLI_BUILD = "1";  # Use BuildKit with docker-compose
    
    # Performance and caching
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    
    # Path additions
    PATH = "$HOME/.npm-global/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$PATH";
  };
}
