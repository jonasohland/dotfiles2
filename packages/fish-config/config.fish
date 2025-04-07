if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_tmux_autostart true
end

test -d "$HOME/.local/bin" && fish_add_path -g "$HOME/.local/bin"
test -d "$HOME/.cargo/bin" && fish_add_path -g "$HOME/.cargo/bin"
test -d "$HOME/go/bin" && fish_add_path -g "$HOME/go/bin"

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

fish_default_key_bindings
