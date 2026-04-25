# HomeOps Planner — Version 1 Architecture Plan

## 1. Chosen architecture

HomeOps Planner V1 uses a **SwiftUI-first, feature-first, local-first architecture**.

The goal is to keep the first version small, buildable, and understandable while still leaving room for future product growth.

The selected architecture is:

```text
SwiftUI UI layer
+ SwiftData local persistence
+ feature-first folders
+ shared local models
+ minimal helper logic when needed
```

This is intentionally not a full Clean Architecture setup. V1 does not need backend boundaries, networking layers, remote repositories, authentication, sync engines, or generic infrastructure abstractions.

## 2. Version 1 constraints

Version 1 is strictly:

- iOS only;
- single-user only;
- local-only storage;
- SwiftUI;
- SwiftData;
- iOS 17+;
- no backend;
- no account system;
- no authentication;
- no cloud sync;
- no family sharing;
- no Android;
- no Firebase unless explicitly approved;
- no external packages unless explicitly justified and approved.

The architecture must protect these constraints.

## 3. Architectural goals

The architecture should support:

- fast MVP delivery;
- clear learning path for SwiftUI and SwiftData;
- small incremental implementation steps;
- understandable file organization;
- future addition of more local features;
- later migration path toward sync/backend if V2 proves necessary.

The architecture should avoid:

- backend-first thinking;
- overabstracted repositories;
- protocol-per-service patterns;
- generic networking layers;
- future sync metadata in local models;
- large dependency containers;
- complex Clean Architecture folders before there is real pressure.

## 4. Proposed folder structure

Initial structure:

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
      SupplyFormView.swift

    Maintenance/
      MaintenanceListView.swift
      MaintenanceDetailView.swift
      MaintenanceFormView.swift

    ActionList/
      ActionListView.swift

    Merchants/
      MerchantListView.swift
      MerchantDetailView.swift
      MerchantFormView.swift

    Providers/
      ProviderListView.swift
      ProviderDetailView.swift
      ProviderFormView.swift

  Models/
    SupplyItem.swift
    MaintenanceTask.swift
    Merchant.swift
    ServiceProvider.swift

  Shared/
    Components/
    Utilities/
    Extensions/
```

Important rule: do not create every folder upfront unless the implementation step needs it. This structure is a target direction, not a mandatory initial scaffold.

## 5. Responsibility boundaries

### App

Owns app entry point, root navigation setup, SwiftData model container registration, and app-level configuration.

Should not contain feature logic.

### Features

Each feature owns screens and small feature-specific UI helpers.

Examples:

- `Dashboard` shows due soon and pending items.
- `Supplies` manages household consumables.
- `Maintenance` manages recurring home tasks.
- `Merchants` manages preferred purchase sources.
- `Providers` manages service contacts.
- `ActionList` shows actionable items.

Feature folders should not introduce backend, sync, auth, or remote abstractions.

### Models

SwiftData models represent local persisted app data.

V1 models should include only local fields required by current workflows. Do not add remote IDs, account ownership, sync status, server timestamps, or DTO-like fields.

### Shared

Shared contains reusable UI components, date helpers, formatters, and small extensions.

Shared should stay small. Do not turn it into a dumping ground.

## 6. Local persistence strategy

SwiftData is the default persistence layer for V1.

Recommended approach:

- start with the smallest model fields needed for the first workflow;
- use relationships only when the UI actually needs them;
- prefer direct SwiftData usage in SwiftUI views while the app is small;
- extract helper logic only after duplication appears;
- manually verify persistence in the simulator after each model-related change.

Do not add a repository layer at the start.

Repository or service layers may be considered later only if there is a concrete V1 problem, such as repeated query logic, difficult testing, or complex derived state.

## 7. Domain model direction

Likely V1 entities:

### SupplyItem

Represents a household consumable that may run low.

Examples: water filters, dishwasher tablets, detergent, batteries, light bulbs.

V1 decision: supplies are tracked by **quantity**, not by estimated time usage.

The user should be able to open a supply item and record how many units were consumed. The app then updates the remaining quantity and can mark the item as low or out of stock based on a configured low-stock threshold.

Likely fields later:

- name;
- category;
- current quantity;
- low-stock threshold;
- unit label, for example `pcs`, `packs`, `tablets`, `filters`;
- preferred merchant reference or purchase URL;
- notes;
- created/updated dates if needed locally.

Explicitly postponed for early V1:

- automatic consumption prediction;
- usage-rate calculations;
- barcode scanning;
- price tracking;
- store inventory integration;
- remote product catalog.

### MaintenanceTask

Represents a recurring household maintenance activity.

Examples: boiler maintenance, AC cleaning, replacing filters, calling a technician.

Likely fields later:

- title;
- frequency;
- next due date;
- last completed date;
- provider reference;
- notes;
- completion state.

### Merchant

Represents a preferred place to buy supplies.

Likely fields later:

- name;
- website or purchase URL;
- notes.

### ServiceProvider

Represents a contact for maintenance tasks.

Likely fields later:

- name;
- phone;
- website;
- notes.

## 8. Supply quantity tracking decision

Supply tracking in V1 is quantity-based.

Core flow:

1. User creates a supply item.
2. User sets current quantity.
3. User sets a low-stock threshold.
4. User optionally sets a unit label.
5. Later, user opens the item and records consumed quantity.
6. App decreases current quantity.
7. If current quantity is less than or equal to the low-stock threshold, the item appears in low-stock / action sections.

Recommended early model direction:

```text
SupplyItem
  name: String
  category: String?
  currentQuantity: Int
  lowStockThreshold: Int
  unitLabel: String?
  preferredMerchantName: String?
  preferredMerchantURL: String?
  notes: String?
```

Do not introduce a separate consumption history entity at the start. It can be added later only if the product needs usage analytics or undo/history support.

## 9. Action List decision

For early V1, the Action List should preferably be **computed from Supplies and Maintenance Tasks** rather than stored as a separate SwiftData entity.

Reason:

- avoids premature data duplication;
- keeps the MVP simpler;
- validates whether users need a separate manual task list;
- prevents unclear synchronization between source item and action item.

A separate `ActionItem` entity can be introduced later if manual ad-hoc actions become an explicit MVP requirement.

## 10. Screen structure direction

Initial screen direction:

```text
TabView
  Dashboard
  Supplies
  Maintenance
  More
```

`More` can later contain:

- Merchants;
- Service Providers;
- Settings.

Do not create too many first-level tabs early. The app should feel simple and operational, not like an admin system.

## 11. Expansion path

### Still compatible with V1

The architecture can later support:

- local notifications;
- widgets;
- import/export;
- search and filters;
- richer dashboard grouping;
- manual action items;
- better recurrence rules;
- tests around date calculations;
- optional supply consumption history.

### Phase 2 only

The following require explicit architectural reassessment:

- backend;
- accounts;
- auth;
- cloud sync;
- family sharing;
- Android;
- shared household roles;
- remote analytics;
- server-driven configuration.

Do not prebuild abstractions for these in V1.

## 12. Implementation order

Recommended order:

1. Create minimal app folder structure only where needed.
2. Add root navigation with a small `TabView`.
3. Add first SwiftData model: `SupplyItem` with quantity-based fields.
4. Build Supplies list and create/edit flow.
5. Add supply detail flow for recording consumed quantity.
6. Add low-stock logic based on `currentQuantity <= lowStockThreshold`.
7. Add `MaintenanceTask` model.
8. Build Maintenance list and create/edit flow.
9. Add Dashboard with computed due-soon/running-low sections.
10. Add Merchant and ServiceProvider support only after core flows work.
11. Add computed Action List.
12. Polish UX and validate repeated usage.

## 13. Acceptance criteria for this architecture

The architecture is acceptable if:

- a new developer can understand the project structure quickly;
- a Swift learner can follow the code without heavy abstractions;
- new local features can be added without editing unrelated modules;
- SwiftData models stay local-only;
- there is no backend/auth/sync/Firebase leakage;
- MVP screens can be built incrementally;
- V2 remains possible without polluting V1.

## 14. Deferred decisions

Do not decide yet:

- exact SwiftData relationships;
- exact recurrence algorithm;
- whether ActionItem is persisted;
- notification strategy;
- iCloud/backups/sync;
- import/export format;
- testing framework depth;
- monetization;
- analytics;
- widgets;
- supply consumption history.

These should be decided only when the relevant implementation slice starts.

## 15. Architecture decision rule

Before adding a new layer, abstraction, model field, package, or feature, ask:

> Does this solve a current Version 1 user problem, or is it preparation for a future platform?

If it mainly prepares for a future platform, postpone it.
