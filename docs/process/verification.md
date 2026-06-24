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

Every user-facing feature should pass these checks:

- Does it support the product north star?
- Does it avoid parenting scores, child scores, diagnoses, or clinical claims?
- Does it keep the parent in review/control of AI-generated content?
- Does it make privacy expectations clear?
- Does it avoid unnecessary collection of child data?
- Does it support deletion or future deletion strategy where relevant?

## AI Feature Checks

AI-assisted behavior requires verification beyond normal tests:

- Inputs sent to AI are limited to what the feature requires.
- Prompts instruct the model to be gentle, non-clinical, and non-diagnostic.
- Outputs are labeled as AI-assisted where appropriate.
- Parents can review before saving, sending, or sharing.
- Failure states are graceful and do not block access to original memories.
- Generated summaries preserve uncertainty and avoid overclaiming.

## Data And Privacy Checks

When a change touches child data:

- Confirm authorization boundaries.
- Confirm records are scoped to the owning parent or household model.
- Avoid logging sensitive child content, voice transcripts, prompts, or AI responses.
- Confirm file uploads and voice recordings have a clear storage path.
- Confirm deletion implications are understood before shipping.

## Mobile Checks

Because the app should eventually work in a Hotwire Native wrapper:

- Avoid desktop-only interactions.
- Avoid hover-required controls.
- Keep navigation shallow and predictable.
- Prefer native-friendly forms and buttons.
- Ensure audio recording flows have a clear fallback plan before implementation.

## Completion Standard

A change is complete when:

- Acceptance criteria are satisfied.
- Required tests and checks pass or known gaps are documented.
- Durable docs are updated if the product, architecture, or process changed.
- Any unresolved questions are captured in the relevant feature brief or decision record.
