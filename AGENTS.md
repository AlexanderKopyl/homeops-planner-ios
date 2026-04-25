# AGENTS.md

## Scope

These instructions apply to the entire `homeops-planner-ios` repository.

This repository is for **HomeOps Planner**, an iOS-only local-first app for managing recurring household supplies and maintenance tasks.

## Product summary

HomeOps Planner helps a single household user track:

- household supplies that run low over time;
- recurring home maintenance tasks;
- preferred merchants for supplies;
- service providers for maintenance work;
- actions that are due soon or pending now.

The product should answer:

- What is running low soon?
- What needs to be done soon?
- Where do I usually buy this?
- Who do I contact for this?
- What actions are pending now?

## Version 1 boundaries

Version 1 is strictly:

- iOS only;
- single-user only;
- local-only storage;
- no backend;
- no accounts;
- no cloud sync;
- no family sharing;
- no Android;
- no Firebase unless explicitly approved by the human owner.

The goal of Version 1 is to validate product usefulness before adding backend, sync, accounts, sharing, Android, or cloud infrastructure.

## Tech baseline

Use:

- Swift;
- SwiftUI;
- SwiftData;
- iOS 17+;
- Apple-native APIs first;
- external packages only when explicitly justified and approved.

## AI working rules

When working in this repository:

1. Read this `AGENTS.md` before planning or editing.
2. Read relevant docs in `.codex/docs/` before proposing architecture.
3. Keep changes small and incremental.
4. Explain architecture before implementation.
5. Do not overengineer.
6. Do not introduce backend, auth, sync, Firebase, cloud abstractions, or account concepts for V1.
7. Do not add CI/CD unless explicitly requested.
8. Do not add subagents or complex AI workflow layers unless explicitly requested.
9. Do not create large full-file rewrites unless explicitly requested.
10. Keep code readable for a Swift learner.
11. Prefer simple, inspectable solutions over clever abstractions.
12. Avoid unrelated refactoring.
13. If a requirement is unclear, ask one concise question, then proceed with the safest V1 assumption.

## Architecture principles

Use a simple SwiftUI-first, feature-first architecture suitable for a learning project and an early MVP.

Preferred direction:

- SwiftUI owns UI composition and screen state.
- SwiftData owns local persistence.
- Feature folders group related views, models, and helpers.
- Domain decisions should be separated from view layout where practical.
- Persistence concerns should not leak deeply into all UI code.
- Use constructor injection where dependencies are needed.
- Avoid global singletons unless there is a strong reason.
- Keep SwiftUI views reasonably small by extracting focused subviews.
- Avoid premature Clean Architecture complexity.
- Avoid repository/service layers until there is a real need.

## Implementation rules

Before editing code:

1. Identify whether the task is MVP, Phase 2, later, or rejected for V1.
2. List files likely affected.
3. State the smallest useful implementation step.
4. Preserve the Version 1 boundary.

During implementation:

- Modify only necessary files.
- Prefer Apple-native APIs.
- Avoid external packages by default.
- Keep naming clear and boring.
- Keep functions small and readable.
- Prefer simple Swift types before protocols/generics.
- Add comments only when they clarify non-obvious decisions.
- Do not add sample screens, data models, or app features unless the task explicitly asks for them.

After implementation:

- Explain what changed.
- Provide Xcode verification steps.
- Mention rollback notes.
- Call out risks or weak points.

## Output format for planning tasks

Use this format:

```markdown
## Classification
MVP / Phase 2 / Later / Reject for V1

## Goal
Short description of the requested outcome.

## Proposed smallest step
The smallest useful next implementation slice.

## Files likely affected
- path/to/file.swift — why

## Plan
1. Step one
2. Step two
3. Step three

## Acceptance criteria
- Criterion one
- Criterion two

## Risks / trade-offs
- Risk or trade-off

## Postpone
- What should not be done yet
```

Do not write code in planning tasks unless explicitly asked.

## Output format for implementation tasks

Use this format:

```markdown
## Summary
What changed.

## Files changed
- path/to/file.swift — what changed

## Verification
1. Open the project in Xcode.
2. Build the app.
3. Run the relevant screen or flow.

## Rollback
How to revert safely.

## Risks / notes
Known limitations or follow-up checks.
```

## MVP modules

The MVP can include these product areas:

- Home dashboard: due soon, running low, pending actions.
- Supplies: household consumables with current status and preferred merchant link.
- Maintenance tasks: recurring household tasks with due dates and frequency.
- Merchants: saved purchase links or preferred stores.
- Service providers: saved contacts for maintenance work.
- Task / buy list: actionable pending household items.
- Settings: local-only app preferences if needed.

## Out of scope for Version 1

Do not implement or assume:

- backend API;
- user accounts;
- login/signup;
- authentication;
- cloud sync;
- family sharing;
- multi-device collaboration;
- Android support;
- web app;
- Firebase;
- push notifications;
- payment integration;
- marketplace features;
- analytics SDKs;
- complex Clean Architecture;
- generic networking layer;
- remote configuration;
- background sync;
- AI/LLM features.

## Verification baseline

For code changes, prefer verification through Xcode:

- open the project;
- build for an iOS 17+ simulator;
- run the app;
- verify the affected screen or flow manually;
- run tests only when tests exist or the task adds them.

For documentation-only changes, verify that files are present and Markdown is readable.
