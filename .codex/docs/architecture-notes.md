# Architecture Notes

## Recommended iOS architecture for Version 1

Use a simple **SwiftUI-first, feature-first** architecture.

The goal is to keep the app easy to understand while still avoiding a messy single-file prototype.

Do not start with heavy Clean Architecture. Version 1 does not need backend boundaries, remote repositories, sync abstractions, or complex dependency graphs.

## SwiftUI-first approach

SwiftUI should be the default UI layer.

Recommended rules:

- keep views focused and readable;
- extract subviews when a view becomes difficult to scan;
- keep business decisions out of view layout where practical;
- avoid massive `body` implementations;
- use local `@State` for simple screen-only state;
- use SwiftData queries where they naturally fit;
- avoid global app state until there is a real need.

## SwiftData local persistence

SwiftData is the default persistence technology for V1.

Recommended rules:

- model only the data required by the current feature;
- avoid adding future backend IDs, sync flags, account ownership, or remote metadata;
- keep relationships understandable;
- prefer simple model fields first;
- verify persistence manually in the simulator after each storage-related change.

## Simple feature-first structure

A practical structure can look like this:

```text
HomeOpsPlanner/
  App/
    HomeOpsPlannerApp.swift
  Features/
    Dashboard/
      DashboardView.swift
    Supplies/
      SupplyListView.swift
      SupplyDetailView.swift
    Maintenance/
      MaintenanceListView.swift
      MaintenanceDetailView.swift
    Merchants/
      MerchantListView.swift
    Providers/
      ProviderListView.swift
    Tasks/
      TaskListView.swift
  Models/
    Supply.swift
    MaintenanceTask.swift
    Merchant.swift
    ServiceProvider.swift
    ActionItem.swift
  Shared/
    Components/
    Utilities/
```

This is only a starting point. Do not create these folders until a task needs them.

## Boundaries by responsibility

### UI

SwiftUI views render screens and handle user interaction.

They should not become large persistence orchestration classes.

### Local models

SwiftData models represent local app data.

They should not include backend or sync concerns in V1.

### Domain decisions

Simple product rules can start as small helper methods or focused types.

Do not introduce domain services, repositories, or protocols until repeated logic proves they are needed.

### Persistence

Use SwiftData directly where it keeps the feature simpler.

Add a wrapper only when it removes duplication or makes a real workflow easier to test.

## No backend abstractions

Do not add:

- API clients;
- repository protocols for future remote storage;
- DTOs for server contracts;
- auth/session objects;
- sync engines;
- Firebase adapters;
- network error layers.

These are Phase 2+ concerns.

## No complex Clean Architecture yet

Avoid early layers like:

- `Domain/UseCases/Repositories/DataSources`;
- protocol-per-service;
- generic mappers;
- remote/local repository pairs;
- dependency containers for imagined future services.

Use simple separation first. Improve only when the code starts showing real pressure.

## Dependency approach

Prefer constructor injection when a dependency exists.

For early SwiftUI screens, many features can rely on SwiftUI environment and SwiftData context directly.

Avoid global singletons unless there is a strong platform or lifecycle reason.

## Verification approach in Xcode

For documentation-only changes:

1. Confirm files exist.
2. Confirm Markdown renders/readable in the editor.

For app code changes later:

1. Open the project in Xcode.
2. Select an iOS 17+ simulator.
3. Build the app.
4. Run the app.
5. Verify the changed flow manually.
6. For SwiftData changes, relaunch the app and confirm local data persists.
7. Reset simulator data when model changes require a clean state.

## Architecture decision rule

Before adding a layer, ask:

> Does this solve a real current V1 problem, or am I preparing for a future backend/sync/version?

If it only prepares for a future version, postpone it.
