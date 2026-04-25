# MCP Usage Rules

This repository configures two MCP servers for Codex-assisted work:

- `sequentialthinking` — structured reasoning for non-trivial planning and trade-offs.
- `context7` — current documentation lookup for APIs, frameworks, and libraries.

Use MCP tools deliberately. Do not call them for every small task.

## General MCP rules

1. Read `AGENTS.md` and relevant `.codex/docs/*` files before using MCP tools.
2. Use MCP only when it improves correctness, reduces uncertainty, or prevents bad architecture decisions.
3. Do not use MCP to bypass repository inspection.
4. Do not use MCP to justify scope creep.
5. Do not use MCP to introduce backend, auth, sync, Firebase, Android, or cloud assumptions for Version 1.
6. If an MCP server is unavailable, say so briefly and continue with repository-grounded reasoning.
7. Do not paste raw private reasoning. Summarize the decision, rationale, and trade-offs.

## When to use sequentialthinking

Use `sequentialthinking` for non-trivial reasoning tasks such as:

- choosing between architecture options;
- decomposing a feature into MVP-sized implementation steps;
- resolving conflicting requirements;
- classifying unclear work as MVP / Phase 2 / Later / Reject for V1;
- planning SwiftData model changes with persistence risks;
- debugging a problem where the cause is not obvious;
- reviewing a broad diff with several possible failure modes;
- deciding whether an abstraction is justified now or should be postponed.

Do not use `sequentialthinking` for:

- simple file creation;
- Markdown-only wording edits;
- tiny Swift syntax fixes;
- straightforward rename/refactor tasks;
- tasks where the next step is already obvious;
- generating long hidden reasoning for the final answer.

Expected output after using it:

- concise conclusion;
- chosen option;
- rejected alternatives;
- risks;
- smallest next step.

## When to use Context7

Use `context7` when current external documentation matters, especially for:

- SwiftUI APIs;
- SwiftData APIs;
- iOS 17+ behavior;
- Xcode project configuration details;
- Apple-native frameworks;
- syntax or lifecycle details that may have changed;
- external package documentation, only if package use was explicitly approved.

Do not use `context7` for:

- product scope decisions that are already defined in this repository;
- local repository facts;
- simple Swift language basics;
- generic architecture opinions;
- backend/sync/auth/Firebase planning for Version 1;
- adding external packages without approval.

Expected output after using it:

- API fact checked against current docs;
- recommended usage;
- known constraints or pitfalls;
- how to verify in Xcode.

## Preferred usage by agent

### Architect

Use `sequentialthinking` for significant architecture trade-offs or MVP boundary classification.

Use `context7` when architecture depends on current SwiftUI, SwiftData, or iOS API capabilities.

### Reviewer

Use `context7` when reviewing possible SwiftUI/SwiftData API misuse.

Use `sequentialthinking` only for broad diffs with multiple interacting risks.

### Developer

Use `context7` before implementing unfamiliar Apple APIs.

Use `sequentialthinking` only when implementation has multiple valid paths and choosing wrong would cause rework.

## Practical order of operations

For most tasks:

1. Inspect repository files.
2. Read `AGENTS.md` and `.codex/docs/*`.
3. Decide whether MCP is needed.
4. If API behavior is uncertain, use `context7`.
5. If architecture/plan is non-trivial, use `sequentialthinking`.
6. Produce a small repo-grounded answer or change.

Do not let MCP output override the Version 1 boundaries in this repository.
