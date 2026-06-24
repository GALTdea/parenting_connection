# Parent Accounts And Child Profiles - Stage 1

## Status

Active brief. Do not implement until this brief is intentionally selected for development.

## User Problem

A parent needs a private account and a way to create child profiles before they can capture memories, answer daily questions, or build a timeline.

## Product Intent

Establish the identity and ownership foundation for the MVP while keeping the first implementation small, conventional, and privacy-conscious.

This stage should answer: "Can a parent securely access the app and define the child or children whose memories they want to preserve?"

## In Scope

- Parent account sign up, sign in, sign out, and account edit using existing Devise foundation where possible.
- A child profile concept owned by the parent account or future household boundary.
- Basic child profile fields needed for memory capture.
- Parent-owned child profile list and detail screens.
- Authorization so parents only access their own child profiles.
- Hotwire-compatible Rails views.
- Mobile-friendly child profile creation and editing.

## Out Of Scope

- Daily questions
- Text memory responses
- Voice recordings
- Timeline
- Memory archive
- AI summaries
- Monthly reflection letter
- Sharing child profiles
- Co-parent invitations
- Public links
- Native mobile wrapper code

## Starting Assumptions

- The existing Rails app already includes Devise user accounts.
- The first parent account can map to the existing `User` model unless implementation discovery shows a stronger reason to introduce a separate parent profile layer.
- Child profiles should not be public.
- Child profile data should be minimal for Stage 1.

## Candidate Child Profile Fields

Final fields should be confirmed before implementation, but Stage 1 likely needs:

- Display name or nickname
- Birth date or age context, if truly needed for prompts later
- Optional notes for parent-only context

Avoid collecting:

- School details
- Medical details
- Behavioral diagnoses
- Full legal identity unless a future requirement justifies it

## User Stories

- As a parent, I can create an account so my family's memories are private to me.
- As a parent, I can create a child profile so memories can be organized around that child.
- As a parent, I can edit a child profile when details change.
- As a parent, I can see only child profiles that belong to me.
- As a parent, I can use the child profile screens comfortably on a phone.

## Data Model Notes

Likely direction:

- `User` represents the authenticated parent account for Stage 1.
- A future child profile model belongs to `User` or to a future household/account container.
- If household sharing is expected soon, pause and document the household boundary before creating migrations.

Do not add a child profile model until the implementation phase begins.

## UI Notes

- Use existing Rails layouts and shared components where appropriate.
- Keep pages quiet, warm, and task-focused.
- Avoid marketing-style hero layouts inside authenticated product flows.
- Forms should preserve input on validation errors.
- Controls should be touch-friendly.

## AI Behavior Notes

No AI behavior is required for Stage 1.

If any AI-assisted copy or suggestions are proposed, they should be deferred to a later AI feature brief.

## Privacy And Child Data Notes

- Child profiles are private by default.
- Child profile fields should be minimal.
- Do not log child profile details beyond normal Rails operational metadata.
- Authorization tests are required before shipping.
- Deletion implications should be considered before implementing dependent memories.

## Acceptance Criteria

- Parent account flow is documented against existing Devise behavior.
- Parent can create, view, edit, and list child profiles.
- Parent cannot access another parent's child profiles.
- Child profile forms validate required fields.
- Child profile screens are usable on mobile-sized viewports.
- No AI behavior is introduced.
- No public child profile URLs are introduced.

## Verification Plan

When implemented, verify with:

- Model specs for child profile validations and ownership.
- Request specs for authorization and CRUD behavior.
- Policy specs if Pundit policy is added.
- System or view-level checks for form error handling if practical.
- Manual mobile viewport check for list, new, edit, and show screens.
- `bundle exec rspec`
- `bundle exec rubocop`

## Open Questions

- Should child profiles belong directly to `User` for MVP, or should a household/account container be introduced before the first migration?
- Is birth date required for meaningful daily prompts, or can Stage 1 use a looser age label?
- What deletion behavior should exist before memories are attached to child profiles?
- Should profile photos be deferred until after the memory capture loop exists?
