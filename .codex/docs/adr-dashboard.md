# ADR: Dashboard as Action-Oriented Home Screen

## Status

Accepted for Version 1.

## Context

HomeOps Planner V1 is an iOS-only, single-user, local-first app for managing household supplies and recurring maintenance tasks.

The Dashboard is the first tab and should answer the user's immediate operational questions:

- What needs attention now?
- What is running low?
- What should be replaced soon?
- What maintenance is due soon or overdue?

Version 1 has no backend, account system, sync, family sharing, Firebase, analytics SDK, marketplace, or external integrations.

## Decision

The Dashboard will be an **action-oriented overview screen**, not an analytics or reporting dashboard.

It will aggregate local data from:

- `SupplyItem`
- `MaintenanceTask`

It will not introduce a separate persisted `Dashboard` entity.

Recommended tab placement:

```text
TabView
  Dashboard
  Supplies
  Maintenance
  More
```

Recommended Dashboard sections:

```text
Dashboard
  Header
  Quick Summary
  Needs Attention
  Running Low
  Due Soon
  Maintenance
```

## Section responsibilities

### Header

Shows app context and current day.

Example:

```text
HomeOps
Today, Apr 25
```

Do not include login/profile/avatar concepts in V1.

### Quick Summary

Shows compact counters:

```text
Low stock: 3
Due soon: 2
Overdue: 1
```

The goal is quick orientation, not detailed analytics.

### Needs Attention

Highest-priority section.

Includes:

- quantity-based supplies where `currentQuantity <= lowStockThreshold`;
- time-based supplies that are expired;
- maintenance tasks that are overdue.

### Running Low

Shows quantity-based supplies requiring restock.

Example row:

```text
Dishwasher tablets
3 left · Kitchen
```

### Due Soon

Shows time-based supplies that should be replaced soon.

Example row:

```text
Toilet freshener
Replace by May 2 · Bathroom
```

### Maintenance

Shows maintenance tasks due soon or overdue.

Example row:

```text
Clean AC
Due in 5 days
```

## Priority order

Items should be prioritized as:

```text
Expired / overdue
Low stock
Due soon
Normal
```

## Empty states

If there is no data yet:

```text
Your home is clear for now.
Add supplies or maintenance tasks to start tracking.
```

Primary actions:

- Add Supply
- Add Maintenance

If only a specific section is empty, the section may be hidden or show a compact empty message.

## Consequences

Positive:

- keeps the home screen useful and focused;
- avoids enterprise-style inventory UI;
- supports quick daily usage;
- works fully with local SwiftData models;
- avoids premature analytics/reporting scope.

Trade-offs:

- the Dashboard depends on computed state from supplies and maintenance;
- due-soon thresholds still need to be finalized later;
- the first implementation should stay simple and may not have all polish immediately.

## Not allowed in Version 1 Dashboard

Do not include:

- spending charts;
- monthly analytics;
- AI suggestions;
- family activity;
- account/profile data;
- marketplace recommendations;
- store integrations;
- calendar integrations;
- weather/contextual cards;
- complex filters;
- widgets;
- remote analytics SDKs.

## Implementation notes

Initial implementation can use simple SwiftUI views and computed filters.

Avoid adding:

- `DashboardRepository`;
- `DashboardService`;
- backend abstractions;
- sync abstractions;
- a persisted `Dashboard` model.

Possible UI components later:

```text
DashboardView
DashboardSummaryCard
DashboardSection
DashboardItemRow
```

Create these only when needed by the implementation slice.
