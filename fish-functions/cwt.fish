function cwt --description 'Change to a Git worktree selected by branch or path'
    if not git rev-parse --git-common-dir >/dev/null 2>&1
        echo 'cwt: not inside a Git repository' >&2
        return 1
    end

    set -l entries
    set -l worktree_path
    set -l branch '(detached)'

    for field in (git worktree list --porcelain -z | string split0)
        if string match -q 'worktree *' -- $field
            if test -n "$worktree_path"
                set -a entries (string join \t -- $branch $worktree_path)
            end
            set worktree_path (string replace 'worktree ' '' -- $field)
            set branch '(detached)'
        else if string match -q 'branch refs/heads/*' -- $field
            set branch (string replace 'branch refs/heads/' '' -- $field)
        end
    end

    if test -n "$worktree_path"
        set -a entries (string join \t -- $branch $worktree_path)
    end

    set -l query (string join ' ' -- $argv)
    set -l selection (printf '%s\n' $entries | fzf \
        --delimiter=\t \
        --with-nth=1,2 \
        --prompt='worktree> ' \
        --query="$query")

    if test -z "$selection"
        return 0
    end

    set -l selected_fields (string split \t -- $selection)
    cd $selected_fields[2]
end
