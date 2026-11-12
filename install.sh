#!/usr/bin/env bash
# Keep execution at the end so an incomplete script cannot start installation.
install_skill() (
  set -eu
  harness="$1"
  target="$2"
  mkdir -p "$target"
  temporary=$(mktemp "$target/.SKILL.md.XXXXXX")
  trap 'rm -f "$temporary"' EXIT
  trap 'exit 1' HUP INT TERM

  curl -fsSL --connect-timeout 15 --max-time 120 --retry 3 \
    "https://raw.githubusercontent.com/chuntley/coordinator-skill/main/$harness/SKILL.md" \
    -o "$temporary"

  if [ "$(head -n 1 "$temporary")" != '---' ] ||
     ! grep -qx 'name: coordinator' "$temporary" ||
     ! grep -qx '# Coordinator' "$temporary"; then
    printf '%s\n' 'Download is not the expected coordinator skill; existing installation preserved.' >&2
    exit 1
  fi
  if [ -e "$target/SKILL.md" ] || [ -L "$target/SKILL.md" ]; then
    if cmp -s "$temporary" "$target/SKILL.md"; then
      printf 'Already up to date: %s/SKILL.md\n' "$target"
      exit 0
    fi
    backup=$(mktemp "$target/SKILL.md.backup.XXXXXX")
    cp -p "$target/SKILL.md" "$backup"
    printf 'Previous skill saved to %s\n' "$backup"
  fi
  chmod 644 "$temporary"
  mv -f "$temporary" "$target/SKILL.md"
  printf 'Installed %s/SKILL.md\n' "$target"
)

main() (
  set -eu
  if [ "$#" -ne 0 ]; then
    printf '%s\n' 'Run install.sh without arguments to choose your agent.' >&2
    exit 1
  fi
  : "${HOME:?HOME must be set}"
  command -v curl >/dev/null 2>&1 || {
    printf '%s\n' 'curl is required.' >&2
    exit 1
  }

  # Use the terminal directly so curl | bash can prompt.
  if ! { exec 3<>/dev/tty; } 2>/dev/null; then
    printf '%s\n' 'Run this installer from an interactive terminal.' >&2
    exit 1
  fi
  printf '%s\n' 'Install Coordinator for:' '  1) Claude Code' '  2) OpenAI Codex' '  3) Both' >&3
  selection=''
  while [ -z "$selection" ]; do
    printf 'Choose [1-3]: ' >&3
    if ! IFS= read -r choice <&3; then
      printf '\nInstallation cancelled.\n' >&2
      exit 1
    fi
    case "$choice" in
      1) selection=claude ;;
      2) selection=codex ;;
      3) selection=both ;;
      *) printf '%s\n' 'Enter 1, 2, or 3.' >&3 ;;
    esac
  done
  exec 3>&-

  case "$selection" in
    claude|both)
      install_skill claude "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/coordinator"
      printf '%s\n' 'Claude Code: enable agent teams as described in README.md, then use /coordinator.'
      ;;
  esac
  case "$selection" in
    codex|both)
      install_skill codex "$HOME/.agents/skills/coordinator"
      printf '%s\n' "Codex: start a new session and use \$coordinator. See README.md."
      ;;
  esac
)

main "$@"
