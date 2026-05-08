function install-app
    set -l src $argv[1]

    if not test -f $src
        echo "Error: file not found: $src"
        return 1
    end

    set -l basename (path basename $src)
    set -l appimage
    set -l tmpdir

    if string match -qi '*.appimage' $basename
        set appimage $src
    else if string match -q '*.tar' $basename; or string match -q '*.tar.*' $basename
        set tmpdir (mktemp -d)
        tar -xf $src -C $tmpdir
        set appimage (find $tmpdir -iname '*.appimage' | head -n1)
        if test -z "$appimage"
            rm -rf $tmpdir
            echo "Error: no AppImage found in archive"
            return 1
        end
    else
        echo "Unsupported file type: $basename"
        return 1
    end

    set -l raw (path basename $appimage)
    set -l name (string replace -ri '\.appimage$' '' $raw)
    set -l name (string lower -- (string replace -r '[-_][0-9]+[\._].*$' '' $name))
    set -l dest $HOME/.local/bin/$name

    cp $appimage $dest
    chmod +x $dest
    echo "Installed: $dest"

    if set -q tmpdir
        rm -rf $tmpdir
    end

    set -l display_name (string replace -r '^(.)' -- (string upper (string sub -l 1 -- $name)) $name)
    set -l desktop $HOME/.local/share/applications/$name.desktop
    printf '[Desktop Entry]\nType=Application\nName=%s\nExec=%s\nCategories=Application;\n' \
        $display_name $dest > $desktop
    echo "Created: $desktop"
end
