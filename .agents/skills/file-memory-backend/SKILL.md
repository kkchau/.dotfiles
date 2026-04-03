---
name: file-memory-backend
description: Defines a file-tree-based memory backend for durable issue tracking, comment history, and status management. Provides the persistence layer for structured agent workflows using an Epic > Milestone > Task hierarchy with JSON-backed storage. Use this when a workflow requires some memory backend.
---

## Overview

This skill defines a **file-tree memory backend** — a local, human-readable persistence layer for tracking structured work across agent sessions. It provides durable storage for issues (epics, milestones, tasks), their comments, status transitions, and accumulated context using plain JSON files on the filesystem.

The backend is designed to be the **source of truth** that outlives any single workflow execution, agent session, or runtime checkpoint. Any agent with a fresh context window can read the file tree and fully reconstruct what was planned, what was tried, what failed, and what was decided.

## When to Use

Use this skill when a workflow or agent system needs:

- **Durable issue tracking** that persists across sessions, crashes, and agent restarts
- **Structured comment history** as an audit trail for agent actions, decisions, and feedback
- **Status management** for hierarchical work items (epic > milestone > task)
- **Human-readable persistence** that can be inspected with standard filesystem tools
- A **backend-agnostic interface** that could be swapped for bd (beads), a database, or any other issue tracker

## Design Principles

1. **Fresh-context-window invariant**: Every epic, milestone, and task issue must contain enough context that an agent with a completely fresh context window can pick up and execute. This is the fundamental persistence guarantee.
2. **Human-readable by default**: All data is stored as formatted JSON files in a well-known directory structure. Inspect with `ls`, `cat`, `jq`.
3. **Backend-agnostic interface**: The operations defined here (create, read, update, comment, list) map cleanly to any issue tracker. The file-tree layout is one implementation; bd (beads/Dolt) is another.
4. **Append-only comments**: Comments are immutable once written. They form a chronological audit trail. Status transitions, feedback, and decisions are all recorded as comments.
5. **Structural enforcement**: Writes should be enforced by the calling system (e.g., a graph engine), not left to agent discretion. The backend guarantees schema compliance; the caller guarantees that writes happen.

---

## Work Hierarchy

The backend manages a three-level hierarchy:

| Level | Definition | Artifact |
|---|---|---|
| **Epic** | The overall body of work. The top-level issue that a workflow processes. | Epic issue (root of the hierarchy) |
| **Milestone** | A small, independently reviewable chunk of work within an epic. Groups related tasks. The unit of human review. | Milestone issue, child of epic |
| **Task** | A small, well-defined unit of agent execution within a milestone. The unit of autonomous work. | Task issue, child of milestone |

### Key Semantics

- An epic is decomposed into milestones. A milestone is further decomposed into tasks.
- **Milestones** are the unit of human review and deployability. They must be independently deployable, cohesive, and reviewable.
- **Tasks** are the unit of agent execution. They must be well-defined with clear acceptance criteria. Tasks need **not** be independently deployable — a task may produce code that only makes sense in the context of its milestone.
- Tasks within a milestone are **sequential** — each builds on the previous.
- There is no upper limit on milestones per epic — the constraint is on milestone *size*, not count.

---

## File-Tree Layout

All data is stored under a `.saw/` directory at the repository root (configurable).

```
.saw/
  epics/
    <epic-id>/
      issue.json              # Epic issue data
      comments/
        <timestamp>-<seq>.json  # Chronological comment trail
      milestones/
        <milestone-id>/
          issue.json            # Milestone issue data
          comments/
            <timestamp>-<seq>.json
          tasks/
            <task-id>/
              issue.json        # Task issue data
              comments/
                <timestamp>-<seq>.json
```

### ID Generation

- **Epic IDs**: Sequential integers or UUIDs. The backend assigns IDs on creation.
- **Milestone IDs**: Sequential within the epic (e.g., `1`, `2`, `3`).
- **Task IDs**: Sequential within the milestone (e.g., `1`, `2`, `3`).
- **Comment filenames**: `<ISO-8601-timestamp>-<sequence>.json` to guarantee chronological ordering and uniqueness within a single timestamp.

---

## Issue Schema

All issue types share a common structure with type-specific extensions.

### Common Issue Fields

| Field | Type | Description |
|---|---|---|
| `id` | `string` | Unique identifier within its scope |
| `type` | `"epic" \| "milestone" \| "task"` | Issue type |
| `title` | `string` | Short descriptive title |
| `description` | `string` | Full issue description (may be updated over time) |
| `status` | `string` (enum, see below) | Current status |
| `created_at` | `string` (ISO 8601) | Creation timestamp |
| `updated_at` | `string` (ISO 8601) | Last update timestamp |
| `metadata` | `object` | Type-specific metadata (see below) |

### Status Enums

**Epic:**
`"open"` | `"in_progress"` | `"completed"` | `"failed"`

**Milestone:**
`"pending"` | `"in_progress"` | `"completed"` | `"failed"` | `"revision_requested"` | `"skipped"`

**Task:**
`"pending"` | `"in_progress"` | `"completed"` | `"failed"` | `"skipped"`

### Epic Metadata

| Field | Type | Description |
|---|---|---|
| `base_branch` | `string` | Git branch the epic started from |
| `raw_description` | `string` | Original unprocessed input |
| `translated_spec` | `TranslatedSpec \| null` | Structured spec after translation (see below) |
| `milestone_ids` | `string[]` | Ordered list of child milestone IDs |

### Milestone Metadata

| Field | Type | Description |
|---|---|---|
| `epic_id` | `string` | Parent epic ID |
| `spec` | `MilestoneSpec` | Full milestone specification |
| `task_ids` | `string[]` | Ordered list of child task IDs |
| `branch_name` | `string \| null` | Git branch name (set when execution begins) |
| `worktree_path` | `string \| null` | Worktree path (set for parallel milestones) |
| `change_summary` | `ChangeSummary \| null` | Populated after all tasks complete |
| `human_feedback` | `string \| null` | Feedback from human review |

### Task Metadata

| Field | Type | Description |
|---|---|---|
| `epic_id` | `string` | Grandparent epic ID |
| `milestone_id` | `string` | Parent milestone ID |
| `spec` | `TaskSpec` | Full task specification |
| `result` | `TaskResult \| null` | Populated as the task executes |

---

## Specification Schemas

### TranslatedSpec

The output of translating fuzzy human input into a structured, actionable specification.

| Property | Type | Description |
|---|---|---|
| `problem_statement` | `string` | Clear problem statement |
| `scope_in` | `string[]` | What's explicitly in scope |
| `scope_out` | `string[]` | What's explicitly out of scope |
| `technical_constraints` | `string[]` | Technical constraints and dependencies |
| `acceptance_criteria` | `string[]` | Overall epic-level criteria |
| `supplementary_context` | `string[]` | EDD excerpts, discussion summaries, etc. |
| `clarifications` | `object[]` | Question/answer pairs from clarification loops |

All seven properties are required.

### TaskSpec

A well-defined unit of agent work within a milestone.

| Property | Type | Description |
|---|---|---|
| `name` | `string` | Task name |
| `description` | `string` | Task description |
| `acceptance_criteria` | `string[]` | Acceptance criteria for the task |
| `estimated_files` | `string[]` | Files expected to be touched |
| `config` | `TaskConfig` | Complexity assessment and model assignments |

All five properties are required.

### TaskConfig

Complexity and execution configuration for a task, typically set by an orchestrator.

| Property | Type | Description |
|---|---|---|
| `complexity` | `"trivial" \| "low" \| "medium" \| "high" \| "critical"` | Assessed complexity |
| `model_assignments` | `object` (string -> string) | Maps each agent role to a model tier |
| `iteration_overrides` | `object` (string -> integer) | Override default iteration limits |
| `orchestrator_notes` | `string` | Reasoning for the human to review |

All four properties are required.

### MilestoneSpec

A small, reviewable deliverable within an epic.

| Property | Type | Description |
|---|---|---|
| `name` | `string` | Milestone name |
| `description` | `string` | Milestone description |
| `tasks` | `TaskSpec[]` | Ordered tasks to execute sequentially |
| `depends_on` | `integer[]` | Indices of prerequisite milestones |
| `estimated_files` | `string[]` | Union of all task estimated_files |
| `branch_name` | `string` | e.g., `"epic-42/milestone-1"` |
| `worktree_path` | `string \| null` | Set when worktree is created |

All seven properties are required.

---

## Result Schemas

### TaskResult

The output of a single task's execution cycle.

| Property | Type | Description |
|---|---|---|
| `spec` | `TaskSpec` | The task specification |
| `status` | `"pending" \| "in_progress" \| "completed" \| "failed"` | Current task status |
| `plan` | `string` | Implementation plan |
| `test_files` | `string[]` | Paths to test files written |
| `implementation_files` | `string[]` | Paths to implementation files written |
| `test_run_output` | `string` | stdout/stderr from test execution |
| `reviews` | `object` (reviewer_name -> `ReviewResult`) | Structured review results |
| `commit_shas` | `string[]` | Git commits produced |
| `tdd_iteration_count` | `integer` | Full cycle restart count |
| `test_writing_iterations` | `integer` | Write/verify loop count in current iteration |
| `implementation_iterations` | `integer` | Implement/test/review loop count in current iteration |
| `accumulated_feedback` | `string[]` | Feedback from all failed iterations |

All twelve properties are required.

### ReviewResult

A single reviewer's verdict on a piece of work.

| Property | Type | Description |
|---|---|---|
| `reviewer` | `"correctness" \| "quality" \| "security"` | Reviewer role |
| `verdict` | `"pass" \| "fail"` | Pass or fail |
| `details` | `string` | Explanation of the verdict |
| `suggestions` | `string[]` | Specific actionable feedback |

All four properties are required.

### MilestoneResult

The cumulative output of all tasks in a milestone.

| Property | Type | Description |
|---|---|---|
| `spec` | `MilestoneSpec` | The milestone specification |
| `status` | `"pending" \| "in_progress" \| "completed" \| "failed" \| "revision_requested"` | Current status |
| `task_results` | `TaskResult[]` | Results for each task in order |
| `change_summary` | `ChangeSummary` | Structured change metadata + narrative |
| `human_feedback` | `string` | Feedback from human review (if revision requested) |

All five properties are required.

### ChangeSummary

Structured summary of a milestone's cumulative changes.

| Property | Type | Description |
|---|---|---|
| `file_changes` | `FileChange[]` | Per-file change details |
| `total_lines_added` | `integer` | Total lines added |
| `total_lines_deleted` | `integer` | Total lines deleted |
| `files_added` | `integer` | Number of new files |
| `files_modified` | `integer` | Number of modified files |
| `files_deleted` | `integer` | Number of deleted files |
| `test_files_count` | `integer` | Number of test files |
| `implementation_files_count` | `integer` | Number of implementation files |
| `commit_count` | `integer` | Total commits across all tasks |
| `commit_shas` | `string[]` | Flattened from all TaskResult commit_shas |
| `narrative` | `string` | LLM-generated summary of what changed and why |

All eleven properties are required.

### FileChange

Per-file change metadata.

| Property | Type | Description |
|---|---|---|
| `path` | `string` | File path |
| `change_type` | `"added" \| "modified" \| "deleted" \| "renamed"` | Type of change |
| `old_path` | `string \| null` | Only set for renames |
| `lines_added` | `integer` | Lines added |
| `lines_deleted` | `integer` | Lines deleted |
| `source_task` | `string` | TaskSpec name that last touched this file |

All six properties are required.

---

## Comment Schema

Comments are the primary audit trail. Every significant event is recorded as a comment on the relevant issue.

### Comment Structure

| Field | Type | Description |
|---|---|---|
| `timestamp` | `string` (ISO 8601) | When the comment was created |
| `author` | `string` | Who created the comment (agent identity, model name, `"human"`, or `"system"`) |
| `record_type` | `string` | Event type (see table below) |
| `data` | `object` | Record-type-specific structured data |

### Record Types

Comments are categorized by record type. Each type has a defined schema for its `data` field.

| Record Type | Issue Level | What Gets Recorded |
|---|---|---|
| `epic_created` | Epic | Raw description, timestamp, agent identity, base branch |
| `epic_claimed` | Epic | Agent identity, timestamp |
| `translation_complete` | Epic | Approved `TranslatedSpec`; deliberation council feedback; clarification Q&A |
| `decomposition_complete` | Epic | Full milestone plan: specs, dependencies, acceptance criteria, estimated files |
| `plan_approved` | Epic | Human edits (if any), final approved milestone list, orchestrator assignments |
| `backward_route` | Epic | Source phase, target phase, reason, human feedback |
| `milestone_initialized` | Milestone | Branch name, worktree path (if parallel), start timestamp |
| `tdd_cycle_start` | Task | Task index, iteration number, plan summary |
| `test_writing_iteration` | Task | Verifier feedback (approve/reject), test file paths |
| `implementation_iteration` | Task | Test results (pass/fail), review verdicts, reviewer feedback |
| `tdd_cycle_retry` | Task | Accumulated feedback, reason for retry |
| `task_escalation` | Task | Orchestrator diagnosis, human guidance |
| `task_completed` | Task | Final result summary, commit SHAs, iteration counts |
| `task_skipped` | Task | Reason for skip |
| `human_review` | Milestone | Approve/revise/reject, human feedback text |
| `rebase_result` | Milestone | Conflict status, affected milestones |
| `milestone_completed` | Milestone | Final diff summary, commit SHAs, iteration counts |
| `epic_completed` | Epic | Summary of all milestones, total iterations, final merge strategy |

---

## Status Transition Rules

### Task Status Transitions

| From | To | Triggered By |
|---|---|---|
| `pending` | `in_progress` | Task execution begins |
| `in_progress` | `completed` | Verifying council accepts (autonomous) |
| `in_progress` | `failed` | TDD budget exhausted and human aborts |
| `in_progress` | `skipped` | Human skips during escalation |

**Tasks are transitioned by agents (autonomous).** The calling system transitions a task to `completed` when the verification criteria are met. No human approval is needed for task-level transitions.

### Milestone Status Transitions

| From | To | Triggered By |
|---|---|---|
| `pending` | `in_progress` | Milestone execution begins (branch/worktree created) |
| `in_progress` | `completed` | Human approves at milestone review |
| `in_progress` | `revision_requested` | Human requests revisions at milestone review |
| `revision_requested` | `in_progress` | Revision work begins |
| `in_progress` | `failed` | Human rejects or aborts |
| `in_progress` | `skipped` | Human skips |

**Milestones are transitioned by humans only.** The backend should never autonomously transition a milestone to `completed`.

### Epic Status Transitions

| From | To | Triggered By |
|---|---|---|
| `open` | `in_progress` | Epic is claimed and work begins |
| `in_progress` | `completed` | All milestones approved by human |
| `in_progress` | `failed` | Unrecoverable failure or human rejects |

**Epics are transitioned by humans only.**

---

## Backend Interface

The following operations define the abstract interface. Any implementation (file-tree, bd, database) must support these.

### Issue Operations

| Operation | Signature | Description |
|---|---|---|
| `create_issue` | `(type, title, description, parent_id?, metadata?) -> id` | Create an issue and return its ID |
| `get_issue` | `(id) -> Issue` | Read an issue by ID |
| `update_issue` | `(id, fields) -> void` | Update issue fields (description, status, metadata) |
| `list_issues` | `(parent_id?, type?, status?) -> Issue[]` | List issues with optional filters |
| `get_children` | `(id) -> Issue[]` | Get all child issues of a given issue |

### Comment Operations

| Operation | Signature | Description |
|---|---|---|
| `add_comment` | `(issue_id, author, record_type, data) -> void` | Append a comment to an issue |
| `get_comments` | `(issue_id, record_type?) -> Comment[]` | Read comments, optionally filtered by type |

### Lifecycle Operations

| Operation | Signature | Description |
|---|---|---|
| `claim` | `(issue_id, agent_identity) -> void` | Mark an issue as claimed/in-progress |
| `transition_status` | `(issue_id, new_status, comment?) -> void` | Transition status with an optional comment |
| `close` | `(issue_id, summary?) -> void` | Close an issue with an optional summary comment |

---

## File-Tree Implementation Notes

### Reading

- To reconstruct the full state of an epic: read `.saw/epics/<id>/issue.json`, then recursively read milestone and task `issue.json` files.
- To reconstruct the history of any issue: read all files in its `comments/` directory in filename order (chronological).
- To find all in-progress work: scan epic `issue.json` files for `status: "in_progress"`.

### Writing

- All writes are atomic at the file level. Write to a temp file and rename to avoid partial writes.
- Comments are append-only. Never modify or delete a comment file.
- Issue `issue.json` files are mutable (status, description, metadata can be updated). Always update `updated_at` on mutation.

### Concurrency

- Parallel milestones in separate worktrees write to separate subtrees (different milestone IDs), so no write contention.
- Epic-level comments from parallel milestones may race. Use timestamp + sequence number in filenames to avoid collisions. If two comments share a timestamp, increment the sequence number.

### Human Inspection

```bash
# View epic status
cat .saw/epics/42/issue.json | jq '.status'

# List all milestones for an epic
ls .saw/epics/42/milestones/

# Read task history
ls .saw/epics/42/milestones/1/tasks/2/comments/

# View all comments chronologically
cat .saw/epics/42/milestones/1/tasks/2/comments/*.json | jq -s 'sort_by(.timestamp)'
```
