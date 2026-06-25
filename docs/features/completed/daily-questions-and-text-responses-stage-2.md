Daily Questions & Text Responses - Stage 2

Status

Completed.

---

User Problem

A parent who has created a child profile needs a simple way to start a meaningful conversation and preserve the child's response as a private memory.

---

Product Intent

Complete the first non-AI version of the core ritual:

Parent selects a child, chooses a gentle question, writes down the child's response, and can revisit that saved response later.

This stage should answer:

Can a parent capture a meaningful text memory in less than a minute without the product feeling like a tracker, assessment, or dashboard?

---

Existing Foundation

This feature builds on Stage 1 and should extend:

* Devise-authenticated parent accounts.
* Parent-owned `ChildProfile` records.
* Pundit authorization.
* Rails server-rendered views.
* Hotwire-compatible navigation.
* Tailwind CSS + daisyUI styling.
* Existing RSpec and FactoryBot conventions.

---

In Scope

* A small daily question library stored in the app database.
* Parent-owned access to questions through a child profile capture flow.
* Text memory responses associated with a child profile and a question.
* Basic response fields needed to preserve the original memory.
* A child profile detail view that shows a capture entry point and recent responses.
* A mobile-friendly text response form.
* Authorization so parents cannot view or create responses for another parent's child profile.
* Model and request specs for validations, ownership, and core flow behavior.

---

Out Of Scope

* Voice recordings.
* Audio storage or transcription.
* AI summaries, labels, recommendations, or interpretations.
* Timeline grouping beyond a simple recent-response list.
* Daily notification scheduling.
* Question personalization.
* Question generation by AI.
* Child scoring, tags, rankings, mood tracking, or behavior tracking.
* Sharing responses outside the parent account.
* Public response URLs.
* Export, deletion guarantees beyond normal dependent cleanup, or retention policy changes.

---

Starting Assumptions

* `User` remains the parent account for the MVP.
* `ChildProfile` remains directly owned by `User`.
* The first question library can be global and curated, not user-specific.
* A text response is private child data and should remain scoped through the child profile owner.
* The original parent-authored text response is the source of truth for future timeline and AI features.

---

Data Model Notes

Proposed Stage 2 models:

* `DailyQuestion`
  * `prompt`
  * `active`
  * optional `position`
* `MemoryResponse`
  * `child_profile_id`
  * `daily_question_id`
  * `response_text`
  * `answered_on`

Relationships:

* `ChildProfile has_many :memory_responses`
* `MemoryResponse belongs_to :child_profile`
* `MemoryResponse belongs_to :daily_question`
* `DailyQuestion has_many :memory_responses`

Do not introduce a household, timeline item, prompt-personalization, or AI-generated question model in Stage 2.

---

UI Notes

* The capture flow should begin from a child profile.
* The form should feel like writing down a memory, not filling in a report.
* The question should be visible above the text field.
* Parent copy should be calm and non-evaluative.
* Text fields should be usable on mobile-sized screens.
* Recent responses should be easy to scan but should not become an analytics dashboard.

---

AI Behavior Notes

No AI behavior is required for Stage 2.

Question prompts are curated seed content, not AI-generated content. Any AI-generated summaries, insights, or recommendations must be deferred to a future AI feature brief and architecture review.

---

Privacy & Child Data Notes

* Text memory responses are sensitive child data.
* Responses must be private to the authenticated parent who owns the child profile.
* Do not introduce public response URLs.
* Do not send response text to third-party services.
* Do not log response text beyond normal Rails request metadata.
* Keep collected data minimal: question, response text, date, and ownership.
* Dependent cleanup from child profile deletion is acceptable for Stage 2, but fuller deletion/export guarantees remain open for a later brief.

---

User Stories

* As a parent, I can start from a child profile and open a daily question capture form.
* As a parent, I can choose from active daily questions.
* As a parent, I can save a text response for that child.
* As a parent, I can see recent responses for that child.
* As a parent, I cannot view or create responses for a child profile I do not own.

---

Acceptance Criteria

* Active daily questions can be seeded and shown in the capture form.
* Parent can create a text response for their own child profile.
* Parent cannot create or view responses for another parent's child profile.
* Response text and answered date are required.
* Validation errors preserve entered response text.
* Child profile show page displays recent responses.
* Child profile deletion removes associated memory responses.
* No AI behavior is introduced.
* No public response URLs are introduced.

---

Verification Plan

Automated:

* Model specs for `DailyQuestion` validations and active scope.
* Model specs for `MemoryResponse` validations and associations.
* Request specs for response creation, validation errors, and authorization boundaries.
* Existing child profile specs should still pass.

Run:

* `bundle exec rspec`
* `bundle exec rubocop`

Manual:

* Parent login.
* Create or open a child profile.
* Open the response capture form.
* Save a response.
* Trigger validation errors and confirm input is preserved.
* Confirm recent responses display on the child profile page.
* Check mobile-sized layout for capture and child profile pages.

---

Implementation Decisions

* Added `DailyQuestion` as a curated, global question library with active and position fields.
* Added `MemoryResponse` as the first saved memory record for text responses.
* Kept response creation nested under private child profile routes.
* Did not add standalone response show pages or public URLs.
* Displayed the five most recent responses on the child profile show page.
* Seeded a small starter set of active daily questions.
* Kept Stage 2 non-AI; prompts are curated seed data, not generated content.

---

Verification Results

Automated:

* `bundle exec rspec` - 136 examples, 0 failures.
* `bundle exec rubocop` - 126 files inspected, no offenses detected.

Manual:

* Ran `bin/rails db:migrate`.
* Ran `bin/rails db:seed`.
* Signed in as the seeded regular user.
* Opened a child profile.
* Opened the nested daily-question response form.
* Confirmed active seeded questions appeared in the question selector.
* Saved a text response dated June 25, 2026.
* Confirmed redirect back to the child profile and recent response display.
* Confirmed unauthenticated requests to the child profile and response form redirect to sign-in.

Known verification gap:

* The in-app browser completed the desktop flow but repeatedly timed out when applying a mobile viewport override. The views use existing mobile-friendly dashboard patterns and responsive classes, but a successful mobile viewport screenshot/pass should be repeated before a release build.

---

Challenge Notes

The initial Stage 2 scope could easily expand into scheduling, notifications, timelines, prompt personalization, voice, and AI interpretation. Those are real MVP concepts, but they are not needed to prove the first text capture loop.

The smallest useful slice is a curated question library plus private text responses tied to a child profile.

---

Open Questions

* Should daily question selection eventually be deterministic by date, randomized, or parent-selected?
* Should parents be able to create their own custom questions?
* What deletion and export guarantees should exist once responses, recordings, transcripts, and summaries accumulate?
* Should memory responses eventually become a generalized memory model that can contain text, voice, photos, and AI-derived artifacts?
