#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Config
# -----------------------------
PKG_LIST="${1:-packages.txt}"   # pass a file path or default to packages.txt
NONINTERACTIVE="${NONINTERACTIVE:-0}"  # set to 1 to skip prompts
PAC_OPTS=${PAC_OPTS:-"--needed --noconfirm"}
YAY_OPTS=${YAY_OPTS:-"--needed --noconfirm"}
declare -a ALREADY INST_OFFICIAL INST_AUR FAILED
ALREADY=(); INST_OFFICIAL=(); INST_AUR=(); FAILED=()
# -----------------------------


# --- helpers ---------------------------------------------------------------
die() { echo "Error: $*" >&2; exit 1; }
have() { command -v "$1" &>/dev/null; }

# Read and sanitize package list
[[ -f "$PKG_LIST" ]] || die "Package list file not found: $PKG_LIST"

mapfile -t ALL_PKGS < <(sed -E 's/#.*$//' "$PKG_LIST" | tr -d '\r' | awk 'NF' | sort -u)
[[ ${#ALL_PKGS[@]} -gt 0 ]] || die "No packages found in $PKG_LIST"

# Pretty title
gum style --border double --margin "1 2" --padding "1 2" \
  --border-foreground 212 "Arch Installer with gum" \
  "Source: $PKG_LIST" \
  "Mode: $( [[ "$NONINTERACTIVE" = 1 ]] && echo non-interactive || echo interactive )"

# Choose which packages to process
if [[ "$NONINTERACTIVE" = 1 ]]; then
  SELECTED_PKGS=("${ALL_PKGS[@]}")
else
  gum style --foreground 245 "Select packages to install (↑/↓ to move, Space to toggle, Enter to confirm)"
  # gum choose supports --no-limit? actually --no-limit selects at most one; for multi use --no-limit=false? Gum uses --no-limit to allow multiple. We'll use --no-limit.
  mapfile -t SELECTED_PKGS < <(printf '%s\n' "${ALL_PKGS[@]}" | gum choose --no-limit)
  [[ ${#SELECTED_PKGS[@]} -gt 0 ]] || die "Nothing selected."
fi

# Confirmation
if [[ "$NONINTERACTIVE" != 1 ]]; then
  gum confirm "Proceed to check & install ${#SELECTED_PKGS[@]} package(s)?" || exit 0
fi

# Buckets
declare -a ALREADY INST_OFFICIAL INST_AUR FAILED

# Function: check if installed
is_installed() {
  pacman -Qq "$1" &>/dev/null
}

# Function: in official repos?
in_official() {
  pacman -Si "$1" &>/dev/null
}

# Spinner wrapper
spin() {
  local msg="$1"; shift
  gum spin --title "$msg" --spinner line -- "$@"
}

# Pass 1: classify
gum style --foreground 245 "Analyzing packages..."
for pkg in "${SELECTED_PKGS[@]}"; do
  if is_installed "$pkg"; then
    ALREADY+=("$pkg")
    continue
  fi
  if in_official "$pkg"; then
    INST_OFFICIAL+=("$pkg")
  else
    # Not in official repos → try AUR (yay can also handle repo pkgs, but we prefer pacman first)
    INST_AUR+=("$pkg")
  fi
done

# Show plan
gum style --border normal --padding "0 1" --border-foreground 60 \
  "$(gum style --foreground 36 "Official repo:") $( [[ ${#INST_OFFICIAL[@]} -gt 0 ]] && printf '%s ' "${INST_OFFICIAL[@]}" || echo '(none)')" \
  "$(gum style --foreground 178 "AUR via yay:") $( [[ ${#INST_AUR[@]} -gt 0 ]] && printf '%s ' "${INST_AUR[@]}" || echo '(none)')" \
  "$(gum style --foreground 244 "Already installed:") $( [[ ${#ALREADY[@]} -gt 0 ]] && printf '%s ' "${ALREADY[@]}" || echo '(none)')"

if [[ "$NONINTERACTIVE" != 1 ]]; then
  gum confirm "Install now?" || exit 0
fi

# Pass 2: install
# Official
if [[ ${#INST_OFFICIAL[@]} -gt 0 ]]; then
  spin "Installing from official repos: ${#INST_OFFICIAL[@]} pkg(s)" \
    bash -c "sudo pacman -S ${INST_OFFICIAL[*]} $PAC_OPTS" \
    || { (( ${#INST_OFFICIAL[@]} )) && FAILED+=("${INST_OFFICIAL[@]}"); }
fi

# AUR
if [[ ${#INST_AUR[@]} -gt 0 ]]; then
  spin "Installing from AUR via yay: ${#INST_AUR[@]} pkg(s)" \
    bash -c "yay -S ${INST_AUR[*]} $YAY_OPTS" \
    || { (( ${#INST_AUR[@]} )) && FAILED+=("${INST_AUR[@]}"); }
fi

# Final report
echo
gum style --border rounded --padding "1 2" --border-foreground 35 "Done."

# Re-check to make accurate summary
declare -a NOW_INSTALLED
for pkg in "${SELECTED_PKGS[@]}"; do
  if is_installed "$pkg"; then
    NOW_INSTALLED+=("$pkg")
  fi
done

# Build nice summary lines
summ_already=$( (( ${#ALREADY[@]} )) && printf '%s ' "${ALREADY[@]}" || echo '(none)' )
summ_now=$( (( ${#NOW_INSTALLED[@]} )) && printf '%s ' "${NOW_INSTALLED[@]}" || echo '(none)' )

if (( ${#FAILED[@]} )); then
  mapfile -t FAILED < <(printf '%s\n' "${FAILED[@]}" | sort -u)
  summ_failed=$(printf '%s ' "${FAILED[@]}")
else
  summ_failed="(none)"
fi

gum style --border normal --padding "0 1" --border-foreground 60 \
  "$(gum style --foreground 36  "Official repo:") $(
      if (( ${#INST_OFFICIAL[@]} )); then printf '%s ' "${INST_OFFICIAL[@]}"; else echo '(none)'; fi
    )" \
  "$(gum style --foreground 178 "AUR via yay:") $(
      if (( ${#INST_AUR[@]} )); then printf '%s ' "${INST_AUR[@]}"; else echo '(none)'; fi
    )" \
  "$(gum style --foreground 244 "Already installed:") $(
      if (( ${#ALREADY[@]} )); then printf '%s ' "${ALREADY[@]}"; else echo '(none)'; fi
    )"

# Optional: show logs on failure
if [[ "$summ_failed" != "(none)" && "$NONINTERACTIVE" != 1 ]]; then
  gum confirm "Open pacman/yay logs (journalctl)?" && \
    journalctl -u pacman-init.service --no-pager -n 200 2>/dev/null || true
fi