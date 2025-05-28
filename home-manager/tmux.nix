{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    historyLimit = 100000;
    keyMode = "vi";
    extraConfig = ''
      set -g default-command ""
      set-option -g renumber-windows on
      set-window-option -g mode-keys vi
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind p command-prompt -p 'Save history to:' -I '~/tmux.history' \
        'capture-pane -S -32768 ; save-buffer %1 ; delete-buffer'
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi V send -X select-line
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel \
        'xclip -in -selection clipboard'
    '';
  };
}
