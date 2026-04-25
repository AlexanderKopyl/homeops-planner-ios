# Dashboard Design Plan (V1)

## 1. Goal

Design a simple, action-oriented home screen for HomeOps Planner.

The Dashboard must help users quickly understand:

- what needs attention now;
- what is running low;
- what should be replaced soon;
- what maintenance is coming up.

The Dashboard is not an analytics or reporting screen.

## 2. Screen placement

```text
TabView
  Dashboard (this screen)
  Supplies
  Maintenance
  More
```

Dashboard is the default entry point.

## 3. Core UX structure

Dashboard uses a simple vertical layout:

```text
ScrollView
  VStack
    Header
    Quick Summary
    Needs Attention
    Running Low
    Due Soon
    Maintenance
```

V1 decision: the header is a normal block inside `ScrollView`, not pinned or sticky.

Reason:

- simpler SwiftUI implementation;
- no special scroll behavior;
- enough for MVP;
- avoids navigation/header complexity before there is a real need.

## 4. Section details

### Header

Purpose:

- give context;
- keep screen grounded.

Placement:

- inside the main `ScrollView` as the first block;
- not sticky;
- not pinned;
- no custom collapsing header.

Content:

```text
HomeOps
Today, Apr 25
```

No profile, no avatar, no account-related UI.

---

### Quick Summary

Purpose:

- fast overview of system state.

Content:

```text
Low stock: X
Due soon: X
Overdue: X
```

UI:

- 2–3 compact cards or inline blocks.

---

### Needs Attention (highest priority)

Purpose:

- highlight critical items.

Includes:

- low stock supplies;
- expired time-based supplies;
- overdue maintenance tasks.

Behavior:

- show only when non-empty;
- should be visually emphasized.

---

### Running Low

Purpose:

- show supplies that need restocking soon.

Item structure:

```text
Item name
Quantity left · Category
```

Example:

```text
Dishwasher tablets
3 left · Kitchen
```

---

### Due Soon

Purpose:

- show time-based supplies nearing end date.

Item structure:

```text
Item name
Replace by date · Category
```

Example:

```text
Toilet freshener
Replace by May 2 · Bathroom
```

---

### Maintenance

Purpose:

- show upcoming or overdue maintenance tasks.

Item structure:

```text
Task name
Due in X days
```

Example:

```text
Clean AC
Due in 5 days
```

---

## 5. Empty states

### Full empty state

```text
Your home is clear for now.
Add supplies or maintenance tasks to start tracking.
```

Actions:

- Add Supply
- Add Maintenance

### Section-level empty

Options:

- hide section;
- or show compact message:

```text
No items here
```

---

## 6. Interaction rules

- tapping item → opens detail screen;
- no inline editing in V1;
- no swipe actions required initially;
- no drag & drop;
- no bulk actions.

---

## 7. Visual guidelines

- native iOS look (SwiftUI default components);
- no heavy design system;
- no custom animations;
- clear typography hierarchy;
- small spacing;
- readable lists;
- light card usage if needed;
- avoid over-decoration.

---

## 8. What to postpone

Do not design in V1:

- charts;
- analytics;
- spending;
- predictions;
- AI suggestions;
- widgets;
- notifications UI;
- family/multi-user views;
- marketplace/store UI;
- advanced filters;
- tagging systems;
- sticky/pinned dashboard header.

---

# Task for Designer

## Goal

Create wireframes (low-fidelity) for the Dashboard screen.

## Deliverables

1. Single screen wireframe of Dashboard
2. Section breakdown with labels
3. Example list items for each section
4. Empty state version

## Requirements

- must follow section structure defined above;
- must use `ScrollView` + `VStack` mental model;
- header must be a normal first block inside the scroll content;
- must be minimal and clean;
- must feel like native iOS;
- must prioritize readability and clarity;
- must not introduce extra features.

## Constraints

Do NOT include:

- login/profile
- avatars
- analytics charts
- complex filters
- category management UI here
- settings
- notifications UI
- sticky header
- collapsing header

## Output format

Provide:

- annotated wireframe description (text is enough)
- optional sketch-style layout (ASCII / simple diagram is OK)
- notes explaining UX decisions

## Evaluation criteria

The design is good if:

- user instantly understands what needs attention;
- screen is scannable in < 3 seconds;
- no unnecessary elements are present;
- sections feel ordered by priority;
- it can be easily implemented with SwiftUI `ScrollView` and `VStack`.
