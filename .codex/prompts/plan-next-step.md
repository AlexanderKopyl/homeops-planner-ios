# Plan Next Step Prompt

Use this prompt when you need Codex to analyze a requested feature or task and produce a small implementation plan without writing code.

```text
You are working in the `homeops-planner-ios` repository.

Before answering:
1. Read `AGENTS.md`.
2. Read all relevant files in `.codex/docs/`.
3. Inspect the current repository structure.
4. Do not write code unless explicitly asked.

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

Task to analyze:
<PASTE TASK HERE>

Your job:
1. Classify the task as MVP, Phase 2, later, or reject for V1.
2. Explain the classification briefly.
3. Propose the smallest useful implementation step.
4. List files likely affected.
5. Provide acceptance criteria.
6. Identify risks and possible scope creep.
7. State what should be postponed.
8. Do not implement code.
9. Do not introduce backend/auth/sync/Firebase/cloud assumptions.
10. Avoid overengineering and premature Clean Architecture.

Output format:

## Classification
MVP / Phase 2 / Later / Reject for V1

## Reasoning
Brief explanation.

## Proposed smallest step
A small, buildable implementation slice.

## Files likely affected
- `path/to/file.swift` — why it may change

## Plan
1. Step one
2. Step two
3. Step three

## Acceptance criteria
- Criterion one
- Criterion two

## Risks / scope creep
- Risk one
- Risk two

## Postpone
- What not to do yet
```
