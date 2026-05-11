#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# AdStrike v5.0 «AdStrike» — Installer
# Tested on Kali Linux 2024+ / Parrot OS
# AUTHORISED PENETRATION TESTING ONLY
# ══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

RED='\033[91m'; GRN='\033[92m'; YLW='\033[93m'; PNK='\033[38;5;201m'
CYN='\033[96m'; DIM='\033[2m';  RST='\033[0m'; BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/adrt_venv"
REQ_FILE="$SCRIPT_DIR/requirements.txt"

banner() {
    echo -e "${PNK}${BOLD}"
    echo "     ___       __   _____ __       _ __       "
    echo "    /   | ____/ /  / ___// /______(_) /_____ "
    echo "   / /| |/ __  /   \\__ \\/ __/ ___/ / //_/ _ \\"
    echo "  / ___ / /_/ /   ___/ / /_/ /  / / ,< /  __/"
    echo " /_/  |_\\__,_/   /____/\\__/_/  /_/_/|_|\\___/ "
    echo -e "${RST}"
    echo -e "  ${CYN}${BOLD}AdStrike v5.0 — Installer${RST}  ${DIM}56 modules · 8 kill-chain phases${RST}"
    echo -e "  ${DIM}──────────────────────────────────────────────────────────────────${RST}"
    echo
}

step() { echo -e "\n  ${CYN}[*]${RST} ${BOLD}$*${RST}"; }
ok()   { echo -e "  ${GRN}[+]${RST} $*"; }
warn() { echo -e "  ${YLW}[!]${RST} $*"; }
die()  { echo -e "  ${RED}[-]${RST} $* — aborting"; exit 1; }

banner

# Do not run the installer itself as root. It creates repo-local files such as
# adrt_venv/ and .env; root-owned artifacts break normal-user runs. The script
# uses sudo only for system package installation.
if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    die "Do not run install.sh with sudo. Run: bash install.sh"
fi

# ── Python version check ──────────────────────────────────────────────────────
step "Checking Python version"
command -v python3 &>/dev/null || die "python3 not found"
PY_VER=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
PY_MINOR=$(echo "$PY_VER" | cut -d. -f2)
(( PY_MINOR >= 10 )) || die "Python $PY_VER detected — requires 3.10+"
ok "Python $PY_VER"

# ── APT — install system packages ────────────────────────────────────────────
step "Installing system packages"
sudo apt-get update -qq 2>/dev/null || warn "apt update had warnings — continuing"

APT_PKGS=(
    impacket-scripts crackmapexec evil-winrm
    bloodhound bloodhound-python
    ldap-utils smbclient enum4linux-ng
    hashcat john hydra
    nmap masscan nbtscan netdiscover
    responder
    krb5-user dnsutils samba-common-bin
    net-tools git wget curl zip unzip
    python3-pip python3-venv python3-dev
)

sudo apt-get install -y -qq "${APT_PKGS[@]}" 2>/dev/null \
    && ok "System packages installed" \
    || warn "Some apt packages failed — check manually"

# ── Python virtual environment ────────────────────────────────────────────────
step "Setting up virtual environment → adrt_venv/"
if [[ ! -d "$VENV_DIR" ]]; then
    python3 -m venv "$VENV_DIR"
    ok "venv created"
else
    ok "venv already exists"
fi

PIP="$VENV_DIR/bin/pip"

step "Upgrading pip / setuptools / wheel"
"$PIP" install -q --upgrade pip setuptools wheel && ok "pip upgraded"

step "Installing Python dependencies"
[[ -f "$REQ_FILE" ]] && "$PIP" install -q -r "$REQ_FILE" && ok "requirements.txt installed"

step "Installing extra pip-only tools"
for pkg in netexec certipy-ad bloodhound mitm6 lsassy dploot roadrecon roadtx coercer ldap3; do
    "$PIP" install -q "$pkg" 2>/dev/null && ok "$pkg" \
        || warn "$pkg failed — may already be installed system-wide"
done

# ── krbrelayx / dnstool.py ───────────────────────────────────────────────────
step "Checking krbrelayx dnstool.py"
TOOLS_DIR="$SCRIPT_DIR/tools"
if command -v dnstool.py &>/dev/null || [[ -f /opt/krbrelayx/dnstool.py ]] || [[ -f "$TOOLS_DIR/krbrelayx/dnstool.py" ]]; then
    ok "dnstool.py found"
elif command -v git &>/dev/null; then
    sudo git clone -q https://github.com/dirkjanm/krbrelayx /opt/krbrelayx 2>/dev/null \
        && ok "krbrelayx cloned to /opt/krbrelayx" \
        || {
            mkdir -p "$TOOLS_DIR"
            git clone -q https://github.com/dirkjanm/krbrelayx "$TOOLS_DIR/krbrelayx" 2>/dev/null \
                && ok "krbrelayx cloned to tools/krbrelayx" \
                || warn "krbrelayx clone failed — install manually for ADIDNS write actions"
        }
else
    warn "git not found — install krbrelayx manually for ADIDNS write actions"
fi

# ── Fix nxc impacket import (regsecrets.py missing from pip impacket) ────────
step "Fixing impacket/nxc version compatibility"
# System nxc was built against system impacket which has gkdi.py, dpapi_ng.py,
# WIN_VERSIONS etc. The pip-installed impacket (0.14.0) is missing these.
# The _nxc() agent wrapper sets PYTHONPATH to use system impacket for nxc calls.
# As a belt-and-suspenders fix, also copy the missing files to pip impacket.
PIP_IMP=$(python3 -c "import impacket, os; print(os.path.dirname(impacket.__file__))" 2>/dev/null || true)
SYS_IMP="/usr/lib/python3/dist-packages/impacket"
if [[ -n "$PIP_IMP" && -d "$SYS_IMP" ]]; then
    copied=0
    for f in dpapi_ng.py msada_guids.py regsecrets.py; do
        if [[ -f "$SYS_IMP/$f" && ! -f "$PIP_IMP/$f" ]]; then
            cp "$SYS_IMP/$f" "$PIP_IMP/$f" && ((copied++)) || true
        fi
    done
    for f in gkdi.py icpr.py tsts.py; do
        if [[ -f "$SYS_IMP/dcerpc/v5/$f" && ! -f "$PIP_IMP/dcerpc/v5/$f" ]]; then
            cp "$SYS_IMP/dcerpc/v5/$f" "$PIP_IMP/dcerpc/v5/$f" && ((copied++)) || true
        fi
    done
    # Always overwrite utils.py — system version has parse_identity needed by getTGT.py
    if [[ -f "$SYS_IMP/examples/utils.py" ]]; then
        cp "$SYS_IMP/examples/utils.py" "$PIP_IMP/examples/utils.py" && ((copied++)) || true
    fi
    ok "impacket compatibility: $copied missing files synced from system to pip"
else
    warn "Could not sync impacket files — nxc ldap may have import errors"
    warn "Workaround: the agent uses PYTHONPATH fix automatically"
fi

# ── kerbrute ─────────────────────────────────────────────────────────────────
step "Checking kerbrute"
if command -v kerbrute &>/dev/null; then
    ok "kerbrute found in PATH"
else
    warn "kerbrute not found — install manually:"
    echo -e "  ${DIM}https://github.com/ropnop/kerbrute/releases${RST}"
    echo -e "  ${DIM}sudo install -m 755 kerbrute_linux_amd64 /usr/local/bin/kerbrute${RST}"
fi

# ── .env setup ────────────────────────────────────────────────────────────────
step "Setting up .env"
if [[ ! -f "$SCRIPT_DIR/.env" ]]; then
    cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
    ok ".env created from template — edit with your engagement details"
else
    ok ".env already exists"
fi

mkdir -p "$SCRIPT_DIR/output"

# ── Done ─────────────────────────────────────────────────────────────────────
echo
echo -e "  ${RED}──────────────────────────────────────────────────────────────────${RST}"
echo -e "  ${GRN}${BOLD} Installation complete!${RST}"
echo -e "  ${RED}──────────────────────────────────────────────────────────────────${RST}"
echo
echo -e "  ${CYN}Run:${RST}  ${BOLD}bash run.sh${RST}  or  ${BOLD}source adrt_venv/bin/activate && python3 main.py${RST}"
echo -e "  ${DIM}For authorised penetration testing only.${RST}"
echo
