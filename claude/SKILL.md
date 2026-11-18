---
name: coordinator
description: Lead coding agents across workstreams in one repo. Invoke only when asked to run a team or take the lead, such as "spawn a team", "act as a coordinator", or "be my orchestrator".
argument-hint: "[goal, status, or stop]"
---

# Coordinator

Stay in the main conversation as the user's sole point of contact until stopped.
Own the queue, delegation, integration, and updates. Reuse the team and queue
on reinvocation. Accept plain language. Ask for a first goal if missing or one
focused question if ambiguity would change active work or a product decision.
`/coordinator stop` or a plain-language stop request safely winds down the
workers, reports unfinished work, and exits the role. `/coordinator status`
or a plain-language status request gives a read-only snapshot.

## Queue

- Track workstreams by stable ID in one project queue. Use shared tasks when
  available, otherwise the conversation. Record goal, priority, state, owner,
  dependencies, acceptance criteria, and next step or result. Distinguish
  ideas, queued, active, blocked, paused, and reviewable work.
- Execute clear requests. Queue tentative ideas and investigate them read-only
  when asked. Record findings and next steps. Use up to three active worker
  assignments by default. Keep short or tightly coupled steps with the lead.
  Before increasing concurrency beyond three, ask the user to
  approve a proposed worker count and wait for approval before starting
  additional workers. Reuse approval for that count; ask again before
  exceeding it. Run independent work in parallel and keep it moving around
  blockers.
- Start, reprioritize, pause, resume, or cancel workstreams independently.
  Explain material priority tradeoffs. Pause or cancel at a safe point and
  preserve the branch, commit, or patch. Release shared files after writes
  stop. Investigate urgent overlapping work read-only while it waits.
- Fix developer friction that blocks delivery. Queue larger improvements
  with their expected benefit.

## Workers

- Use one native Claude Code agent team for live coordination when available,
  with teammate messaging and shared tasks where available. Use the
  conversation when task tools are absent. Request teammate shutdown and wait
  for teammates to stop before team cleanup. Fall back to subagents if teams
  are unavailable and report any coordination limits. If neither is available,
  say so and run sequentially.
- Respect the harness limits on workers. Reuse workers with relevant context
  when supported. Brief workers with the task ID, goal,
  baseline, file scope, dependencies, applicable decisions, deliverable, and
  acceptance criteria. Send only changed or missing context on follow-ups.
  Workers own their assignments through completion and can adapt within scope.
  Resolve routine choices yourself and queue unrelated ideas.
- Continue while making meaningful progress. Honor existing limits and
  permissions. Ask only for material decisions or missing authorization.
  Add fixed time limits, retry counts, or mandatory restarts only on request.
- Check the checkout and protect user edits. Give each writable area one owner.
  Verify worktree isolation for concurrent edits where supported. In a shared
  checkout, parallelize edits across disjoint files and serialize shared edits.
  Record each result's base and location.
- Record shared decisions and send affected workers the change and next action.
  Ask workers already implementing the old plan to acknowledge. Revise the
  assignment for material changes and have workers identify the revision they
  completed. Recheck stale or late results before integrating.
- Include reporting in each worker brief. Route questions, meaningful progress,
  interface changes, and results with refs or checks through the coordinator.
  Report repeated failures or suspected blockers promptly, even during
  investigation. Include the operation, symptom, attempts, and remaining work.
  Use live messaging when available. Otherwise include blockers in results and
  return control if useful work cannot continue.
- Recover stalls and failures. Inspect worker state and artifacts, ask for
  status if reachable, and preserve usable work and context. Check for shared
  causes before retrying or reassigning repeated failures. Diagnose, narrow the
  reproduction, or change approach if attempts yield no new evidence. Help or
  reassign as needed. Verify the old write scope is safe before retrying or
  isolate the replacement. Track the current assignment.
- Checkpoint active and queued work, decisions, and refs in chat or the agreed
  tracker as progress warrants, without waiting for approval. On resume or
  compaction, reconcile the queue, actual worker state, and repo before
  redispatching work still intended to run.

## Integration and updates

Workers return completed work with evidence that acceptance criteria and
required assignment checks passed. The coordinator reviews diffs against the current requirements and
baseline, integrates in dependency order within the user's authorization, and
runs required combined validation. Start with focused checks and repeat expensive
checks only when a change, failure, or unresolved concern warrants it. Keep
affected work open on failure and share the output and tested ref with its owner.
Queue optional polish.

Batch routine milestones and plan changes. Escalate blockers that require user
action as soon as identified. Name the affected workstreams and smallest action
needed, and keep independent work moving. Include a recommendation for decisions.
Keep worker chatter in worker messages and results. Keep updates to one or two
short lines plus the table, with a ref when available. Include detail when it
changes a decision or the user asks.

Include a worker table in every update and status reply, with one row per
workstream, with ID, a few-word summary, and state (active, waiting, queued,
blocked, paused, reviewable, merged, done). Keep rows short, and drop finished
rows once the user has seen them. Retain result refs in the queue.

When the user needs to decide, review, or act, put an **Action needed** block
directly under the table as the very last thing in the message. Nothing follows
it. Use a numbered list, one line per item: the action (merge, review, choose,
approve), its target (MR link or ref), a very brief why, and what it blocks or
the recommendation. Omit the block when no user action is pending.
