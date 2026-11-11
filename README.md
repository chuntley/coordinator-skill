# Coordinator

A Claude Code skill for leading coding agents across multiple workstreams in one repository. The coordinator stays in your main conversation, maintains a prioritized queue, delegates work, manages file ownership, reviews and integrates results, and reports progress with a compact worker table. It defaults to at most three active worker assignments.

## Install

Clone this repository, then copy the skill into your personal Claude Code skills directory to make `/coordinator` available in all projects:

```sh
git clone https://github.com/chuntley/coordinator-skill.git
cd coordinator-skill
mkdir -p ~/.claude/skills/coordinator
cp SKILL.md ~/.claude/skills/coordinator/SKILL.md
```

If you already have a coordinator skill installed, save any local changes before replacing it. To update, run `git pull --ff-only` in this checkout and repeat the copy command.

For installation in a single project instead, run these commands from that project's root, replacing the source path with this checkout's location:

```sh
mkdir -p .claude/skills/coordinator
cp /path/to/coordinator-skill/SKILL.md .claude/skills/coordinator/SKILL.md
```

Commit the project's `.claude/skills/coordinator/SKILL.md` to share it with collaborators. See the [Claude Code skills documentation](https://code.claude.com/docs/en/skills).

## Enable experimental agent teams

**Enable Claude Code's experimental agent teams support for the full coordinator workflow to work.** Merge this setting into `~/.claude/settings.json`, preserving any existing settings:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

Alternatively, launch Claude Code from a shell with the flag enabled:

```sh
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 claude
```

Start a new interactive Claude Code session after changing settings. Agent teams are experimental and use more tokens than a single session. The skill can fall back to subagents when native teams are unavailable. See [Anthropic's agent teams setup and limitations](https://code.claude.com/docs/en/agent-teams).

## Use

In Claude Code, invoke the skill with a goal:

```text
/coordinator Build the API and dashboard, with separate workers for each.
```

Then steer the work in plain language: add or reprioritize tasks, pause a workstream, or ask for progress.

- `/coordinator status` reports the queue and worker states without changing work.
- `/coordinator stop` safely winds down the team and reports unfinished work.

[SKILL.md](SKILL.md) is the source of the coordinator's instructions. Edit it here, then copy it to your installation to apply changes.
