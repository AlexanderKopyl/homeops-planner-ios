# MVP Boundary

## MVP features

The MVP should focus on a small, useful local-first workflow.

### 1. Supplies

Track household consumables that run low over time.

Examples:

- water filters;
- dishwasher tablets;
- detergent;
- batteries;
- light bulbs;
- cleaning products.

Possible fields later in implementation:

- name;
- category;
- current status;
- low-soon threshold or rough reminder date;
- preferred merchant link;
- notes.

### 2. Maintenance tasks

Track recurring household maintenance.

Examples:

- boiler maintenance;
- AC cleaning;
- replacing filters;
- calling a technician;
- checking equipment.

Possible fields later in implementation:

- title;
- frequency;
- next due date;
- provider link or contact;
- notes;
- completion state.

### 3. Home dashboard

Show what matters now:

- supplies running low soon;
- maintenance due soon;
- pending actions.

### 4. Merchants

Store preferred purchase places or links for supplies.

### 5. Service providers

Store provider contacts for maintenance tasks.

### 6. Task / buy list

Keep a practical action list derived manually or from supplies/tasks.

## Phase 2 features

Phase 2 can be considered only after the local MVP feels useful.

Possible Phase 2 items:

- iCloud sync;
- family sharing;
- accounts;
- backend API;
- multi-device collaboration;
- better notifications;
- import/export;
- widgets;
- richer search/filtering;
- analytics, if explicitly approved.

## Later features

Later features are not part of early validation:

- Android app;
- web app;
- marketplace integrations;
- merchant price tracking;
- automatic purchase recommendations;
- AI suggestions;
- barcode scanning;
- OCR receipt parsing;
- smart home integrations;
- subscription monetization;
- team/household roles.

## Rejected for Version 1

Do not implement in V1:

- backend;
- authentication;
- user accounts;
- Firebase;
- cloud sync;
- Android;
- web frontend;
- family sharing;
- push notification infrastructure;
- payment integration;
- remote configuration;
- generic networking layer;
- external SDKs without explicit approval.

## Scope control rules

1. Every feature request must be classified as MVP, Phase 2, later, or rejected for V1.
2. If a feature requires backend, accounts, sync, Firebase, or Android, it is not V1.
3. If a feature can be implemented locally and helps answer a core product question, it may be MVP.
4. Prefer one useful local workflow over many incomplete abstractions.
5. Do not add architecture for future backend until backend is explicitly approved.
6. Do not add protocols, repositories, or service layers only because they may be useful later.
7. Keep the MVP testable manually in Xcode and usable without network access.
