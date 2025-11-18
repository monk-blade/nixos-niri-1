{ config, lib, pkgs, ... }:


{
    imports = [
        ./git.nix
        ./shell.nix
        ./tmux.nix
    ];
    home.packages = with pkgs; [
        # ========================================
        # EDITORS & IDEs
        # ========================================
        windsurf                # AI-powered editor
        code-cursor
        
        # ========================================
        # VERSION MANAGERS & PACKAGE MANAGERS
        # ========================================
        fnm                     # Fast Node Manager
        pnpm                    # Fast npm alternative
        yarn                    # Node package manager
        
        # ========================================
        # PROGRAMMING LANGUAGES & RUNTIMES
        # ========================================
        nodejs_24               # Node.js runtime
        bun
        python3                 # Python interpreter
        python3Packages.pip     # Python package manager
        python3Packages.virtualenv  # Python virtual environments
        rustc                   # Rust compiler
        cargo                   # Rust package manager
        go                      # Go programming language

        # ========================================
        # DATABASE & DATA MANAGEMENT
        # ========================================
        # dbeaver-bin             # Universal database tool (80+ databases)
        
        # ========================================
        # NATIVE DEVELOPMENT DEPENDENCIES
        # ========================================
        libjpeg                 # JPEG library
        cairo                   # 2D graphics library
        pango                   # Text rendering
        pixman                  # Pixel manipulation
        libuuid                 # UUID library
        giflib                  # GIF library
        libimagequant           # Image quantization
        librsvg                 # SVG rendering
        pkg-config              # Package configuration
        
        # ========================================
        # C/C++ DEVELOPMENT
        # ========================================
        gcc                     # GNU Compiler Collection
        gnumake                 # GNU Make
        cmake                   # Cross-platform build system
        
        # ========================================
        # CODE QUALITY & FORMATTING
        # ========================================
        shellcheck              # Shell script linting
        shfmt                   # Shell script formatting
        rustfmt
        biome
        stylua
        taplo
        prettier
        black
        isort
        
        # ========================================
        # SYSTEM DEBUGGING & MONITORING
        # ========================================
        strace                  # System call monitoring
        ltrace                  # Library call monitoring
        lsof                    # List open files

        # ========================================
        # DEVOPS & CLOUD TOOLS
        # ========================================
        docker                  # Container runtime
        docker-compose          # Multi-container orchestration
        kubectl                 # Kubernetes CLI
        terraform               # Infrastructure as code
        
        # ========================================
        # API & NETWORK TESTING
        # ========================================
        httpie                  # Better curl alternative
        yaak                    # API testing tool
    ];
}
