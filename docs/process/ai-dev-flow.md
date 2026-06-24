# AI Development Flow

AI-assisted development for this app is artifact-driven. Chat is useful for exploration, but the repository is the source of durable memory.

## Core Rule

Meaningful changes require a durable artifact before implementation.

A meaningful change includes:

- New product behavior
- Data model changes
- New AI behavior or prompts
- Privacy, retention, export, or deletion behavior
- Mobile navigation or interaction patterns
- User-facing copy that changes the product promise
- Background jobs, notifications, or scheduled workflows

Small fixes, formatting, and local refactors may proceed without a new brief when they do not alter product behavior.

## Standard Flow

Use this flow for meaningful product and architecture work:

1. Orient
2. Define
3. Challenge
4. Slice
5. Implement
6. Verify
7. Handoff

## 1. Orient

Start from the product north star: does this help parents connect with their children, understand who they are becoming, or preserve meaningful memories?

Read the relevant durable docs:

- `docs/AGENTS.md`
- `docs/product/mvp-product-goal.md`
- `docs/product/product-principles.md`
- `docs/features/_constraints.md`
- Relevant feature brief
- Relevant architecture docs
- `docs/process/verification.md`

## 2. Define

If no feature brief exists, create one under `docs/features/active/`.

Before coding, define:

- User problem
- Product intent
- In scope
- Out of scope
- Acceptance criteria
- Verification plan

## 3. Challenge

Before implementation, ask whether the work should be smaller, simpler, postponed, or removed.

Challenge questions:

- Can this be a smaller slice?
- Can this wait until after the MVP loop works?
- Does this support conversation, connection, understanding, memory, or legacy?
- Does this risk becoming a tracker, dashboard, clinical tool, optimization product, or generic AI app?
- Does it collect more child data than needed?
- Does it preserve parent review and control?
- Is Rails convention enough for this?

If the answer changes scope, update the feature brief before coding.

## 4. Slice

Implement the smallest Rails-first change that satisfies the brief.

Prefer:

- Conventional Rails resources
- Server-rendered Hotwire-compatible views
- Focused Stimulus controllers only where useful
- Plain, testable service objects or jobs when behavior does not belong in controllers

## 5. Implement

Make the scoped change. Do not add adjacent features just because they are nearby.

## 6. Verify

Run tests and manual checks appropriate to the change. Use `docs/process/verification.md` as the baseline.

## 7. Handoff

Leave a clear trail:

- What changed
- Why it changed
- Product promise supported
- Tests/checks run
- AI/privacy risks considered
- Docs updated or not updated
- Known risks and follow-ups

Use `docs/process/handoff.md` as the handoff checklist.

Move completed feature briefs to `docs/features/completed/` only after implementation and verification.

## Feature Brief Expectations

Every feature brief should include:

- User problem
- Product intent
- In scope
- Out of scope
- User stories or flows
- Data model notes
- UI notes
- AI behavior notes, if applicable
- Privacy and child data notes
- Acceptance criteria
- Verification plan
- Open questions

Use `docs/features/_constraints.md` as a standing checklist for every brief.

## AI Session Hygiene

- Do not assume prior chat context is durable.
- If a decision matters later, write it down.
- If implementation reveals a better approach, update the relevant doc in the same change.
- Prefer specific file references over vague memory.
- Keep docs short enough to stay useful, but explicit enough to prevent repeated rediscovery.

## Rails-First Implementation Bias

- Use conventional Rails resources before inventing custom architecture.
- Keep business rules in models, policies, jobs, or service objects rather than controllers.
- Use Hotwire for interactive behavior unless a richer client-side tool is clearly justified.
- Build server-rendered experiences that remain usable if JavaScript is limited.
- Design views so they can later fit into a Hotwire Native wrapper.
- Avoid premature abstractions.
- Prefer small slices over broad rewrites.
- Do not turn the app into a tracker, dashboard, clinical tool, optimization product, or generic AI app.

## When To Create A Decision Record

Create a decision record in `docs/decisions/` when the team chooses among durable alternatives, especially around:

- AI provider or model behavior
- Storage and retention of child data
- Voice recording storage and transcription
- Mobile wrapper strategy
- Subscription and monetization choices
- Data export or deletion guarantees
- Authorization boundaries
- Background job architecture
