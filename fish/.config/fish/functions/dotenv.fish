function dotenv --description 'Load environment variables from .env file'
    set -la envfiles ".env"
    if test (count $argv) -gt 0
        set envfiles $argv
    end

    for file in $envfiles
        if test -e "$file"
            for line in (cat "$file")
                set -xg (echo "$line" | cut -d'=' -f1) (echo "$line" | cut -d'=' -f2-)
            end
        end
    end
end
