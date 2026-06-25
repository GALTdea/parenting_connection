# AGENTS.md - AI Agent Entry Point

Read this file first in every AI-assisted development session.

This repository is the durable memory for the Parent-Child Connection App. AI chats are ephemeral. Decisions, feature intent, verification expectations, and product constraints belong in `docs/` so future humans and agents can continue the work without guessing.

## Product North Star

Does this help parents connect with their children, understand who they are becoming, or preserve meaningful memories?

Product formula:

Conversation -> Connection -> Understanding -> Memory -> Legacy

If a proposed change does not clearly support that north star, pause and update the relevant product or feature documentation before implementing it.

## Conflict Hierarchy

When durable docs or tool instructions appear to conflict, resolve product work in this order:

1. Product safety and privacy constraints
2. Product north star
3. MVP goal
4. Relevant feature brief
5. General AI development process
6. Tool preferences

## Development Posture

- Rails-first. Prefer conventional Rails models, controllers, views, jobs, policies, and service objects before introducing new layers.
- Hotwire-compatible UI. Build server-rendered Rails views that work well with Turbo and Stimulus.
- Mobile-aware from the beginning. The web app should be ready for an eventual Hotwire Native iOS/Android wrapper.
- Artifact-driven AI development. Meaningful changes require durable artifacts: feature briefs, architecture notes, verification notes, and decision records.
- Challenge scope before building. Ask whether the feature can be smaller, simpler, postponed, or removed.
- Parent-reviewed AI. AI output may support reflection, summarization, and memory retrieval, but parents remain in control of what is saved, shown, shared, or sent.
- Gentle, non-clinical, non-diagnostic language. The app may help parents notice patterns and preserve memories; it must not diagnose children, score parenting, or make medical/psychological claims.
- Privacy and child data protection are core constraints, not later hardening work.

## Required Reading Order

Before making a meaningful product or architecture change:

1. Read this file.
2. Read `docs/product/mvp-product-goal.md`.
3. Read `docs/product/product-principles.md`.
4. Read `docs/features/_constraints.md`.
5. Read the relevant active feature brief in `docs/features/active/`.
6. Read relevant architecture docs.
7. Read `docs/process/ai-dev-flow.md`.
8. Read `docs/process/verification.md`.
9. Read `docs/process/prompting.md` when shaping an AI task.
10. Read `docs/process/handoff.md` before finalizing an AI-assisted task.

If no feature brief exists for a meaningful change, create or update one before coding.

For a new stage or new feature brief, stop after drafting or updating the brief and wait for human approval before implementation unless the user explicitly requests an end-to-end run.

Do not implement a meaningful feature from chat context alone.

## Current MVP Focus

The MVP is centered on:

- Parent accounts
- Child profiles
- Daily question system
- Prompt library
- Text responses
- Voice recordings
- Timeline view
- Memory archive
- Basic AI summaries
- Monthly reflection letter

The first completed implementation brief is:

- `docs/features/completed/parent-accounts-and-child-profiles-stage-1.md`

## Stack

- Ruby 4.0.5
- Rails 8.1.3
- Node.js 24.18.0 LTS + npm
- PostgreSQL
- Hotwire: Turbo + Stimulus
- importmap
- propshaft 1.3.x
- Puma 8.x
- Tailwind CSS 4.3.x + daisyUI 5.5.23
- Devise 5.0.4 + devise_invitable 2.0.12
- Pundit
- Solid Queue 1.4.x + Solid Cable 4.x
- Pagy 9.x
- friendly_id 5.7.x
- meta-tags 2.23.x
- RSpec + FactoryBot
- Kamal 2.12.x
- Brakeman 8.x
- RuboCop 1.88.x via rubocop-rails-omakase

Exact patch versions are in `Gemfile.lock`.

## How to Run

```sh
bin/dev
npm install
bundle exec rspec
bundle exec rubocop
bin/rails tailwindcss:build
bin/rails db:prepare
```

## Key Existing App Files

| File | Purpose |
| --- | --- |
| `app/controllers/application_controller.rb` | Pundit, Pagy::Backend, layout routing |
| `app/helpers/application_helper.rb` | Pagy::Frontend |
| `app/helpers/settings_helper.rb` | App settings helpers |
| `app/views/layouts/` | Application, dashboard, and Devise layouts |
| `app/views/shared/` | Shared UI partials |
| `app/assets/tailwind/application.css` | Tailwind 4 + daisyUI config |
| `config/initializers/pagy.rb` | Pagination config |
| `config/initializers/friendly_id.rb` | Slug config |
| `config/initializers/meta_tags.rb` | SEO config |

## Durable Documentation Map

| File | Purpose |
| --- | --- |
| `docs/process/ai-dev-flow.md` | How AI-assisted work moves from prompt to durable artifact to implementation |
| `docs/process/prompting.md` | How to prompt AI tools for this repo without overbuilding |
| `docs/process/handoff.md` | Proportional handoff trail after AI-assisted work |
| `docs/process/verification.md` | Verification expectations by type of change |
| `docs/product/strategy-2026.md` | Product strategy, audience, bets, and non-goals |
| `docs/product/mvp-product-goal.md` | MVP scope and success definition |
| `docs/product/product-principles.md` | Product voice, safety, privacy, and product boundaries |
| `docs/features/_constraints.md` | Standing constraints checklist by risk tier |
| `docs/features/active/` | Current implementation briefs |
| `docs/features/completed/` | Completed briefs after implementation and verification |
| `docs/features/parked/` | Deferred briefs and ideas |
| `docs/architecture/data-model.md` | Durable data model direction |
| `docs/architecture/ai-architecture.md` | AI responsibilities, boundaries, review model, privacy, and failure behavior |
| `docs/architecture/mobile-strategy.md` | Hotwire Native direction and mobile constraints |
| `docs/decisions/adr-template.md` | Lightweight template for meaningful decision records |
| `docs/decisions/` | Decision records for choices that should survive chat history |

## What Not To Do

- Do not implement application features without a relevant feature brief.
- Do not skip the Challenge step for meaningful changes.
- Do not create models, controllers, migrations, or jobs as placeholders.
- Do not use AI output as a clinical, diagnostic, or parenting-score authority.
- Do not turn the app into a tracker, dashboard, clinical tool, optimization product, or generic AI app.
- Do not expose child data to third-party services without an explicit architecture note and privacy review.
- Do not build UI that depends on hover-only interactions or desktop-only workflows.
- Do not use Bootstrap or Tabler classes.
- Do not add Kaminari; Pagy is already configured.
- Do not install Redis; Solid Queue handles background jobs.
- Do not write raw SQL when ActiveRecord is appropriate.
- Do not put business logic in controllers.

## Current Status

This app is still in documentation and foundation setup for the Parent-Child Connection product. The starter Rails app exists, but product features should not be implemented until the corresponding feature brief has been created or updated.
