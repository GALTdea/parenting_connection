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

1. Start from the product north star: does this help parents connect with their children, understand who they are becoming, or preserve meaningful memories?
2. Read the relevant durable docs:
   - `docs/AGENTS.md`
   - `docs/product/product-principles.md`
   - `docs/process/verification.md`
   - Relevant architecture docs
   - Relevant feature brief
3. If no feature brief exists, create one under `docs/features/active/`.
4. Define acceptance criteria before coding.
5. Implement the smallest Rails-first change that satisfies the brief.
6. Verify with tests and manual checks appropriate to the change.
7. Update docs when implementation changes the durable plan.
8. Move completed feature briefs to `docs/features/completed/` only after implementation and verification.

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
