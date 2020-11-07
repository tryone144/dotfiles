function ripthedisk --description 'Rip a music CD with ABCDE and output status info'
    set -l device "/dev/cdrom"
    if test (count $argv) -gt 0
        set device "$argv[1]"
    end

    echo " :: Start ripping cd in $device"
    set -l success false
    abcde -d "$device" \
        && set -l success true \
        && notify-send -u normal -i ok "abcde finished" "Finished ripping $device" \
        || notify-send -u critical -i error "abcde failed" "Ripping $device failed"
    if test $success = true
        echo " :: Eject $device"
        eject "$device"
    end
end
