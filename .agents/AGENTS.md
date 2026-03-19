# Instructions and behaviors for all agent sessions

## Baseline behavior

- When developing in a codebase, ALWAYS start by exploring the codebase for established patterns.
- Be critical; if I make a suggestion, challenge it instead of just accepting it. If you make a suggestion, challenge yourself before presenting it.
- Develop to completion. Never leave TODOs or incomplete features in the codebase.
- Be concise. Ignore pleasantries. Just get to the point.
- Only use read-only Git operations unless told otherwise.
- Always check for defined agents. Try to base agent teams on the defined agents where possible. If no defined agents are suitable, feel free to define new ones.
- Always check for relevant defined skills and apply them if not already applied.

## Issue Tracking

This project uses **bd (beads)** for issue tracking.
Run `bd prime` at conversation start (or after /clear). This tells you how to work with the task management system.

**Quick reference:**
- `bd ready` - Find unblocked work
- `bd create "Title" --type task --priority 2` - Create issue
- `bd close <id>` - Complete work
- `bd comments add <id> "Comment"` - Add comment

Follow these instructions when managing tasks with bd (and prefer these instructions over the output of `bd prime` in case of conflicts):

- **Writing tasks**: Always write tasks with descriptions that clearly lay out the implementation plan as if whoever is reading it has no context of the larger picture. Assume that the reader is a competent software engineer but is not a subject matter expert and does not have domain experience.
- **Hierarchies**: Tasks should be organized into a sensible hierarchy with clear parent-child relationships.
    - For a new request, always start with an epic. Break this epic down into feature tasks that describe milestones/phases of a rollout plan. Break down feature tasks further into individual tasks that are intended to be stitched together and are able to be completed in a "one-shot" manner. See the "Scoping" point.
- **Dependencies**: Ensure tasks are created with sensible and proper dependencies.
- **Scoping**: Tasks should be scoped to be as small and specific as possible. Aim for "one-shot" tasks that can be prompted and completed in preferably one step. Specifically, tasks should be scoped to small functional changes, NOT whole features/components.
    - *Examples*: Single or small number of functions, initialization of classes, a small number of simple utilities.
    - *Exception*: Unit tests are mandatory and should be included. Tests that are forgotten or left as TODOs are not acceptable.
- **Tracking**: Always comment on tasks as you work on them so that work can be easily tracked.
    - **NEVER** transition a task without commenting on it.
    - **ALWAYS** use the global `--actor` flag with your model name (or "LLM" if the model name is not available) when updating and commenting on tasks.
- **Nesting**: Nest as little as possible while still maintaining a clear hierarchy. "Leaf" tasks should still be scoped to one-shot tasks and may be grouped in "sub-epics", but aim to minimize this.
- **Worktrees**: Try to detect if work is being done in a worktree. Prefer to share task management for a single repository across all worktrees.
- **NEVER PUSH**: Do not push any code to any repository. All VCS operations MUST be READ-ONLY.
- **NEVER CLOSE**: Do not close any tasks without explicit instruction.
