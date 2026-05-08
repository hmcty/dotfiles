function install-kicad-lib
    set -l src $argv[1]

    if not test -f $src
        echo "Error: file not found: $src"
        return 1
    end

    if not string match -qi '*.zip' (path basename $src)
        echo "Error: expected a zip file"
        return 1
    end

    set -l name (string replace -r '\.zip$' '' (path basename $src))
    set -l tmpdir (mktemp -d)

    unzip -q $src -d $tmpdir

    # Strip KiCADv6/ prefix if present
    set -l base $tmpdir
    if test -d $tmpdir/KiCADv6
        set base $tmpdir/KiCADv6
    end

    # Symbols (.kicad_sym)
    for sym in (find $base -maxdepth 1 -name '*.kicad_sym')
        mkdir -p ~/src/kicad/symbols
        cp $sym ~/src/kicad/symbols/$name.kicad_sym
        echo "Installed symbol: ~/src/kicad/symbols/$name.kicad_sym"
    end

    # Footprints (.pretty directories)
    for dir in (find $base -maxdepth 1 -type d -name '*.pretty')
        mkdir -p ~/src/kicad/footprints/$name.pretty
        cp -r $dir/. ~/src/kicad/footprints/$name.pretty/
        echo "Installed footprints: ~/src/kicad/footprints/$name.pretty/"
    end

    # 3D models (.step / .stp / .wrl)
    for model in (find $base -maxdepth 3 \( -iname '*.step' -o -iname '*.stp' -o -iname '*.wrl' \))
        mkdir -p ~/src/kicad/3dmodels
        cp $model ~/src/kicad/3dmodels/(path basename $model)
        echo "Installed 3D model: ~/src/kicad/3dmodels/"(path basename $model)
    end

    rm -rf $tmpdir
end
