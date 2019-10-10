function __kexec_get_image_version
    set -l image "$argv[1]"
    file -b "/boot/vmlinuz-$image" | sed -re 's/^.*, version ([^ ]+).*$/\1/g'
end

function __kexec_get_current_version
    cat /proc/version | sed -re 's/^.*Linux version ([^ ]+).*$/\1/g'
end

function __kexec_is_image_loaded
    test (cat /sys/kernel/kexec_loaded) -ne 0
end

function __kexec_print_err
    set -l msg $argv
    echo (set_color red -o)"Error:"(set_color normal)" $msg" >&2
end

function __kexec_print_warn
    set -l msg $argv
    echo (set_color yellow -o)"Warning:"(set_color normal)" $msg" >&2
end

function __kexec_print_usage
    set -l func "$argv[1]"
    echo "usage: $func [IMAGE]"
    echo "Load new kernel image 'IMAGE' (default: 'linux') for execution with kexec."
    echo "Example: $func linux-hardened && systemctl kexec"
end

function kexec_load --description 'load new kernel image and ramdisk into kexec'
    if test (count $argv) -gt 1
        __kexec_print_err "Too many arguments."
        __kexec_print_usage (status function) >&2
        return 1
    end

    if test "$argv[1]" = "help"
        __kexec_print_usage (status function)
        return
    end

    set -l image "linux"
    if test (count $argv) -eq 1
        set image "$argv[1]"
        if not test -f "/boot/vmlinuz-$image"
            __kexec_print_err "Cannot find kernel image for '$image' at '/boot/vmlinuz-$image'."
            return 1
        end
    else
    end

    if __kexec_is_image_loaded
        __kexec_print_warn "Another kernel image is already loaded. Overwriting..."
    end

    echo "Load new kernel image '$image': "(__kexec_get_current_version)" --> "(__kexec_get_image_version "$image")
    sudo kexec -l "/boot/vmlinuz-$image" --initrd=/boot/initramfs-linux.img --reuse-cmdline

    set -l load_status "$status"
    if test "$load_status" -ne 0
        __kexec_print_err "Loading new kernel '$image' failed."
        return "$load_status"
    end

    if not __kexec_is_image_loaded
        __kexec_print_err "New kernel '$image' is NOT loaded."
        return 1
    end

    echo "New kernel '$image' ("(__kexec_get_image_version "$image")") successfully loaded"
    echo "Reboot into new kernel with 'systemctl kexec'"
end
