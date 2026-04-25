# Welcome Screen Plan

## Classification
MVP

## Goal
Add a small first-launch Welcome Screen plan that introduces HomeOps Planner's local household tracking purpose without creating account, sync, onboarding, or backend expectations.

## Architecture Decision
- Add a Welcome Screen as an MVP-supporting entry experience, not as a required product module. It helps a first-time user understand what the local app is for before reaching the main app shell.
- Show it on first launch only. Showing it every launch would slow down access to the dashboard, supplies, maintenance, and pending actions, which are the app's daily-use surfaces.
- Store completion state locally with `@AppStorage`, backed by UserDefaults, using a simple key such as `hasCompletedWelcome`.
- Do not use SwiftData for this flag. SwiftData should remain focused on user-created household data such as supplies, maintenance tasks, merchants, providers, and action items.
- Do not skip storage if first-launch behavior is selected. Without local storage, the app cannot reliably avoid showing the Welcome Screen again.
- This approach fits V1 because it is iOS-only, local-only, Apple-native, simple for a Swift learner, and avoids backend, accounts, sync, Firebase, analytics, or a settings/preferences model.

## Smallest Implementation Step
Create a single SwiftUI `WelcomeView` under the Welcome feature folder, add a lightweight root gate that reads `@AppStorage("hasCompletedWelcome")`, and show either the Welcome Screen or the existing main app root without changing persistence models.

## Files Likely Affected Later
- `HomeOpsPlanner/HomeOpsPlanner/Features/Welcome/WelcomeView.swift` — new focused SwiftUI screen for first-launch welcome content and the primary CTA.
- `HomeOpsPlanner/HomeOpsPlanner/App/RootView.swift` — future root gate that decides between the Welcome Screen and the main app shell.
- `HomeOpsPlanner/HomeOpsPlanner/App/ContentView.swift` — may remain the temporary main screen or become the main tab view while `RootView` owns first-launch routing.
- `HomeOpsPlanner/HomeOpsPlanner/App/HomeOpsPlannerApp.swift` — may point the app scene at `RootView` instead of directly showing the current root content.

## Proposed Screen Content
- title: HomeOps Planner
- subtitle: Keep household supplies, maintenance, contacts, and pending actions in one local-first place.
- benefit point 1: See what is running low soon.
- benefit point 2: Track maintenance that needs attention.
- benefit point 3: Keep preferred stores and service contacts easy to find.
- primary CTA: Get Started

## Navigation Flow
First launch -> Welcome Screen -> Main TabView

Returning launch -> Main TabView

Until the real `TabView` exists, the same flow can route to the current main content screen as the placeholder app shell.

## Implementation Plan
1. Add `WelcomeView` with static local copy, three benefit rows, and a primary `Get Started` button that receives an `onComplete` closure.
2. Add `RootView` with `@AppStorage("hasCompletedWelcome")` to switch between `WelcomeView` and the main app shell.
3. Update `HomeOpsPlannerApp` to display `RootView`, then verify first launch, tap-through, relaunch behavior, and the existing main screen on an iOS 17+ simulator.

## Acceptance Criteria
- Welcome Screen is local-only.
- User can continue into the app.
- Completion state is stored locally if needed.
- Returning users do not see the screen again if first-launch behavior is selected.
- No backend/auth/sync/account concepts are introduced.
- App still builds on iOS 17+ simulator.

## Trade-offs
- AppStorage vs SwiftData vs no persistence: `@AppStorage` is the smallest correct fit for one local boolean preference. SwiftData would over-model an app preference as domain data. No persistence would only fit if the Welcome Screen appeared every launch, which is not the preferred UX.
- One-screen welcome vs multi-step onboarding: one screen is enough for V1 and avoids turning a simple introduction into an onboarding flow. Multi-step onboarding should wait until there are real setup decisions, and V1 currently has none that require first-run capture.
- Putting Welcome under Features vs App: `Features/Welcome` keeps the screen with other product-facing UI. `App` should own root composition and launch routing, not the welcome layout itself.

## Risks
- Scope creep into onboarding/account setup.
- Premature settings/preferences model.
- Navigation complexity too early.

## Postpone
- Login, signup, account creation, authentication, and user profiles.
- Cloud sync, iCloud setup, family sharing, invites, and multi-device collaboration.
- Firebase, backend setup, remote templates, analytics SDKs, and remote configuration.
- Subscription, paywall, purchase flows, and monetization messaging.
- Permission requests unless a later V1 feature has an immediate need.
- Multi-page onboarding, personalization questionnaires, sample data creation, and import flows.
- SwiftData models for app preferences or welcome completion.

## Next Codex Implementation Prompt
Title: Implement First-Launch Welcome Screen

Goal: Add a small SwiftUI Welcome Screen gated by local `@AppStorage` state, then route completed or returning users into the existing main app shell.
