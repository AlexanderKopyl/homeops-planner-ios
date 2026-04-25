# Implement Small Step Prompt

Use this prompt when you need Codex to implement one small, scoped change.

```text
You are working in the `homeops-planner-ios` repository.

Before editing:
1. Read `AGENTS.md`.
2. Read all relevant files in `.codex/docs/`.
3. Inspect the current repository structure and existing files.
4. Identify the smallest safe implementation slice.

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

Task to implement:
<PASTE TASK HERE>

Implementation rules:
1. Keep the change small.
2. Modify only necessary files.
3. Do not add backend/auth/sync/Firebase/cloud abstractions.
4. Do not add external packages unless the task explicitly approves them.
5. Do not add CI/CD.
6. Do not introduce complex Clean Architecture.
7. Prefer Apple-native APIs.
8. Prefer readable Swift and SwiftUI code for a learner.
9. Prefer constructor injection where dependencies are actually needed.
10. Avoid global singletons unless there is a strong reason.
11. Avoid unrelated refactoring.
12. Do not create large full-file rewrites unless explicitly requested.

After editing, respond with:

## Summary
What changed and why.

## Files changed
- `path/to/file.swift` — what changed

## Verification in Xcode
1. Open the project in Xcode.
2. Select an iOS 17+ simulator.
3. Build the app.
4. Run the affected flow.
5. Describe the expected result.

## Rollback
How to revert the change safely.

## Risks / notes
Known limitations, SwiftUI/SwiftData risks, or follow-up checks.
```
