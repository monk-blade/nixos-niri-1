{ config, lib, pkgs, ... }:

{
  # Fish shell configuration
  programs.fish = {
    enable = true;
    
    # Shell aliases - migrated from Fish config
    shellAliases = {
      # General Productivity
      lns = "ln -s";
      ll = "lsd -la";
      v = "nvim";
      c = "clear";
      lg = "lazygit";
      ff = "fastfetch";
      ".." = "cd ..";
      
      # NixOS Package Management
      nix-search = "nix search nixpkgs";
      nix-shell = "nix-shell -p";
      rebuild = "sudo nixos-rebuild switch";
      rebuild-test = "sudo nixos-rebuild test";
      nix-gc = "sudo nix-collect-garbage -d";
      nix-list = "nix-env -q";
      
      # Quick Navigation
      "..." = "cd ../..";
      "...." = "cd ../../..";
      home = "cd ~";
      nixcfg = "cd ~/nixos-config";
      
      # Docker Power Tools
      dc = "sudo docker-compose";
      dr = "sudo docker";
      
      # Tmux Session Management
      txfr = "tmuxifier";
      tm = "tmux";
      ta = "tmux attach-session -t";
      tn = "tmux new-session -s";
      tl = "tmux list-sessions";
      tk = "tmux kill-session -t";
      tka = "tmux kill-server";
      txsrc = "tmux source-file ~/.tmux.conf";
      
      # System Monitoring
      diskusg = "df -h | grep /dev/nvme0n1p2";
    };
    
    # Fish shell initialization
    interactiveShellInit = ''
      # Disable fish greeting
      set fish_greeting ""
      
      # Vi keybindings and cursor settings
      set fish_key_bindings fish_vi_key_bindings
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      
      # Environment variables
      set -gx PATH $PATH $HOME/go/bin
      set -gx EDITOR nvim
      set -gx BROWSER firefox
      
      # Tokyo Night color scheme for Fish
      set fish_color_normal normal
      set fish_color_command 7aa2f7
      set fish_color_quote 9ece6a
      set fish_color_redirection bb9af7
      set fish_color_end f7768e
      set fish_color_error f7768e
      set fish_color_param e0af68
      set fish_color_comment 565f89
      set fish_color_match --background=7aa2f7
      set fish_color_selection white --bold --background=414868
      set fish_color_search_match bryellow --background=414868
      set fish_color_history_current --bold
      set fish_color_operator bb9af7
      set fish_color_escape 7dcfff
      set fish_color_cwd 7aa2f7
      set fish_color_cwd_root f7768e
      set fish_color_valid_path --underline
      set fish_color_autosuggestion 565f89
      set fish_color_user 9ece6a
      set fish_color_host normal
      set fish_color_cancel -r
      set fish_pager_color_completion normal
      set fish_pager_color_description e0af68 yellow
      set fish_pager_color_prefix white --bold --underline
      set fish_pager_color_progress brwhite --background=414868
      
      # Initialize tools if available
      if command -v starship >/dev/null
        starship init fish | source
      end
      
      if command -v zoxide >/dev/null
        zoxide init fish | source
      end
      
      if command -v fnm >/dev/null
        fnm env --use-on-cd | source
      end
      
      # Terminal sequences (if available)
      if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
        cat ~/.cache/ags/user/generated/terminal/sequences.txt
      end
    '';
    
    # Fish functions - migrated from Fish config
    functions = {
      # Kill process on specific port
      killport = ''
        if test -z $argv[1]
          echo "🔥 Usage: killport <port>"
          return 1
        end
        set -l pid (lsof -ti :$argv[1])
        if test -n "$pid"
          echo "💀 Killing process on port $argv[1] (PID: $pid)"
          kill -9 $pid
        else
          echo "🤷 No process found on port $argv[1]"
        end
      '';
      
      # Quick directory navigation
      mkcd = ''
        mkdir -p $argv[1] && cd $argv[1]
      '';
      
      # Extract any archive
      extract = ''
        if test -f $argv[1]
          switch $argv[1]
            case '*.tar.bz2'
              tar xjf $argv[1]
            case '*.tar.gz'
              tar xzf $argv[1]
            case '*.bz2'
              bunzip2 $argv[1]
            case '*.rar'
              unrar x $argv[1]
            case '*.gz'
              gunzip $argv[1]
            case '*.tar'
              tar xf $argv[1]
            case '*.tbz2'
              tar xjf $argv[1]
            case '*.tgz'
              tar xzf $argv[1]
            case '*.zip'
              unzip $argv[1]
            case '*.Z'
              uncompress $argv[1]
            case '*.7z'
              7z x $argv[1]
            case '*'
              echo "🤔 '$argv[1]' cannot be extracted via extract()"
          end
        else
          echo "🚫 '$argv[1]' is not a valid file"
        end
      '';
    };
  };
  
  # Related shell tools configuration
  programs.starship = {
    enable = true;
  };
  
  programs.zoxide = {
    enable = true;
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  # FZF fuzzy finder
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [ "--height 40%" "--border" ];
  };
  
  # Bat for syntax highlighting
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "numbers,changes,header";
    };
  };
}
