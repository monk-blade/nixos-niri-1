{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    terminal = "tmux-256color";
    
    # Install plugins using Nix
    plugins = with pkgs.tmuxPlugins; [
      # Essential plugins
      {
        plugin = vim-tmux-navigator;
        extraConfig = "";
      }
      {
        plugin = yank;
        extraConfig = ''set -g @yank_selection 'primary'
        '';
      }
      {
        plugin = tmux-resurrect;
        extraConfig = ''set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''set -g @continuum-restore 'on'
        '';
      }
      # Mode indicator plugin
      {
        plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
          pluginName = "tmux-mode-indicator";
          version = "unstable-2023-06-26";
          src = pkgs.fetchFromGitHub {
            owner = "MunifTanjim";
            repo = "tmux-mode-indicator";
            rev = "20b0975df5741d3a7cff5b9b7d00330ade8a4086";
            sha256 = "sha256-JlKKGNaKjbHaKcwWKyqKNq9P+nMZ0K3QgdDNpCeaiQg=";
          };
        };
        extraConfig = ''
          # Mode indicator settings with Kanagawa colors
          set -g @mode_indicator_empty_prompt ' N '
          set -g @mode_indicator_empty_mode_style 'bg=#7E9CD8,fg=#1F1F28'
          set -g @mode_indicator_prefix_prompt ' P '
          set -g @mode_indicator_prefix_mode_style 'bg=#D27E99,fg=#1F1F28'
          set -g @mode_indicator_copy_prompt ' C '
          set -g @mode_indicator_copy_mode_style 'bg=#a8e6cf,fg=#1F1F28'
          set -g @mode_indicator_sync_prompt ' S '
          set -g @mode_indicator_sync_mode_style 'bg=#DCA561,fg=#1F1F28'
        '';
      }
      # Git status plugin
      {
        plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
          pluginName = "tmux-simple-git-status";
          version = "unstable-2023-01-14";
          src = pkgs.fetchFromGitHub {
            owner = "kristijanhusak";
            repo = "tmux-simple-git-status";
            rev = "287da42f47d7204618b62f2c4f8bd60b36d5c7ed";
            sha256 = "sha256-2eiQNPOaDV2CBXcS4dAOUzdl3bPcNlp6Jz0lgMNgOHs=";
          };
        };
        extraConfig = ''
          # Git status colors using Kanagawa palette
          set -g @simple_git_status_branch_color "#7E9CD8"
          set -g @simple_git_status_added_color "#76946A"
          set -g @simple_git_status_deleted_color "#C34043"
          set -g @simple_git_status_modified_color "#DCA561"
          set -g @simple_git_status_renamed_color "#957FB8"
          set -g @simple_git_status_untracked_color "#727169"
          
          # Git status symbols (using nerd fonts)
          set -g @simple_git_status_branch_symbol "󰘬 "
          set -g @simple_git_status_staged_symbol "󰱒 "
          set -g @simple_git_status_changes_symbol "󰏫 "
          set -g @simple_git_status_untracked_symbol "󰝦 "
          set -g @simple_git_status_stashed_symbol "󱉟ﰗ "
          set -g @simple_git_status_ahead_symbol " "
          set -g @simple_git_status_behind_symbol " "
          set -g @simple_git_status_conflict_symbol "󰕚 "
          set -g @simple_git_status_clean_symbol "󰗠 "
        '';
      }
      # Open plugin
      open
    ];
    
    extraConfig = ''
      # Split panes using | and -
      unbind %
      bind | split-window -h 
      unbind '"'
      bind - split-window -v
      
      # Reload config file
      unbind r
      bind r source-file ~/.tmux.conf
      
      # Resizing panes
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      bind -r H resize-pane -L 5
      bind -r m resize-pane -Z
      
      # Enable true color support
      set -ag terminal-overrides ",xterm-256color:RGB"
      
      # Vi mode
      set-window-option -g mode-keys vi
      
      # Copy mode bindings
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection
      unbind -T copy-mode-vi MouseDragEnd1Pane
      
      # Focus events
      set -g focus-events on
      
      # Kanagawa theme colors
      set -g status-style 'bg=#2A2A37 fg=#DCD7BA'
      set -g window-status-current-style 'bg=#223249 fg=#7E9CD8'
      set -g window-status-style 'bg=#2A2A37 fg=#727169'
      set -g pane-active-border-style 'fg=#D27E99'
      set -g pane-border-style 'fg=#2A2A37'
      
      # Status bar format with Kanagawa colors and current directory
      set -g status-left-length 40
      set -g status-left '#[fg=#7E9CD8,bg=#2A2A37] #{b:pane_current_path} #[fg=#7E9CD8]│ '
      
      set -g status-right-length 120
      set -g status-right '#{tmux_mode_indicator}'
    '';
  };
}
