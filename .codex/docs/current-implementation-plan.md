# Current Implementation Plan

## Classification
MVP

## Current Repository State

- Branch: `main`
- Working tree at time of planning: clean
- Current source structure:
  - `HomeOpsPlanner/HomeOpsPlanner/App/`
  - `HomeOpsPlanner/HomeOpsPlanner/Features/`
  - `HomeOpsPlanner/HomeOpsPlanner/Models/`
  - `HomeOpsPlanner/HomeOpsPlanner/Shared/`
  - `HomeOpsPlanner/HomeOpsPlanner/Assets.xcassets/`
- Important files:
  - `HomeOpsPlanner/HomeOpsPlanner/App/HomeOpsPlannerApp.swift`
  - `HomeOpsPlanner/HomeOpsPlanner/App/ContentView.swift`
  - `HomeOpsPlanner/HomeOpsPlanner/Models/SupplyTrackingType.swift`
  - `HomeOpsPlanner/HomeOpsPlanner.xcodeproj/project.pbxproj`

## Already Done

- Base V1 folder structure exists: `App`, `Features`, `Models`, and `Shared`.
- App entry point exists at `HomeOpsPlanner/HomeOpsPlanner/App/HomeOpsPlannerApp.swift`.
- Starter root view exists at `HomeOpsPlanner/HomeOpsPlanner/App/ContentView.swift`.
- First planned model/value type exists at `HomeOpsPlanner/HomeOpsPlanner/Models/SupplyTrackingType.swift`.
- `SupplyTrackingType` has `quantity` and `time` cases and conforms to `String, Codable`.
- Xcode project uses file-system-synchronized groups.
- No backend, auth, sync, Firebase, accounts, cloud, or external package concepts were found.

## Missing For V1

- Missing models:
  - `SupplyCategory.swift`
  - `SupplyItem.swift`
  - `MaintenanceTask.swift`
  - `Merchant.swift`
  - `ServiceProvider.swift`
- Missing SwiftData setup:
  - No `@Model` types yet.
  - No `import SwiftData` in the app entry point.
  - No `.modelContainer(...)` registration.
- Missing UI/navigation:
  - No `TabView`.
  - No dashboard.
  - No supplies list.
  - No supply create/edit form.
  - No category creation flow.
  - No maintenance, merchants, providers, or action list UI.

## Architecture Decision

The current structure is acceptable and matches the intended V1 architecture at the base level. It is still a scaffold, which is appropriate.

Do not simplify further. Do not create every future feature folder yet. Nothing currently violates the V1 boundary.

## Smallest Implementation Step

Create `HomeOpsPlanner/HomeOpsPlanner/Models/SupplyCategory.swift` as a minimal local SwiftData model.

This should be model-only: no UI, no navigation, no seed data, no services, no repositories, no backend, and no sync assumptions.

## Recommended Step-By-Step Plan

1. Add `SupplyCategory.swift` as a minimal SwiftData model.
2. Add `SupplyItem.swift` with category relationship and quantity/time tracking fields.
3. Register the SwiftData model container in `HomeOpsPlannerApp`.
4. Add a simple root `TabView`.
5. Add `Features/Supplies/SupplyListView.swift`.
6. Add a basic supply create/edit form.
7. Add category selection to the supply form.
8. Add inline category creation.
9. Add quantity tracking actions.
10. Add time-based supply status logic.
11. Add `MaintenanceTask.swift`.
12. Add maintenance list/form.
13. Add dashboard sections from supplies and maintenance.
14. Add `Merchant.swift` and `ServiceProvider.swift` after core flows work.

## Next 3 Codex Prompts To Generate

### Create SupplyCategory SwiftData Model

- Goal: Add the flat local category model needed before supply items.
- Likely files affected:
  - `HomeOpsPlanner/HomeOpsPlanner/Models/SupplyCategory.swift`
- Acceptance criteria summary:
  - Builds successfully.
  - Model is local-only.
  - No UI, seed data, repositories, services, backend, sync, or external packages.

### Create SupplyItem SwiftData Model

- Goal: Add the core supply model with category relationship and quantity/time tracking fields.
- Likely files affected:
  - `HomeOpsPlanner/HomeOpsPlanner/Models/SupplyItem.swift`
  - `HomeOpsPlanner/HomeOpsPlanner/Models/SupplyCategory.swift`, if an inverse relationship is needed
- Acceptance criteria summary:
  - Builds successfully.
  - Supports quantity and time tracking.
  - Every supply has a category.
  - No UI or persistence abstractions.

### Register SwiftData Model Container

- Goal: Register current local SwiftData models at the app entry point.
- Likely files affected:
  - `HomeOpsPlanner/HomeOpsPlanner/App/HomeOpsPlannerApp.swift`
- Acceptance criteria summary:
  - App builds and launches.
  - Model container includes current models.
  - No sample data, sync, CloudKit, or backend concepts.

## Files Likely Affected Later

- `HomeOpsPlanner/HomeOpsPlanner/App/HomeOpsPlannerApp.swift` — SwiftData container and root navigation.
- `HomeOpsPlanner/HomeOpsPlanner/App/ContentView.swift` — likely replaced by root navigation.
- `HomeOpsPlanner/HomeOpsPlanner/Models/SupplyCategory.swift` — flat category model.
- `HomeOpsPlanner/HomeOpsPlanner/Models/SupplyItem.swift` — core supplies model.
- `HomeOpsPlanner/HomeOpsPlanner/Models/MaintenanceTask.swift` — recurring maintenance model.
- `HomeOpsPlanner/HomeOpsPlanner/Models/Merchant.swift` — purchase source model.
- `HomeOpsPlanner/HomeOpsPlanner/Models/ServiceProvider.swift` — maintenance contact model.
- `HomeOpsPlanner/HomeOpsPlanner/Features/Supplies/` — supplies list and form.
- `HomeOpsPlanner/HomeOpsPlanner/Features/Dashboard/` — dashboard once data exists.

## Trade-Offs

- Model-first keeps the data shape explicit before UI, but SwiftData schema changes may require simulator data resets.
- Keeping feature folders empty avoids premature structure, but the project remains sparse until real screens are added.
- Direct SwiftData use in early SwiftUI views is simpler for V1, but repeated query logic may later justify small helpers.

## Risks

- Build risks: upcoming `@Model` files need careful SwiftData syntax and iOS 17+ compatibility.
- Xcode project reference risks: synchronized groups should pick up new files, but Xcode should still be checked after additions.
- SwiftData model risks: relationships, enum storage, optional quantity/time fields, and delete behavior need incremental verification.
- Scope creep risks: avoid adding dashboards, provider flows, notifications, sync, or abstractions too early.
- Test risks: test targets exist, but no test Swift files are currently present.

## Postpone

- Backend, accounts, authentication, sync, CloudKit, Firebase, Android, web, family sharing, analytics, remote config, and networking layers.
- Repository/service layers and Clean Architecture folders.
- Full dashboard before supplies and maintenance data exist.
- Merchant/provider UI before core supplies and maintenance workflows work.
- Persisted action item model until manual action-list behavior is explicitly needed.
- Notifications, widgets, barcode scanning, OCR, AI, price tracking, and marketplace integrations.
