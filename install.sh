#!/usr/bin/env bash
# Keep execution at the end so an incomplete script cannot start installation.
main() (
  set -eu

  case "${1:-}" in
    '')
      if [ "$#" -ne 0 ]; then
        printf '%s\n' 'Unexpected empty argument.' >&2
        exit 1
      fi
      : "${HOME:?HOME must be set}"
      target="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/coordinator"
      ;;
    --project)
      target="$PWD/.claude/skills/coordinator"
      ;;
    --help|-h)
      printf '%s\n' 'Usage: install.sh [--project]' \
        'Default: install for all projects in ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/coordinator.' \
        '--project: install in the current project .claude/skills/coordinator directory.'
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      exit 1
      ;;
  esac
  if [ "$#" -gt 1 ]; then
    printf '%s\n' 'Too many arguments. Use --help for usage.' >&2
    exit 1
  fi

  command -v curl >/dev/null 2>&1 || {
    printf '%s\n' 'curl is required.' >&2
    exit 1
  }
  mkdir -p "$target"
  temporary=$(mktemp "$target/.SKILL.md.XXXXXX")
  trap 'rm -f "$temporary"' EXIT
  trap 'exit 1' HUP INT TERM

  curl --fail --silent --show-error --location \
    --proto '=https' --proto-redir '=https' \
    --connect-timeout 15 --max-time 120 --retry 3 \
    https://raw.githubusercontent.com/chuntley/coordinator-skill/main/SKILL.md \
    -o "$temporary"

  # Reject empty downloads, HTML error pages, and unexpected skill files.
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
  printf '%s\n' 'Enable CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1, then start Claude Code and use /coordinator.'
)

main "$@"
