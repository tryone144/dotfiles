function b64urlencode --description 'alias using python\'s urlsafe_b64encode()'
    python -c 'import base64; import sys; b64 = b"".join(sys.stdin.buffer.readlines()); print(base64.urlsafe_b64encode(b64).decode("utf-8").rstrip("="))'
end

