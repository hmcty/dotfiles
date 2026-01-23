function vf
    fzf -m \
      --bind 'ctrl-/:toggle-preview' \
      --preview 'bat --color=always {}' \
      --preview-window=:hidden \
      --bind 'enter:execute(nvim {+})'
end
