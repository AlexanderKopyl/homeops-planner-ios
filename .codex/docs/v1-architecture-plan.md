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

    Categories/
      CategoryListView.swift
      CategoryFormView.swift

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
    SupplyCategory.swift
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
- `Supplies` manages household consumables and provides an all-supplies view.
- `Categories` manages flat supply categories.
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

Examples: water filters, dishwasher tablets, detergent, batteries, light bulbs, air fresheners, toilet freshener blocks.

V1 decision: supplies can be tracked by **tracking type**.

Supported MVP tracking types:

1. **Quantity-based** — for items where the user knows how many units remain.
2. **Time-based** — for items that are installed or started once and should be replaced after a known end date.

The user chooses the tracking type when creating or editing a supply item.

Quantity-based examples:

- batteries;
- dishwasher tablets;
- detergent packs;
- light bulbs;
- water filters kept in stock.

Time-based examples:

- toilet air freshener block;
- installed water filter cartridge;
- air freshener refill;
- pest repellent cartridge;
- any consumable with a start date and planned replacement date.

Likely fields later:

- name;
- required category reference;
- tracking type;
- current quantity, for quantity-based items;
- low-stock threshold, for quantity-based items;
- unit label, for example `pcs`, `packs`, `tablets`, `filters`;
- start date, for time-based items;
- end date or replacement date, for time-based items;
- preferred merchant reference or purchase URL;
- notes;
- created/updated dates if needed locally.

Explicitly postponed for early V1:

- automatic consumption prediction;
- usage-rate calculations;
- barcode scanning;
- price tracking;
- store inventory integration;
- remote product catalog;
- separate consumption history entity.

### SupplyCategory

Represents a flat user-created category for grouping supplies.

Examples:

- Bathroom;
- Kitchen;
- Cleaning;
- Filters;
- Batteries;
- Pet supplies.

V1 decision: category is a separate SwiftData entity, not a plain string.

Reason:

- user can create categories once and reuse them;
- supply creation can offer category selection;
- lists can be grouped by category;
- category names can be edited in one place;
- this matches familiar shop/category mental models without requiring hierarchy.

Likely fields later:

- name;
- optional note;
- sort order, only if manual ordering becomes needed;
- created date if useful for stable sorting.

Explicitly postponed for V1:

- nested categories;
- category icons;
- category colors;
- category rules;
- remote category templates;
- separate category types for maintenance.

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

## 8. Supply tracking type decision

Supply tracking in V1 supports two explicit modes.

### Quantity-based flow

1. User creates a supply item.
2. User selects quantity-based tracking.
3. User selects or creates a required supply category.
4. User sets current quantity.
5. User sets a low-stock threshold.
6. User optionally sets a unit label.
7. Later, user opens the item and records consumed quantity.
8. App decreases current quantity.
9. If current quantity is less than or equal to the low-stock threshold, the item appears in low-stock / action sections.

### Time-based flow

1. User creates a supply item.
2. User selects time-based tracking.
3. User selects or creates a required supply category.
4. User sets `startDate`.
5. User sets `endDate`.
6. App shows whether the item is active, due soon, or expired.
7. When the user replaces the item, they set a new `startDate` and `endDate`.

V1 decision: time-based supplies store both `startDate` and `endDate`.

Reason:

- `startDate` captures when the consumable was installed or started;
- `endDate` captures when it should be replaced;
- the pair supports progress display later without changing the model;
- the app does not need automatic duration or recurrence calculation in the first implementation.

Important distinction: time-based supplies are still consumables, not maintenance tasks. They model the lifecycle of an item that was installed or started. Recurring service work belongs to `MaintenanceTask`.

Recommended early model direction:

```text
SupplyItem
  name: String
  category: SupplyCategory
  trackingType: SupplyTrackingType

  // Quantity-based fields
  currentQuantity: Int?
  lowStockThreshold: Int?
  unitLabel: String?

  // Time-based fields
  startDate: Date?
  endDate: Date?

  // Common fields
  preferredMerchantName: String?
  preferredMerchantURL: String?
  notes: String?

SupplyCategory
  name: String
  note: String?
```

Recommended computed states:

```text
isLowStock      // quantity-based: currentQuantity <= lowStockThreshold
isExpired       // time-based: today > endDate
isDueSoon       // time-based: endDate is near, exact threshold decided later
needsAction     // low stock or expired/due soon
```

Do not introduce a separate consumption history entity at the start. It can be added later only if the product needs usage analytics or undo/history support.

## 9. Supply category decision

Supply categories are separate local entities in V1.

V1 decision: every `SupplyItem` must belong to exactly one `SupplyCategory`.

Reason:

- keeps supply organization consistent;
- supports shop-like category browsing;
- avoids long-term uncategorized data mess;
- makes grouped lists and filters predictable.

Core category flow:

1. User opens category management or creates a category inline while creating a supply.
2. User enters category name.
3. User can assign supplies to that category.
4. Supply list can group or filter items by category.
5. Editing a category name affects all assigned supplies.
6. User can still open an all-supplies list without entering a specific category.

Recommended relationship:

```text
SupplyCategory 1 → many SupplyItem
SupplyItem many → 1 required SupplyCategory
```

V1 category scope:

- flat categories only;
- categories are local-only;
- category is required for a supply item;
- user can browse by category;
- user can also browse all supply items in one list.

Recommended delete behavior:

```text
When deleting category:
  prevent deletion if supplies are assigned
  or require moving assigned supplies to another category first
```

Because category is required, deleting a category must not leave supplies without a category.

## 10. All supplies view decision

Even though every supply belongs to a category, the app should provide an all-supplies view.

Reason:

- users should not be forced to enter each category to find an item;
- the app needs a global low-stock / due-soon overview;
- search and filters will be easier later;
- this keeps the UX closer to a practical inventory list, not only a category browser.

Recommended V1 behavior:

```text
Supplies tab
  All supplies list
  Optional category filter/grouping
  Category management accessible from More or from the supply form
```

Do not make category browsing the only navigation path.

## 11. Action List decision

For early V1, the Action List should preferably be **computed from Supplies and Maintenance Tasks** rather than stored as a separate SwiftData entity.

Reason:

- avoids premature data duplication;
- keeps the MVP simpler;
- validates whether users need a separate manual task list;
- prevents unclear synchronization between source item and action item.

A separate `ActionItem` entity can be introduced later if manual ad-hoc actions become an explicit MVP requirement.

## 12. Screen structure direction

Initial screen direction:

```text
TabView
  Dashboard
  Supplies
  Maintenance
  More
```

`Supplies` should show all supply items by default. Category browsing/filtering can exist inside this tab, but it should not replace the all-items list.

`More` can later contain:

- Categories;
- Merchants;
- Service Providers;
- Settings.

Do not create too many first-level tabs early. The app should feel simple and operational, not like an admin system.

## 13. Expansion path

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
- optional supply consumption history;
- more tracking types only if a real product case appears;
- category icons/colors only if the UI needs them.

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

## 14. Implementation order

Recommended order:

1. Create minimal app folder structure only where needed.
2. Add root navigation with a small `TabView`.
3. Add SwiftData model: `SupplyCategory`.
4. Add SwiftData model: `SupplyItem` with explicit tracking type and required category.
5. Build minimal category create/list flow or inline category creation.
6. Build Supplies all-items list and create/edit flow.
7. Add category assignment in supply form.
8. Add quantity-based detail flow for recording consumed quantity.
9. Add quantity low-stock logic based on `currentQuantity <= lowStockThreshold`.
10. Add time-based fields and status logic: active, due soon, expired.
11. Add `MaintenanceTask` model.
12. Build Maintenance list and create/edit flow.
13. Add Dashboard with computed due-soon/running-low sections.
14. Add Merchant and ServiceProvider support only after core flows work.
15. Add computed Action List.
16. Polish UX and validate repeated usage.

## 15. Acceptance criteria for this architecture

The architecture is acceptable if:

- a new developer can understand the project structure quickly;
- a Swift learner can follow the code without heavy abstractions;
- new local features can be added without editing unrelated modules;
- SwiftData models stay local-only;
- there is no backend/auth/sync/Firebase leakage;
- MVP screens can be built incrementally;
- every supply item has a category;
- user can view all supply items without entering a category;
- V2 remains possible without polluting V1.

## 16. Deferred decisions

Do not decide yet:

- exact SwiftData delete rule syntax;
- exact recurrence algorithm;
- whether ActionItem is persisted;
- notification strategy;
- iCloud/backups/sync;
- import/export format;
- testing framework depth;
- monetization;
- analytics;
- widgets;
- supply consumption history;
- exact due-soon threshold for time-based supplies;
- category icons/colors;
- nested categories.

These should be decided only when the relevant implementation slice starts.

## 17. Architecture decision rule

Before adding a new layer, abstraction, model field, package, or feature, ask:

> Does this solve a current Version 1 user problem, or is it preparation for a future platform?

If it mainly prepares for a future platform, postpone it.
