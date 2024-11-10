;extends
((inline) @injection.content
          (#lua-match? @injection.content "^%s*import%s")
          (#set! injection.language "typescript"))
((inline) @injection.content
          (#lua-match? @injection.content "^%s*export%s")
          (#set! injection.language "typescript"))
((inline) @injection.content
          (#lua-match? @injection.content "^%s*function%s")
          (#set! injection.language "typescript"))
((inline) @injection.content
          (#lua-match? @injection.content "^%s*const%s")
          (#set! injection.language "typescript"))
