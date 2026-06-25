Parent Accounts & Child Profiles — Stage 1

Status

Completed.

⸻

User Problem

A parent needs a private account and a way to create child profiles before they can capture memories, answer daily questions, or build a timeline.

⸻

Product Intent

Establish the identity and ownership foundation for the MVP while keeping the first implementation small, conventional, and privacy-conscious.

This stage should answer:

Can a parent securely access the app and define the child or children whose memories they want to preserve?

⸻

Existing Foundation

This feature builds on the existing Rails starter application.

Implementation should extend existing capabilities whenever practical, including:

* Devise authentication
* Pundit authorization
* Hotwire
* Tailwind CSS + daisyUI
* Existing User model
* Dashboard layout
* Shared UI components
* Existing testing conventions

Unless there is a compelling product reason, extend the existing foundation rather than replacing it.

⸻

In Scope

* Parent account sign up, sign in, sign out, and account editing using the existing Devise foundation.
* A ChildProfile concept owned by the authenticated parent account.
* Basic child profile fields needed for future memory capture.
* Parent-owned child profile list and detail screens.
* Authorization so parents only access their own child profiles.
* Hotwire-compatible Rails views.
* Mobile-friendly child profile creation and editing.

⸻

Out Of Scope

* Daily questions
* Text memory responses
* Voice recordings
* Timeline
* Memory archive
* AI summaries
* Monthly reflection letters
* Sharing child profiles
* Co-parent invitations
* Public links
* Billing
* Native mobile wrapper code

⸻

Starting Assumptions

* The existing Rails application already includes Devise authentication.
* The existing User model represents the authenticated parent account for the MVP.
* Child profiles are private.
* Child profile data should remain intentionally minimal.
* Future household or multi-parent concepts should not influence Stage 1 unless implementation reveals a compelling need.

⸻

Candidate Child Profile Fields

Stage 1 should remain intentionally small.

Required:

* First name or nickname
* Birthday

Avoid collecting information that does not provide immediate product value, including:

* School information
* Medical information
* Behavioral diagnoses
* Personality traits
* Parent notes
* Full legal identity unless future requirements justify it

The child’s story should emerge naturally through conversations rather than profile setup.

⸻

User Stories

* As a parent, I can create an account so my family’s memories remain private.
* As a parent, I can create a child profile so memories can be organized around that child.
* As a parent, I can edit a child profile when details change.
* As a parent, I can view only child profiles that belong to me.
* As a parent, I can comfortably use the child profile screens on a mobile device.

⸻

Data Model Notes

Current direction:

* User represents the authenticated parent account.
* ChildProfile belongs to User.
* Existing multi-tenant models (Space, Role, etc.) should remain untouched unless they become an obstacle during implementation.
* If implementation reveals a need for a future Household abstraction, document the decision before introducing it.

Do not create the ChildProfile model until implementation begins.

⸻

UI Notes

* Reuse existing dashboard layouts and shared components whenever practical.
* Keep authenticated pages quiet, warm, and task-focused.
* Avoid marketing-style layouts inside authenticated flows.
* Forms should preserve input on validation errors.
* Controls should be touch-friendly.
* Creating a child profile should take less than one minute.

⸻

AI Behavior Notes

No AI behavior is required for Stage 1.

If AI-assisted copy, summaries, recommendations, or personalization are proposed, defer them to a future AI feature brief.

⸻

Privacy & Child Data Notes

* Child profiles are private by default.
* Collect only the minimum information required for Stage 1.
* Do not expose public child profile URLs.
* Do not log child profile information beyond normal Rails operational metadata.
* Authorization tests are required before shipping.
* Consider future deletion implications before memories become associated with child profiles.

⸻

Success Criteria

The stage is successful when a new parent can:

* Create an account.
* Create one or more child profiles.
* Return later and see those profiles.
* Feel ready to begin capturing their first memory.

⸻

Acceptance Criteria

* Parent account flow works using the existing Devise implementation.
* Parent can create, view, edit, and list child profiles.
* Parent cannot access another parent’s child profiles.
* Child profile forms validate required fields.
* Validation errors preserve entered data.
* Child profile screens are usable on mobile-sized viewports.
* No AI behavior is introduced.
* No public child profile URLs are introduced.

⸻

Verification Plan

When implemented, verify with:

Automated

* Model specs for child profile validations and ownership.
* Request specs for authorization and CRUD behavior.
* Policy specs if Pundit policies are introduced.

Run:

* bundle exec rspec
* bundle exec rubocop

Manual

Verify:

* Parent sign up
* Parent login/logout
* Child profile creation
* Child profile editing
* Authorization boundaries
* Mobile layouts
* Validation messaging

⸻

Implementation Decisions

* The existing User model was retained as the authenticated parent account.
* ChildProfile belongs directly to User for Stage 1.
* The existing Space model remains untouched and unused for child profiles.
* Numeric child profile IDs are sufficient for this private authenticated resource; FriendlyId was not adopted.
* No Household abstraction was introduced.

⸻

Open Questions

* Should the existing Space model remain unused during the MVP, or does implementation reveal a better role for it?
* Should profile photos be deferred until after the memory capture loop exists?
* What deletion behavior should exist once memories are associated with child profiles?
* Should ChildProfile use FriendlyId, or are numeric IDs sufficient for private resources?
* Does implementation reveal a genuine need for a future Household abstraction, or is User → ChildProfile sufficient for the MVP?
