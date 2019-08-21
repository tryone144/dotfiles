function drop_caches --description 'alias drop_caches=echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null'
    echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null;
end
