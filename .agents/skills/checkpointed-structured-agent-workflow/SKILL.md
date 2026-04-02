---
name: checkpointed-structured-agent-workflow
description: Defines a multiple subagent software development lifecycle workflow to implement a development request. Use this whenever doing software development work that can be scoped into a structured workflow.
---

# Checkpointed Structured Agent Workflow

A 4-phase, human-in-the-loop (HITL) checkpointed workflow for autonomous software development. Work flows through Planning, Decomposition, Artifact Creation, and Execution — each phase gated by a human checkpoint before the next begins. The workflow runs autonomously within phases but requires human approval at phase boundaries.

## Core Principle

**Minimal human interaction, maximum human authority.** Agents execute autonomously through task-level cycles. Humans review completed milestones — not individual agent steps. Humans are consulted only when (1) a phase boundary is reached, or (2) autonomous execution cannot converge (escalation).

## Work Hierarchy: Epic > Milestone > Task

| Level | Definition | Reviewed by |
|---|---|---|
| **Epic** | The overall body of work. What the 4-phase workflow processes. | Human (start and end) |
| **Milestone** | A small, independently reviewable chunk of work within an epic. The unit of human review. Must be cohesive, independently deployable, and bounded in complexity. | Human (HITL 4.2) |
| **Task** | A small, well-defined unit of agent execution within a milestone. Sequential steps that build toward the milestone deliverable. Need NOT be independently deployable. | Agent verification council |

**Key semantics:**
- Epics decompose into milestones. Milestones decompose into tasks.
- Tasks execute **sequentially** within a milestone — each builds on the previous.
- Independent milestones may execute **in parallel**.
- **Milestone** = unit of human review and deployability. **Task** = unit of agent execution.
- **Every task runs the full TDD cycle** (plan → write tests → implement). Tests are never a separate task — they are the first phase of every task's execution. Decomposition must not produce standalone "write tests for X" tasks; the tests for a piece of functionality belong to the task that implements it.

## The Four Phases

### Phase 1: Planning / Design

Translates fuzzy human input into a structured, unambiguous specification.

**Steps:**
1. Create the epic in the memory backend with the raw description.
2. Spawn a translation agent that reads the input, explores the codebase, identifies ambiguities, and produces a structured spec (problem statement, scope boundaries, constraints, acceptance criteria).
3. If ambiguities exist, enter a clarification loop with the human.
4. Challenge the draft spec via a deliberation council (multiple independent reviewers with different perspectives: gaps/risks, user needs, maintainability, decomposability).
5. Present the spec and council feedback to the human.

**HITL 1.1 — Design Review:**
- **Approve**: Proceed to Phase 2.
- **Edit**: Modify the spec and re-review.
- **Reject**: Not ready for development.

The approved spec becomes the canonical document that Phase 2 decomposes from. Council feedback and human decisions are recorded as comments on the epic.

---

### Phase 2: Decomposition

Breaks the approved spec into milestones and tasks.

**Decomposition loop:**

1. **Decompose.** Spawn a decomposition subagent with the approved `TranslatedSpec`. The subagent breaks the spec into milestones and tasks, targeting:
   - 1-2 new concepts per milestone
   - 1 concern per milestone
   - Low change scatter (changes cluster in one module/package)
   - Clear separation of behavioral and structural changes (never mixed in the same milestone)
   - Each task scoped to include both tests and implementation — never separate "write tests" and "implement" into distinct tasks, as the TDD cycle handles this internally
   - Task dependencies and ordering within each milestone

2. **Review.** Spawn a separate review subagent — with no context from the decomposition subagent — to evaluate the proposed milestones against the reviewability heuristics. The reviewer assesses each milestone for concept count, concern count, change scatter, and behavioral-vs-structural mixing, and returns a structured verdict (approve/reject with feedback).

3. **Iterate or advance.** If the review subagent rejects the decomposition, restart the loop: the decomposition subagent receives the reviewer's feedback and produces a revised decomposition. If the review subagent approves, the structured decomposition is presented to the human.

**HITL 2.1 — Decomposition Review:**
- **Approve**: Proceed to Phase 3.
- **Edit**: Adjust milestone scope, acceptance criteria, ordering, dependencies.
- **Re-decompose**: Provide feedback and re-run the decomposition loop.
- **Back to Phase 1**: Design needs rework.

Milestone and task issues are NOT created yet — only the plan is approved.

---

### Phase 3: Artifact Creation

Creates the concrete work artifacts from the approved decomposition using the configured memory backend.

**Steps:**
1. Build a dependency DAG from milestone specs. Identify parallelizable groups.
2. Create issues for each milestone and task with detailed acceptance criteria, file-level scope, dependency links, and execution parameters.
3. Each issue must satisfy the **fresh-context-window invariant**: a fresh agent can execute any task from its issue alone, with no prior conversation history.

**HITL 3.1 — Artifact Review:**
- **Approve**: Proceed to execution. This is the last gate before autonomous work begins.
- **Edit**: Adjust acceptance criteria, execution parameters.
- **Back to Phase 2**: Milestones need restructuring.
- **Back to Phase 1**: Approach needs rethinking.

---

### Phase 4: Execution

Autonomously executes the approved work plan through test-driven development cycles.

**Milestone execution (per milestone):**
1. HITL initializes VCS artifacts (branches, worktrees) just-in-time when the milestone is ready. The agent must confirm this has happened before continuing with milestone execution.
2. Execute tasks sequentially on the milestone's branch.

**Task TDD cycle (per task, up to 2 attempts):**

Each task runs up to 2 sequential TDD cycles on the milestone's branch. Each cycle has three sequential phases, two of which are inner loops. The task is complete when the verification council accepts. If both attempts fail, the human is consulted.

#### Phase 4.1: Task Planning (single pass, no loop)

Spawn a planning subagent scoped to the current task spec/memory artifact. The subagent operates on the milestone's branch and produces a detailed implementation plan: what to change, where, and how.

- On the first TDD iteration, the planner works from the task spec alone.
- On subsequent iterations (retries), the planner receives all accumulated feedback from prior iterations — verifier rejections, test failures, review feedback — and may revise the approach entirely.
- The plan is stored in the memory backend as a comment on the task issue. It is not presented to the human; the human reviews the *output*, not the plan.

#### Phase 4.2: Test Writing Loop (up to 2 iterations)

A self-contained loop that converges when a context-isolated verifier approves the tests, or fails when the iteration budget is exhausted.

1. **Write.** Spawn a test-writing subagent with the task plan and acceptance criteria. The subagent writes test files on the milestone's branch.
2. **Verify.** Spawn a separate verifier subagent — with no context from the test writer — that critically reviews the tests against the task's acceptance criteria. The verifier checks:
   - Do the tests cover all acceptance criteria?
   - Are edge cases addressed?
   - Are the tests testing behavior (not implementation details)?
   - Are the tests independent and deterministic?
   - Are the tests redundant and necessary / can they be consolidated?
3. **Iterate or advance.**
   - If the verifier approves: exit the test writing loop, advance to the implementation loop.
   - If the verifier rejects: the test-writing subagent receives the verifier's structured feedback and rewrites. Iteration counter increments.
   - If both iterations are exhausted: the test writing loop fails. This triggers a retry of the full TDD cycle — re-plan from scratch with feedback about why tests couldn't converge.

#### Phase 4.3: Implementation Loop (up to 3 iterations)

A self-contained loop that converges when all verification checks pass, or fails when the iteration budget is exhausted.

1. **Implement.** Spawn an implementation subagent with the plan and the verified tests. The subagent writes code on the milestone's branch.
2. **Run tests.** Execute the test suite. Capture stdout/stderr and exit code.
3. **Verification council (on test pass).** If tests pass, spawn three independent review subagents in parallel — each with no context from the others:
   - **Correctness reviewer**: Does the implementation satisfy the task spec and acceptance criteria? Do the tests actually exercise the new code? Are spec requirements silently ignored?
   - **Quality reviewer**: Is the code well-structured, readable, and consistent with existing codebase patterns? Naming, organization, duplication, style.
   - **Security reviewer**: Are there injection vectors, auth gaps, data exposure risks, insecure defaults, or missing input validation at system boundaries?

   Each reviewer returns a structured `ReviewResult` (pass/fail + details + suggestions). **All three must pass** for the task to advance.

4. **Iterate or advance.**
   - If tests fail: the implementation subagent receives test output and revises. Iteration counter increments.
   - If any reviewer fails: the implementation subagent receives consolidated review feedback and revises. Iteration counter increments.
   - If all reviews pass: the task's changes are committed to the milestone branch. Record the `TaskResult` in the memory backend. Advance to the next task in the milestone.
   - If all 3 iterations are exhausted: the implementation loop fails. This triggers a retry of the full TDD cycle — re-plan, considering that the implementation approach may be fundamentally flawed.

#### Escalation cascade

```
Test writing loop exhausted (2 iterations, verifier still rejects)
  └──> Full TDD cycle retries (re-plans from scratch with accumulated feedback)

Implementation loop exhausted (3 iterations, tests/reviews still fail)
  └──> Full TDD cycle retries (re-plans from scratch with accumulated feedback)

Both TDD attempts failed
  └──> HITL 4.1b: Task Escalation
```

**HITL 4.1b — Task Escalation (on budget exhaustion):**

The human is presented with the task spec, acceptance criteria, accumulated feedback from all iterations (verifier rejections, test failures, review feedback), and the current state of the code on the milestone branch.

- **Guide**: Provide direction, optionally edit the task spec in the memory backend, reset the iteration budget, re-enter the TDD cycle. The workflow always re-syncs the task spec from the memory backend before re-entering, since the human may have edited it.
- **Skip**: Mark the task as a manual TODO, proceed to the next task in the milestone. The milestone review will note the skipped task.
- **Abort milestone**: This milestone needs re-decomposition. Route back to Phase 2.
- **Abort epic**: Stop the workflow entirely.

**HITL 4.2 — Milestone Review (after all tasks complete):**
- **Approve**: Finalize the milestone, rebase dependents, proceed.
- **Revise**: Specify tasks to rework, re-enter TDD for those tasks.
- **Back to Phase 2**: Milestone is mis-scoped.
- **Back to Phase 1**: Requirements have changed.
- **Reject**: Stop entirely.

After all milestones are approved, consult HITL to a) merge into the base branch and b) close the epic. DO NOT do either operation without explicit confirmation from HITL.

## Backward Routing

Every HITL checkpoint can route backward to any earlier phase. This handles the reality that development surfaces information that changes requirements. Backward routes always preserve the context of *why* the human sent it back, recorded in the memory backend. Completed work is preserved where possible.

## Auditing and State Persistence

**All state transitions and decisions must be recorded in the memory backend as structured comments.** The memory backend is the durable source of truth that outlives any single agent session.

There is no workflow engine enforcing compliance. Adherence is achieved through two mechanisms:

1. **Fresh agent sessions per phase.** Each phase (and each task within Phase 4) is executed by a fresh agent with a focused prompt and minimal context. This reduces the chance that accumulated conversation noise obscures the workflow instructions — including the requirement to record state.
2. **The inter-phase schemas as contracts.** Each phase's output must conform to a defined schema before the next phase can begin. The human checkpoint between phases is the enforcement point — the human verifies that the required artifacts exist and are well-formed before approving.

Because compliance is prompt-based rather than mechanically enforced, **recording is a first-class instruction, not a side effect.** Every phase's prompt must explicitly instruct the agent to write its outputs and decisions to the memory backend before completing.

What gets recorded:
- Epic creation, spec translations, council feedback, clarification Q&A
- Decomposition plans, human edits, complexity assessments
- Every TDD cycle start, iteration, verifier feedback, and outcome
- Every escalation diagnosis and human guidance
- Every milestone review decision and feedback
- Every subjective decision point (e.g. "the planner chose this approach because..."), either by the agent or by the human.
- Rebase results, completion summaries

**Status transition authority:**
| Entity | Transitioned by | Rationale |
|---|---|---|
| **Task** | Agent (autonomous) | Verification council acceptance is sufficient. |
| **Task** (escalation) | Human | Budget exhaustion requires human judgment. |
| **Milestone** | Human only | Milestones are never completed by agents. |
| **Epic** | Human only | All milestones must be human-approved first. |


## Inter-Phase Schemas

These JSON schemas define the contracts between phases. Each schema specifies the structured output that one phase produces and the next phase consumes. Agents must conform to these shapes.

### TranslatedSpec — Phase 1 output, Phase 2 input

The structured specification produced by the translation agent and approved by the human at HITL 1.1.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["problem_statement", "scope_in", "scope_out", "technical_constraints", "acceptance_criteria"],
  "properties": {
    "problem_statement": {
      "type": "string",
      "description": "Clear, unambiguous statement of what needs to be built and why."
    },
    "scope_in": {
      "type": "array",
      "items": { "type": "string" },
      "description": "What is explicitly in scope for this epic."
    },
    "scope_out": {
      "type": "array",
      "items": { "type": "string" },
      "description": "What is explicitly out of scope — prevents scope creep during execution."
    },
    "technical_constraints": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Hard constraints: compatibility requirements, performance targets, technology restrictions."
    },
    "acceptance_criteria": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Epic-level criteria that define when the overall work is complete."
    },
    "supplementary_context": {
      "type": "array",
      "items": { "type": "string" },
      "description": "EDD excerpts, discussion summaries, prior art references — optional background."
    },
    "clarifications": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["question", "answer"],
        "properties": {
          "question": { "type": "string" },
          "answer": { "type": "string" }
        }
      },
      "description": "Question/answer pairs from the HITL clarification loop."
    }
  }
}
```

### TaskSpec — Phase 2 output (nested in MilestoneSpec)

A single unit of agent execution within a milestone.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["name", "description", "acceptance_criteria", "estimated_files"],
  "properties": {
    "name": {
      "type": "string",
      "description": "Short, descriptive name for the task."
    },
    "description": {
      "type": "string",
      "description": "What this task does — enough for a fresh agent to execute without additional context."
    },
    "acceptance_criteria": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Specific, verifiable criteria. The test writing loop targets these; the verification council gates on them."
    },
    "estimated_files": {
      "type": "array",
      "items": { "type": "string" },
      "description": "File paths expected to be created or modified."
    },
    "complexity": {
      "type": "string",
      "enum": ["trivial", "low", "medium", "high", "critical"],
      "description": "Orchestrator's complexity assessment for this task."
    },
    "orchestrator_notes": {
      "type": "string",
      "description": "Orchestrator's reasoning for the complexity/model/budget assignments — visible to humans at review."
    }
  }
}
```

### MilestoneSpec — Phase 2 output, Phase 3 input

A reviewable chunk of work containing ordered tasks.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["name", "description", "tasks", "depends_on", "estimated_files"],
  "properties": {
    "name": {
      "type": "string",
      "description": "Short, descriptive name for the milestone."
    },
    "description": {
      "type": "string",
      "description": "What this milestone delivers — the cohesive unit of reviewable work."
    },
    "tasks": {
      "type": "array",
      "items": { "$ref": "#TaskSpec" },
      "description": "Ordered list of tasks to execute sequentially."
    },
    "depends_on": {
      "type": "array",
      "items": { "type": "integer" },
      "description": "Indices of prerequisite milestones that must be approved before this one can execute."
    },
    "estimated_files": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Union of all task estimated_files — used for dependency analysis and parallelization decisions."
    }
  }
}
```

### ReviewResult — Phase 4 verification council output

Produced by each member of the verification council after reviewing a task's implementation.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["reviewer", "verdict", "details", "suggestions"],
  "properties": {
    "reviewer": {
      "type": "string",
      "enum": ["correctness", "quality", "security"],
      "description": "Which council member produced this review."
    },
    "verdict": {
      "type": "string",
      "enum": ["pass", "fail"],
      "description": "Whether the implementation satisfies the reviewer's criteria. All three must pass for the task to advance."
    },
    "details": {
      "type": "string",
      "description": "Explanation of the verdict — what was evaluated and why it passed or failed."
    },
    "suggestions": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Specific, actionable feedback. On failure, these guide the next implementation iteration."
    }
  }
}
```

### TaskResult — Phase 4 per-task output

The cumulative output of a task's TDD cycles. Recorded in the memory backend and rolled up into the milestone result.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["task_name", "status", "plan", "test_files", "implementation_files", "reviews", "tdd_iteration_count"],
  "properties": {
    "task_name": {
      "type": "string",
      "description": "References the TaskSpec this result corresponds to."
    },
    "status": {
      "type": "string",
      "enum": ["pending", "in_progress", "completed", "failed", "skipped"],
      "description": "Current task status."
    },
    "plan": {
      "type": "string",
      "description": "The implementation plan produced by the planning subagent."
    },
    "test_files": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Paths to test files written during the test writing loop."
    },
    "implementation_files": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Paths to implementation files written or modified."
    },
    "test_run_output": {
      "type": "string",
      "description": "Stdout/stderr from the final test execution."
    },
    "reviews": {
      "type": "object",
      "additionalProperties": { "$ref": "#ReviewResult" },
      "description": "Map of reviewer name to structured review result."
    },
    "tdd_iteration_count": {
      "type": "integer",
      "description": "How many full TDD cycle restarts were needed."
    },
    "test_writing_iterations": {
      "type": "integer",
      "description": "Write/verify loop count in the final (successful or last) TDD iteration."
    },
    "implementation_iterations": {
      "type": "integer",
      "description": "Implement/test/review loop count in the final TDD iteration."
    },
    "accumulated_feedback": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Feedback from all failed iterations — fed back into re-planning on retry."
    }
  }
}
```

### ChangeSummary — Phase 4 milestone review payload

Structured summary of a milestone's cumulative changes, presented to the human at HITL 4.2.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["file_changes", "total_lines_added", "total_lines_deleted", "commit_count", "commit_shas", "narrative"],
  "properties": {
    "file_changes": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["path", "change_type", "lines_added", "lines_deleted", "source_task"],
        "properties": {
          "path": { "type": "string" },
          "change_type": { "type": "string", "enum": ["added", "modified", "deleted", "renamed"] },
          "old_path": { "type": ["string", "null"], "description": "Only set for renames." },
          "lines_added": { "type": "integer" },
          "lines_deleted": { "type": "integer" },
          "source_task": { "type": "string", "description": "TaskSpec name that last touched this file." }
        }
      },
      "description": "Per-file change metadata for the milestone."
    },
    "total_lines_added": { "type": "integer" },
    "total_lines_deleted": { "type": "integer" },
    "files_added": { "type": "integer" },
    "files_modified": { "type": "integer" },
    "files_deleted": { "type": "integer" },
    "test_files_count": { "type": "integer" },
    "implementation_files_count": { "type": "integer" },
    "commit_count": { "type": "integer" },
    "commit_shas": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Flattened from all TaskResult commit_shas."
    },
    "narrative": {
      "type": "string",
      "description": "Agent-generated summary of what changed and why — the human-readable story of the milestone."
    }
  }
}
```

### DeliberationFeedback — Phase 1 and Phase 2 council output

Produced by each deliberation council member when reviewing the spec (Phase 1) or decomposition (Phase 2).

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["role", "concerns", "questions", "suggested_changes", "confidence"],
  "properties": {
    "role": {
      "type": "string",
      "enum": ["skeptic", "user_advocate", "maintainer", "complexity_evaluator"],
      "description": "The deliberation perspective this feedback was produced from."
    },
    "concerns": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Specific issues found from this role's perspective."
    },
    "questions": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Questions for the human to address."
    },
    "suggested_changes": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Proposed edits to the spec or decomposition."
    },
    "confidence": {
      "type": "string",
      "enum": ["low", "medium", "high"],
      "description": "How concerned this reviewer is — high confidence means significant issues found."
    }
  }
}
```

## Milestone Reviewability Heuristics

Milestones should be evaluated against these dimensions (guidance, not mechanistic gates):

- **Concept count**: Number of new abstractions introduced. Target: 1-2 per milestone.
- **Concern count**: Number of distinct responsibilities touched. Target: 1 per milestone.
- **Change scatter**: How localized the changes are. Prefer clustering in one module/package.
- **Behavioral vs. structural**: Never mix refactoring with behavioral changes in the same milestone.

These are judgment calls — agents surface the assessment, humans decide.
