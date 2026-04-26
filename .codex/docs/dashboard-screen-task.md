# Dashboard Screen Designer Task

## Classification

MVP

## Goal

Create concise low-fidelity Dashboard screen requirements for HomeOps Planner V1.

The Dashboard is the app's default home screen. It should help a single household user quickly answer:

- What needs attention now?
- What supplies are running low?
- What consumables should be replaced soon?
- What maintenance is coming up?

## Product Boundaries

The Dashboard must stay within the V1 scope:

- iOS only
- single user
- local-only data
- native SwiftUI feel
- no accounts, profiles, avatars, sync, backend, Firebase, family sharing, marketplace, analytics, or AI features

## Screen Structure

Design one native iOS Dashboard screen with these sections:

1. Header
2. Quick Summary
3. Needs Attention
4. Running Low
5. Due Soon
6. Maintenance

The Dashboard should be optimized for scanning and action, not reporting.

## Header

Purpose:

- ground the screen in the household context
- show the current date

Example content:

```text
HomeOps
Today, Apr 25
```

Do not include profile, avatar, login, account, cloud, or sharing UI.

## Quick Summary

Purpose:

- give a fast count of what needs attention

Suggested summary items:

```text
Low stock: 3
Due soon: 2
Overdue: 1
```

Use compact native-feeling blocks or small cards. Keep them readable and understated.

## Needs Attention

Purpose:

- show the highest-priority items first

Include:

- low-stock quantity-based supplies
- expired or nearly expired time-based supplies
- overdue maintenance tasks

Behavior:

- show this section only when it has items
- visually prioritize it over the lower-priority sections
- avoid alarmist styling

Example items:

```text
Dishwasher tablets
3 left · Kitchen

Water filter cartridge
Replace today · Filters

Boiler inspection
Overdue by 4 days
```

## Running Low

Purpose:

- show quantity-based supplies that should be restocked soon

Item format:

```text
Item name
Quantity left · Category
```

Example:

```text
Dishwasher tablets
3 left · Kitchen
```

## Due Soon

Purpose:

- show time-based supplies nearing their replacement date

Item format:

```text
Item name
Replace by date · Category
```

Example:

```text
Toilet freshener
Replace by May 2 · Bathroom
```

## Maintenance

Purpose:

- show recurring maintenance tasks that are upcoming or overdue

Item format:

```text
Task name
Due timing
```

Example:

```text
Clean AC
Due in 5 days
```

## Empty States

### Full Empty Dashboard

Use when there are no supplies, maintenance tasks, or pending actions.

Suggested copy:

```text
Your home is clear for now.
Add supplies or maintenance tasks to start tracking.
```

Primary actions:

- Add Supply
- Add Maintenance

### Section Empty State

Prefer hiding empty sections. If a section must remain visible, use a compact message:

```text
No items here
```

## Interactions

Required:

- tap a supply item to open its supply detail screen
- tap a maintenance item to open its maintenance detail screen
- provide clear entry points to add a supply and add maintenance

Not required for V1:

- inline editing
- swipe actions
- drag and drop
- bulk actions
- advanced filtering
- charts
- notifications UI

## Visual Direction

Use a clean native iOS layout:

- SwiftUI-standard navigation and list patterns
- clear typography hierarchy
- compact spacing
- readable rows
- restrained color
- light card usage only where it improves scanning
- no custom illustration requirement
- no heavy design system
- no custom animations

The screen should feel practical, calm, and household-operations focused.

## Deliverables

The designer should provide:

1. A low-fidelity Dashboard wireframe
2. A filled-state version with realistic example items
3. A full empty-state version
4. Section labels matching this document
5. Notes for any layout choices that affect SwiftUI implementation

## Acceptance Criteria

- The Dashboard uses the required section structure.
- The screen clearly separates urgent items from lower-priority overview lists.
- The design includes realistic examples for running-low supplies, time-based supplies, and maintenance tasks.
- The empty state includes Add Supply and Add Maintenance actions.
- The design feels native to iOS and does not introduce out-of-scope V1 concepts.

## Postpone

Do not design these for V1:

- accounts or profiles
- cloud sync or sharing
- charts or analytics
- AI suggestions
- widgets
- marketplace or store integrations
- price tracking
- barcode scanning
- notification settings
- advanced filters or tags
