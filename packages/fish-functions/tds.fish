function tds --wraps=_fish_tmux_directory_session
    tmux new-session -d -s $argv
end
