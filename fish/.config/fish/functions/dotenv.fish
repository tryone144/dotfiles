function dotenv --description 'Load environment variables from .env file'
    set -la envfiles ".env"
    if test (count $argv) -gt 0
        set envfiles $argv
    end

    for file in $envfiles
        if ! test -e "$file"
            continue
        end

        for line in (cat "$file")
            if string match -r '^#' "$line"
                continue
            end

            set -l name (string replace -r '^export\s+' '' (echo "$line" | cut -d'=' -f1))
            set -l value (string unescape (echo "$line" | cut -d'=' -f2-))
            set -xg "$name" "$value"
        end
    end
end
