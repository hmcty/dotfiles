function devlog
    if test (count $argv) -ne 1
        echo "Usage: devlog <project_name>"
        return 1
    end

    set -l project_dir ~/notes/projects/$argv[1]
    if not test -d $project_dir
        echo "Project directory '$project_dir' does not exist."
        return 1
    end

    nvim $project_dir/devlogs/(date +'%Y-%m-%d').md
end
