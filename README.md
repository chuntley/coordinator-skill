# Coordinator

A Claude Code and OpenAI Codex skill for leading coding agents across multiple workstreams in one repository. The coordinator stays in your main conversation, maintains a prioritized queue, delegates work, manages file ownership, reviews and integrates results, and reports progress with a compact worker table. It defaults to three active worker assignments and asks for user approval before increasing concurrency beyond three.

## Install

Run with Bash and curl:

```sh
curl -fsSL https://raw.githubusercontent.com/chuntley/coordinator-skill/main/install.sh | bash
```

Choose Claude Code, OpenAI Codex, or both when prompted. The skill installs for your user:

| Agent | Installation directory |
| --- | --- |
| Claude Code | `~/.claude/skills/coordinator` (or under `CLAUDE_CONFIG_DIR` if set) |
| OpenAI Codex | `~/.agents/skills/coordinator` |

Rerun the command to update. The installer backs up changed versions and preserves the existing skill if a download fails. It does not change agent settings.

## Agent setup

### Claude Code: enable experimental agent teams

Merge this setting into `~/.claude/settings.json` (or your `CLAUDE_CONFIG_DIR/settings.json`), preserving existing settings:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

Start a new interactive Claude Code session after changing settings. Agent teams are experimental and use more tokens than a single session. The skill can fall back to subagents when native teams are unavailable. See [Anthropic's agent teams setup and limitations](https://code.claude.com/docs/en/agent-teams).

### OpenAI Codex: subagents

Use a current Codex release with subagent support. Current releases enable subagent workflows by default; see the [official subagent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents). Subagents consume additional tokens. The coordinator respects session agent limits, even when you approve more than three workers. If subagent tools are unavailable, it reports that limitation and runs the queue sequentially.

## Use

Start a new session in your target repository and invoke the skill with a goal.

In Claude Code:

```text
/coordinator Build the API and dashboard, with separate workers for each.
```

In OpenAI Codex:

```text
$coordinator Build the API and dashboard, with separate workers for each.
```

Then steer the work in plain language: add or reprioritize tasks, pause a workstream, or ask for progress.

| Action | Claude Code | OpenAI Codex |
| --- | --- | --- |
| Report the queue and worker states without changing work | `/coordinator status` | `$coordinator status` |
| Safely wind down workers and report unfinished work | `/coordinator stop` | `$coordinator stop` |

If the Codex skill does not appear, restart Codex and check `/skills` in the CLI or IDE extension. See the [official skills documentation](https://learn.chatgpt.com/docs/build-skills) for discovery and invocation.

## Skill sources

[claude/SKILL.md](claude/SKILL.md) contains the Claude Code instructions; [codex/SKILL.md](codex/SKILL.md) contains the Codex instructions. Keep shared workflow rules aligned while preserving each version’s worker lifecycle and invocation instructions. Edit the appropriate source when updating the skill.
