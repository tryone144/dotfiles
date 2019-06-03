function _hashtest -d "test files with different hash functions"
    # usage: _hashtest ALGO SIZE FILE HASH
    if test (count $argv) -ne 4
        echo "usage: $argv[1]test [FILE] [HASH]" >&2
        return 1
    end

    # local variables
    set -l algo "$argv[1]"
    set -l size "$argv[2]"
    set -l file "$argv[3]"
    set -l hash "$argv[4]"

    # sanity checks
    set -l tester (which "$algo"sum 2>/dev/null)
    if test -z "$tester" -o ! -x "$tester"
        echo "invalid hash algorithm: $algo" >&2
        return 1
    end
    if not test -e "$file"
        echo "cannot find file '$file'" >&2
        return 1
    end
    if test (string length "$hash") -ne $size
        echo "invalid $algo-hash: $hash" >&2
        return 1
    end

    # check hashsum
    if test ($tester "$file" | head -c $size) = "$hash"
        echo (set_color green)" ✔ "(set_color normal)"File valid!"
        return 0
    else
        echo (set_color red)" ✘ "(set_color normal)"File invalid!" >&2
        return 1
    end
end

function md5test --description 'alias md5test="_hashtest md5 32"'
    _hashtest "md5" 32 $argv;
end
function sha1test --description 'alias sha1test="_hashtest sha1 40"'
    _hashtest "sha1" 40 $argv;
end
function sha256test --description 'alias sha256test="_hashtest sha256 64"'
    _hashtest "sha256" 64 $argv;
end
function sha512test --description 'alias sha512test="_hashtest sha512 128"'
    _hashtest "sha512" 128 $argv;
end
