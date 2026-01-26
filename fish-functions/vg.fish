function vg
    set -l result ( \
      rg --line-number $argv[1] | \
      fzf --delimiter ":" --tmux 90% \
          --bind 'ctrl-/:toggle-preview' \
          --preview 'bat --color=always {1} --highlight-line {2} --line-range {2}:')
    if test -n "$result"
        set -l file (echo $result | cut -d: -f1)
        set -l line (echo $result | cut -d: -f2)
        nvim +$line $file
    end
end
