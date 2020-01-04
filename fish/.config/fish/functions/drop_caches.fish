function drop_caches --description 'alias drop_caches=echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null'
    sudo sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null;
end
