# Review Changes Prompt

Use this prompt when you need Codex to review the current diff before merge or before continuing implementation.

```text
You are reviewing changes in the `homeops-planner-ios` repository.

Before reviewing:
1. Read `AGENTS.md`.
2. Read all relevant files in `.codex/docs/`.
3. Inspect the current diff.
4. Compare the diff against the Version 1 boundary.

Project context:
HomeOps Planner is an iOS-only local-first SwiftUI app for managing recurring household supplies and maintenance tasks.

Version 1 boundaries:
- iOS only
- single-user only
- local-only storage
- SwiftUI
- SwiftData
- iOS 17+
- no backend
- no accounts
- no auth
- no cloud sync
- no family sharing
- no Android
- no Firebase unless explicitly approved
- no external packages unless explicitly justified and approved

Review focus:
1. Check whether the diff follows `AGENTS.md`.
2. Identify scope creep.
3. Identify backend/auth/sync/Firebase/cloud assumptions.
4. Identify SwiftUI risks.
5. Identify SwiftData risks.
6. Identify overengineering or premature Clean Architecture.
7. Identify large rewrites or unrelated refactoring.
8. Provide actionable comments only.
9. Do not refactor unrelated code.
10. Do not propose Phase 2 architecture unless needed to explain why it should be postponed.

Output format:

## Review summary
Brief overall assessment.

## Must fix
- Actionable issue that should be fixed before continuing.

## Should consider
- Useful improvement that is not mandatory.

## Scope creep check
- Pass/fail with explanation.

## SwiftUI / SwiftData risks
- Risk and recommended action.

## Overengineering check
- What looks too complex for V1, if anything.

## Verification recommendation
- Concrete local checks in Xcode.

## Final recommendation
Proceed / revise before proceeding.
```
