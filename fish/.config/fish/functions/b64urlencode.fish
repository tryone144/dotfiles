function b64urlencode --description 'alias using python\'s urlsafe_b64encode()'
    python -c 'import base64; import sys; b64 = "".join(sys.stdin.readlines()); print(base64.urlsafe_b64encode(b64.encode("utf-8")).decode("utf-8").rstrip("="))'
end

