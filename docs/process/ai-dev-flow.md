# AI Development Flow

AI-assisted development for this app is artifact-driven. Chat is useful for exploration, but the repository is the source of durable memory.

## Core Rule

Meaningful changes require a durable artifact before implementation.

Use the lowest risk tier that honestly fits the change. When unsure, choose the higher tier.

A meaningful change includes:

- New product behavior
- Data model changes
- New AI behavior or prompts
- Privacy, retention, export, or deletion behavior
- Mobile navigation or interaction patterns
- User-facing copy that changes the product promise
- Background jobs, notifications, or scheduled workflows

Small fixes, formatting, and local refactors may proceed without a new brief when they do not alter product behavior.

## Risk Tiers

The tier controls how much durable context, documentation, and verification the task needs. It should reduce process cost for low-risk work without weakening product, privacy, or AI safety checks.

### Fast Path

Use the fast path for low-risk work that does not change product behavior, data contracts, privacy expectations, AI behavior, authorization, navigation, or the product promise.

Examples:

- Typos and copy edits that do not change the product promise
- Formatting and lint-only changes
- Small local refactors with no behavior change
- Test cleanup or narrow test additions
- Minor styling fixes that do not affect a core flow

Fast path expectations:

- Apply the Fast Path checklist in `docs/features/_constraints.md`.
- Read only the relevant files and any immediately necessary docs.
- Do not create a new feature brief.
- Implement the narrow change.
- Run the narrowest useful verification.
- Leave a concise handoff with files changed and checks run.

### Standard Path

Use the standard path for meaningful product or architecture work where the risk is real but bounded.

Examples:

- New product behavior inside the MVP scope
- Data model changes that do not introduce sensitive new categories
- User-facing flows or navigation changes
- Background jobs or scheduled workflows
- Product copy that affects expectations or trust

Standard path expectations:

- Apply the Standard Path checklist in `docs/features/_constraints.md`.
- Follow the Standard Flow below.
- Create or update the relevant feature brief before coding.
- Use the required reading order in `docs/AGENTS.md` to identify the product, feature, architecture, and verification docs that apply to the change.
- Challenge scope before implementation.
- Run verification appropriate to the behavior changed.
- Leave the full handoff trail.

### High-Risk Path

Use the high-risk path when a change touches child data protection, AI interpretation, privacy, deletion, export, authorization boundaries, provider behavior, billing, or durable architectural direction.

Examples:

- AI prompts, summaries, transcription, reflection letters, or model/provider choices
- Voice recordings, transcripts, exports, deletion, or retention behavior
- Authorization and account ownership boundaries
- Data sent to third-party services
- Mobile wrapper strategy or native-only capabilities
- Subscription and monetization choices

High-risk path expectations:

- Apply the High-Risk checklist in `docs/features/_constraints.md`.
- Follow the Standard Flow with extra scrutiny.
- Read the relevant architecture docs and decision records before coding.
- Document the extra notes required by the High-Risk checklist and relevant architecture docs.
- Create a decision record when choosing among durable alternatives.
- Prefer smaller implementation slices and stronger verification.
- Explicitly name unresolved risks in the handoff.

## Standard Flow

Use this flow for standard-path and high-risk-path work:

1. Orient
2. Define
3. Challenge
4. Slice
5. Implement
6. Verify
7. Handoff

## 1. Orient

Start from the product north star: does this help parents connect with their children, understand who they are becoming, or preserve meaningful memories?

Use the required reading order in `docs/AGENTS.md` as the authoritative source for durable context. Read the docs that apply to the selected risk tier and the specific change.

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
- Does it satisfy the standing constraints for the selected risk tier?

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

Use `docs/process/handoff.md` for the handoff expected by the selected risk tier.

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

Use the relevant risk-tier checklist in `docs/features/_constraints.md` for every brief.

## AI Session Hygiene

- Do not assume prior chat context is durable.
- If a decision matters later, write it down.
- If implementation reveals a better approach, update the relevant doc in the same change.
- Prefer specific file references over vague memory.
- Keep docs short enough to stay useful, but explicit enough to prevent repeated rediscovery.

## Rails-First Implementation Bias

Use the implementation shape in `docs/features/_constraints.md` as the standing Rails-first checklist. Prefer the smallest conventional Rails and Hotwire-compatible slice that satisfies the brief.

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
