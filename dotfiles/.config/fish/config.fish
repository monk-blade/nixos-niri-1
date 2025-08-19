# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                        🐟 FISH SHELL CONFIG 🐟                           │
# ╰─────────────────────────────────────────────────────────────────────────────╯

if status is-interactive
    # ┌─ Shell Setup ───────────────────────────────────────────────────────────┐
    set fish_greeting ""  # Disable default fish greeting
    
    # ┌─ Starship Prompt ───────────────────────────────────────────────────────┐
    if command -v starship >/dev/null
        starship init fish | source
    else
        echo "⚠️  Starship not found. Install with: curl -sS https://starship.rs/install.sh | sh"
    end
end

# ┌─ Terminal Sequences ────────────────────────────────────────────────────────┐
if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
    cat ~/.cache/ags/user/generated/terminal/sequences.txt
end

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                            🚀 ALIASES 🚀                                  │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# ┌─ General Productivity ──────────────────────────────────────────────────────┐
alias lns="ln -s"      # target -> destination
alias ll="lsd -la"     # fancy ls with icons
alias v="nvim"         # quick vim
alias c="clear"        # clear terminal
alias lg="lazygit"     # git TUI
alias ff="fastfetch"   # system info
alias ..="cd .."       # go up one directory

# ┌─ NixOS Package Management ──────────────────────────────────────────────────┐
alias nix-search="nix search nixpkgs"
alias nix-shell="nix-shell -p"
alias rebuild="sudo nixos-rebuild switch"
alias rebuild-test="sudo nixos-rebuild test"
alias nix-gc="sudo nix-collect-garbage -d"  # cleanup old generations
alias nix-list="nix-env -q"                 # list installed packages

# ┌─ Docker Power Tools ────────────────────────────────────────────────────────┐
alias dc="sudo docker-compose"
alias dr="sudo docker"

# ┌─ Tmux Session Management ───────────────────────────────────────────────────┐
alias txfr="tmuxifier"
alias tm="tmux"
alias ta="tmux attach-session -t"    # attach to session
alias tn="tmux new-session -s"       # new session
alias tl="tmux list-sessions"        # list sessions
alias tk="tmux kill-session -t"      # kill specific session
alias tka="tmux kill-server"         # 💀 kill all sessions
alias txsrc="tmux source-file ~/.tmux.conf"  # reload tmux config

# ┌─ System Monitoring ─────────────────────────────────────────────────────────┐
alias diskusg="df -h | grep /dev/nvme0n1p2"

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                          ⚡ FUNCTIONS ⚡                                   │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# Kill process on specific port
function killport
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
end

# Quick directory navigation
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# Extract any archive
function extract
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
end

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                        🛠️  TOOL INITIALIZATION 🛠️                        │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# Zoxide (smart cd)
if command -v zoxide >/dev/null
    zoxide init fish | source
end

# Fast Node Manager
if command -v fnm >/dev/null
    fnm env --use-on-cd | source
end

# ┌─ Environment Variables ─────────────────────────────────────────────────────┐
set -gx PATH $PATH $HOME/go/bin
set -gx EDITOR nvim
set -gx BROWSER firefox

# ┌─ Fish-specific Settings ────────────────────────────────────────────────────┐
set fish_key_bindings fish_vi_key_bindings  # Vi keybindings
set fish_cursor_default block               # Block cursor in normal mode
set fish_cursor_insert line                 # Line cursor in insert mode
set fish_cursor_replace_one underscore      # Underscore cursor in replace mode

# ┌─ Colors ────────────────────────────────────────────────────────────────────┐
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