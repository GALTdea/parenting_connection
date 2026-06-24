# Feature Constraints

Apply these constraints to every feature brief and implementation.

## Product Fit

- The feature must support the north star: help parents connect with their children, understand who they are becoming, or preserve meaningful memories.
- The feature should serve the MVP loop unless explicitly marked post-MVP.
- Avoid administrative complexity unless it protects privacy, trust, or memory quality.

## Rails And Hotwire

- Build Rails-first.
- Use conventional routes, controllers, models, policies, jobs, and views.
- Keep UI Hotwire-compatible.
- Use Stimulus for modest interactivity.
- Avoid SPA-only assumptions.

## Mobile And Hotwire Native

- Design touch-friendly flows.
- Avoid hover-only controls.
- Keep screens focused and navigation predictable.
- Do not depend on browser APIs without noting native wrapper implications.
- Treat voice recording as a sensitive mobile capability that needs explicit design and permission handling.

## AI Behavior

- AI must be gentle, non-clinical, and non-diagnostic.
- AI must not label, score, or diagnose children or parents.
- AI-generated summaries and letters must be parent-reviewed.
- AI failures must not block access to original memories.
- Prompts and outputs that include child data require privacy review.

## Privacy And Child Data

- Collect the minimum useful data.
- Scope child data to the authorized parent or household model.
- Avoid logging sensitive memory content, recordings, transcripts, prompts, or generated summaries.
- Plan deletion and export implications before shipping data-heavy features.
- Treat voice recordings as highly sensitive.

## Verification

- Define acceptance criteria before implementation.
- Add tests for models, policies, requests, jobs, and services as appropriate.
- Manually verify mobile layout for user-facing flows.
- Document any verification gaps before considering a feature complete.
