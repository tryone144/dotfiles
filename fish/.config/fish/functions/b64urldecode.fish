function b64urldecode --description 'alias using python\'s urlsafe_b64decode()'
    python -c 'import base64; import sys; b64 = "".join(sys.stdin.readlines()); print(base64.urlsafe_b64decode(b64 + "======").decode("utf-8"))'
end
