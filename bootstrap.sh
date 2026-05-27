#!/usr/bin/env bash
set -Eeuo pipefail

apt_updated=0
tmp_dirs=()

cleanup() {
    if [ "${#tmp_dirs[@]}" -gt 0 ]; then
        rm -rf "${tmp_dirs[@]}"
    fi
}

trap cleanup EXIT

log() {
    printf '\n==> %s\n' "$*"
}

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

have() {
    command -v "$1" >/dev/null 2>&1
}

check_supported_os() {
    [ -r /etc/os-release ] || die "cannot detect OS because /etc/os-release is missing"

    # shellcheck disable=SC1091
    . /etc/os-release

    case "${ID:-}" in
        debian | ubuntu)
            log "Detected supported OS: ${PRETTY_NAME:-$ID}"
            ;;
        *)
            die "unsupported OS '${PRETTY_NAME:-${ID:-unknown}}'; this bootstrap only supports Debian and Ubuntu"
            ;;
    esac

    have apt-get || die "apt-get is required on Debian and Ubuntu"
    have apt-cache || die "apt-cache is required on Debian and Ubuntu"
    have dpkg || die "dpkg is required on Debian and Ubuntu"

    [ "$EUID" -ne 0 ] || die "run bootstrap.sh as your normal user; it will use sudo for apt packages"
    have sudo || die "sudo is required to install apt packages"
}

install_system_packages() {
    local missing=()
    local package

    for package in "$@"; do
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            missing+=("$package")
        fi
    done

    if [ "${#missing[@]}" -eq 0 ]; then
        return
    fi

    if [ "$apt_updated" -eq 0 ]; then
        log "Updating apt package index"
        sudo apt-get update
        apt_updated=1
    fi

    log "Installing apt packages: ${missing[*]}"
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "${missing[@]}"
}

package_has_candidate() {
    local candidate

    candidate=$(apt-cache policy "$1" | awk '/Candidate:/ { print $2; exit }')
    [ -n "$candidate" ] && [ "$candidate" != "(none)" ]
}

install_core_packages() {
    install_system_packages \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        fontconfig \
        git \
        pkg-config \
        python3 \
        tar \
        unzip \
        xz-utils \
        libfuse2 # Required for AppImage support
}

install_python_build_dependencies() {
    local ncurses_dev=libncurses5-dev
    local readline_dev=libreadline6-dev

    package_has_candidate "$ncurses_dev" || ncurses_dev=libncurses-dev
    package_has_candidate "$readline_dev" || readline_dev=libreadline-dev

    install_system_packages \
        build-essential \
        gdb \
        lcov \
        pkg-config \
        libbz2-dev \
        libffi-dev \
        libgdbm-dev \
        libgdbm-compat-dev \
        liblzma-dev \
        "$ncurses_dev" \
        "$readline_dev" \
        libsqlite3-dev \
        libssl-dev \
        lzma \
        lzma-dev \
        tk-dev \
        uuid-dev \
        zlib1g-dev \
        libzstd-dev \
        inetutils-inetd
}

font_installed() {
    local family

    have fc-match || return 1
    family=$(fc-match -f '%{family}\n' '0xProto Nerd Font')
    [[ "$family" == *"0xProto Nerd Font"* ]]
}

install_0xproto_nerd_font() {
    if font_installed; then
        log "0xProto Nerd Font is already installed"
        return
    fi

    local font_url="${NERD_FONT_URL:-https://github.com/ryanoasis/nerd-fonts/releases/latest/download/0xProto.zip}"
    local font_dir="${FONT_DIR:-$HOME/.local/share/fonts/0xProtoNerdFont}"
    local tmp_dir

    tmp_dir=$(mktemp -d)
    tmp_dirs+=("$tmp_dir")

    log "Installing 0xProto Nerd Font"
    mkdir -p "$font_dir"
    curl --proto '=https' --tlsv1.2 -fsSL "$font_url" -o "$tmp_dir/0xProto.zip"
    unzip -oq "$tmp_dir/0xProto.zip" -d "$font_dir"
    fc-cache -f "$HOME/.local/share/fonts"

    font_installed || die "0xProto Nerd Font installation finished, but fontconfig cannot find it"
}

load_nix_profile() {
    local profile

    for profile in \
        /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
        "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
        if [ -r "$profile" ]; then
            # shellcheck disable=SC1090
            . "$profile"
        fi
    done

    hash -r
}

install_nix() {
    load_nix_profile

    if have nix; then
        log "Nix is already installed"
        return
    fi

    local -a nix_install_flags
    read -r -a nix_install_flags <<<"${NIX_INSTALL_FLAGS:---daemon --yes}"

    log "Installing Nix with flags: ${nix_install_flags[*]}"
    curl --proto '=https' --tlsv1.2 -fsSL https://nixos.org/nix/install | sh -s -- "${nix_install_flags[@]}"
    load_nix_profile

    have nix || die "Nix installation finished, but nix is not available on PATH; open a new shell and rerun bootstrap.sh"
}

home_manager_channel_url() {
    if [ -n "${HOME_MANAGER_CHANNEL_URL:-}" ]; then
        printf '%s\n' "$HOME_MANAGER_CHANNEL_URL"
        return
    fi

    local release="${HOME_MANAGER_RELEASE:-master}"
    printf 'https://github.com/nix-community/home-manager/archive/%s.tar.gz\n' "$release"
}

install_home_manager() {
    load_nix_profile

    if have home-manager; then
        log "Home Manager is already installed"
        return
    fi

    install_nix
    load_nix_profile
    have nix-channel || die "nix-channel is required to install Home Manager"
    have nix-shell || die "nix-shell is required to install Home Manager"

    local channel_url
    channel_url=$(home_manager_channel_url)

    log "Installing Home Manager from $channel_url"
    nix-channel --add "$channel_url" home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    load_nix_profile

    have home-manager || die "Home Manager installation finished, but home-manager is not available on PATH"
}

reload_home_manager() {
    local script_dir

    script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

    log "Running reload.sh to stow configs and switch Home Manager"
    "$script_dir/reload.sh"
    load_nix_profile
}

enable_pyenv() {
    load_nix_profile

    export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
    if [ -d "$HOME/.nix-profile/bin" ]; then
        PATH="$HOME/.nix-profile/bin:$PATH"
    fi
    if [ -d "$PYENV_ROOT/bin" ]; then
        PATH="$PYENV_ROOT/bin:$PATH"
    fi
    export PATH
    hash -r

    have pyenv || die "pyenv is not available on PATH after running reload.sh"
    eval "$(pyenv init - bash)"
    hash -r
}

resolve_pyenv_python_version() {
    local requested="$1"
    local resolved

    if pyenv install --list | awk -v version="$requested" '
        {
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
        }
        $0 == version {
            found = 1
        }
        END {
            exit !found
        }
    '; then
        printf '%s\n' "$requested"
        return
    fi

    if [[ "$requested" =~ ^[0-9]+[.][0-9]+$ ]]; then
        resolved=$(
            pyenv install --list |
                awk -v prefix="$requested." '
                    {
                        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
                    }
                    index($0, prefix) == 1 && $0 ~ /^[0-9]+[.][0-9]+[.][0-9]+$/ {
                        print $0
                    }
                ' |
                sort -V |
                tail -n 1
        )

        [ -n "$resolved" ] || die "pyenv does not list an installable Python $requested release"
        printf '%s\n' "$resolved"
        return
    fi

    printf '%s\n' "$requested"
}

install_pyenv_python() {
    local requested_python_version="${PYENV_PYTHON_VERSION:-3.11}"
    local python_version

    enable_pyenv
    python_version=$(resolve_pyenv_python_version "$requested_python_version")

    if [ "$python_version" != "$requested_python_version" ]; then
        log "Resolved Python $requested_python_version to pyenv version $python_version"
    fi

    log "Installing Python $python_version with pyenv"
    pyenv install -s "$python_version"
    pyenv global "$python_version"
    pyenv rehash

    pyenv versions --bare | grep -Fx "$python_version" >/dev/null ||
        die "Python $python_version installation finished, but pyenv does not list it"

    [ "$(pyenv global)" = "$python_version" ] ||
        die "Python $python_version installation finished, but pyenv global is set to $(pyenv global)"
}

load_cargo_env() {
    if [ -r "$HOME/.cargo/env" ]; then
        # shellcheck disable=SC1090
        . "$HOME/.cargo/env"
    fi

    hash -r
}

install_rustup_and_cargo() {
    load_cargo_env

    if have rustup && have cargo; then
        log "rustup and cargo are already installed"
        return
    fi

    log "Installing rustup and cargo"
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
    load_cargo_env

    have rustup || die "rustup installation finished, but rustup is not available on PATH"
    have cargo || die "rustup installation finished, but cargo is not available on PATH"
}

alacritty_installed_with_cargo() {
    have cargo || return 1
    cargo install --list | awk '$1 == "alacritty" { found=1 } END { exit !found }'
}

install_alacritty() {
    install_rustup_and_cargo
    install_system_packages \
        libfontconfig1-dev \
        libxcb-xfixes0-dev \
        libxkbcommon-dev

    if alacritty_installed_with_cargo; then
        log "Alacritty is already installed with Cargo"
        return
    fi

    log "Installing Alacritty with Cargo"
    cargo install alacritty
    load_cargo_env

    alacritty_installed_with_cargo || die "Alacritty installation finished, but Cargo does not list it as installed"
    have alacritty || die "Alacritty installation finished, but alacritty is not available on PATH"
}

install_i3() {
    if have i3; then
        log "i3 is already installed"
        return
    fi

    install_system_packages i3
    have i3 || die "i3 package installed, but i3 is not available on PATH"
}

main() {
    check_supported_os
    install_core_packages
    install_python_build_dependencies
    install_0xproto_nerd_font
    install_nix
    install_home_manager
    reload_home_manager
    install_pyenv_python
    install_rustup_and_cargo
    install_alacritty
    install_i3
    log "Bootstrap complete."
}

main "$@"
