# Standing Constraints

Use this checklist for feature briefs, implementation, verification, and handoff. Apply the lowest risk tier that honestly fits the change; when unsure, use the higher tier.

## Fast Path Checklist

Use for low-risk work that does not change product behavior, data contracts, privacy expectations, AI behavior, authorization, navigation, or the product promise.

- Confirm the change is local and behavior-preserving.
- Avoid creating or updating a feature brief.
- Run the narrowest useful check.
- Leave a concise handoff with files changed and checks run.

## Standard Path Checklist

Use for meaningful product or architecture work with bounded risk.

Product fit:

- Supports conversation, connection, understanding, memory, or legacy.
- Serves the MVP loop unless explicitly marked post-MVP.
- Avoids administrative complexity unless it protects privacy, trust, or memory quality.

Implementation shape:

- Builds Rails-first with conventional routes, controllers, models, policies, jobs, and views.
- Keeps UI Hotwire-compatible and avoids SPA-only assumptions.
- Uses Stimulus only for modest interactivity.
- Keeps user-facing flows touch-friendly and mobile-aware.

Verification:

- Defines acceptance criteria before implementation.
- Adds tests for models, policies, requests, jobs, and services as appropriate.
- Manually verifies mobile layout for user-facing flows.
- Documents any verification gaps before considering the feature complete.

## High-Risk Checklist

Use in addition to the Standard Path checklist when work touches AI interpretation, child data protection, privacy, deletion, export, authorization boundaries, provider behavior, billing, or durable architecture.

AI behavior:

- Keeps AI gentle, non-clinical, and non-diagnostic.
- Prevents AI from labeling, scoring, ranking, diagnosing, or replacing parent judgment.
- Requires parent review before AI-assisted content is saved, sent, or shared.
- Keeps AI failures from blocking access to original memories.
- Uses `docs/architecture/ai-architecture.md` for AI implementation details.

Privacy and child data:

- Collects the minimum useful child data.
- Scopes child data to the authorized parent or household model.
- Avoids logging sensitive memory content, recordings, transcripts, prompts, or generated summaries.
- Plans deletion and export implications before shipping data-heavy features.
- Treats voice recordings and transcripts as highly sensitive.

Mobile and native implications:

- Avoids hover-only and desktop-only interactions.
- Keeps screens focused and navigation predictable.
- Notes native wrapper implications before depending on browser APIs.
- Treats voice recording as a sensitive mobile capability that needs explicit design and permission handling.
