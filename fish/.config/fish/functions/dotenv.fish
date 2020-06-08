function dotenv --description 'Load environment variables from .env file'
    set -l envfile ".env"
    if test (count $argv) -gt 0
        set envfile "$argv[1]"
    end

    if test -e "$envfile"
        for line in (cat "$envfile")
            set -xg (echo "$line" | cut -d'=' -f1) (echo "$line" | cut -d'=' -f2-)
        end
    end
end
