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
      vim-tmux-navigator
      {
        plugin = yank;
        extraConfig = ''set -g @yank_selection 'primary'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''set -g @continuum-restore 'on'
        '';
      }
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
