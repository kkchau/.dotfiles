---
name: beads-development-workflow
description: Defines a multiple subagent workflow to implement a development task defined in beads (`bd`). Use this skill whenever implementing a development task started from a bd task.
---

# beads-development-workflow

## Instructions

1. **ALWAYS** load other relevant development skills. Subagents should also use all relevant development skills.
2. **ALWAYS** record your steps in the bd task comments as you work through the test-driven development loop. This is the single source of truth for the implementation.

### Test-driven development loop
Begin a test-driven development (TDD) loop with the following steps:
1. **Plan**: Spawn an exploration subagent to explore the codebase for relevant patterns. In parallel, spawn a planning subagent to develop an implementation plan. Both should focus on gaps in the task description and key decisions to be made. Open questions should be raised for user feedback.
    1. **Planning artifact**: Add a comment to the bd task with the implementation details. This should serve as a reference for further work in this implementation loop.
2. **Begin test writing loop**
    1. **Tests**: Once an implementation plan is settled, spawn a test-writing subagent to write tests based on the implementation plan. Tests should be as specific as possible and cover edge cases.
    2. **Verify**: Spawn a verifier subagent to critically review the tests written by the test subagent against the implementation plan and task description. Any issues raised by this subagent should cause the test-writing subagent to rewrite the tests until they are satisfactory.
        1. This subagent should **NEVER** update code; it should prompt a restart of this test writing loop with the additional details.
3. **End test writing loop**
4. **Begin implementation loop**
    1. **Implement**: Once tests are satisfactory, spawn a code-writing subagent to implement the planned functionality.
        1. If extra details are needed during implementation, spawn a parallel exploration and/or planning subagent to fill in the blanks, or ask the user questions if necessary. These **MUST** be added as comments on the bd task.
    2. **Review**: Once implementation is complete, use multiple code review subagents in parallel to verify work in parallel:
        1. **Correctness**: One subagent verifies correctness. This subagent a) runs tests to verify they pass and b) reviews the code for correctness against the implementation plan and task description.
            1. If the tests themselves are deemed incorrect or insufficient, **NEVER** update the tests. Go back to the **test writing loop** and start again from there. Prompt the user for permission to do so, and record this decision in the bd task comments.
        2. **Quality**: One subagent verifies the quality of the code written. Compare this to the styles defined in my other relevant development skills (e.g. `/dev`) as well as established patterns in the codebase.
            1. This subagent also reviews the code for maintainability and readability
        3. **Security**: One subagent reviews the code for security issues and potential vulnerabilities.
        4. If any of these review subagents raise issues, **NEVER** update the implementation directly. Instead, restart the implementation loop to rewrite the code based on the feedback from the review subagents. Record all feedback and decisions in the bd task comments.
5. **End implementation loop**
