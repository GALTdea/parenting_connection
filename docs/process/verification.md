# Verification

Verification should match the risk of the change. Privacy, child data, AI output, account access, and memory preservation deserve extra care.

## Default Checks

For code changes, run the narrowest useful checks first, then broaden when behavior is shared:

```sh
bundle exec rspec
bundle exec rubocop
```

For UI changes, also verify:

- Turbo navigation works.
- Forms handle validation errors without losing user input.
- Mobile viewport layout is usable.
- Keyboard navigation and focus states are reasonable.
- Text does not imply clinical or diagnostic authority.

For documentation-only changes, verify:

- The requested files exist.
- Links and file paths are plausible.
- The docs agree with each other on scope and constraints.
- No feature implementation was accidentally introduced.

## Product Safety Checks

For user-facing product work, apply the Standard Path checklist in `docs/features/_constraints.md`.

## AI Feature Checks

For AI-assisted behavior, apply the High-Risk checklist in `docs/features/_constraints.md` and the implementation guidance in `docs/architecture/ai-architecture.md`.

## Data And Privacy Checks

When a change touches child data, privacy, deletion, export, authorization, uploads, recordings, transcripts, prompts, or generated summaries, apply the High-Risk checklist in `docs/features/_constraints.md`.

## Mobile Checks

For user-facing mobile flows or future Hotwire Native implications, apply the mobile and native checks in `docs/features/_constraints.md` and the guidance in `docs/architecture/mobile-strategy.md`.

## Completion Standard

A change is complete when:

- Acceptance criteria are satisfied.
- Required tests and checks pass or known gaps are documented.
- Durable docs are updated if the product, architecture, or process changed.
- Any unresolved questions are captured in the relevant feature brief or decision record.
