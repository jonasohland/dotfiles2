function play_all_mkv_from
    set index 0
    for f in *.mkv
        set index (math $index + 1)
        if test $index -lt $argv[1]
            continue
        end
	mpv --fullscreen --sid=1 $f
    end
end
