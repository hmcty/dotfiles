function install_appimage
    if test (count $argv) -lt 1
        echo "Usage: install_appimage <path-to-appimage> [extra exec args...]"
        return 1
    end

    set -l source_path $argv[1]
    if not test -f $source_path
        echo "AppImage '$source_path' does not exist."
        return 1
    end

    set -l filename (basename $source_path)
    if not string match -qi "*.AppImage" -- $filename
        echo "Expected an .AppImage file, got '$filename'."
        return 1
    end

    set -l app_name (string replace -r '\.AppImage$' '' -- $filename)
    set app_name (string replace -r '[-_][0-9].*$' '' -- $app_name)
    if test -z "$app_name"
        echo "Could not derive an application name from '$filename'."
        return 1
    end

    set -l slug (string lower -- $app_name)
    set slug (string replace -a ' ' '-' -- $slug)

    set -l install_dir ~/Applications
    set -l desktop_dir ~/.local/share/applications
    set -l target_path $install_dir/$filename
    set -l desktop_path $desktop_dir/$slug.desktop

    mkdir -p $install_dir $desktop_dir
    mv $source_path $target_path
    chmod +x $target_path

    set -l extra_args $argv[2..-1]
    set -l exec_line $target_path
    for arg in $extra_args
        set exec_line "$exec_line "(string escape -- $arg)
    end
    set exec_line "$exec_line %U"

    printf '%s\n' \
        '[Desktop Entry]' \
        'Version=1.0' \
        'Type=Application' \
        "Name=$app_name" \
        "Exec=$exec_line" \
        'Terminal=false' \
        'StartupNotify=true' \
        'Categories=Utility;' \
        > $desktop_path

    echo "Installed $app_name"
    echo "AppImage: $target_path"
    echo "Desktop entry: $desktop_path"
end
