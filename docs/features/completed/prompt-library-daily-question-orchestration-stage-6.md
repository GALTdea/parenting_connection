# Prompt Library & Daily Question Orchestration - Stage 6

Status

Completed.

---

User Problem

The app now supports a coherent daily ritual loop:

Parent opens a child home, sees today's question, captures that same question, and saves a private memory.

The next problem is quality and intention. If the same small question set drives the ritual for too long, the experience can become repetitive, shallow, or arbitrary. Parents need questions that gently invite meaningful conversation without turning the app into a tracker, assessment tool, or AI chatbot.

---

Product Intent

Create the next non-AI foundation for conversation quality before AI summaries.

Stage 6 should make the question system more intentional by introducing:

* A structured prompt library.
* Clear prompt metadata for lightweight curation.
* Stable daily question selection per child.
* Recent-repeat avoidance.
* Safe fallback behavior.

The question is not the product; the relationship is the product. Prompt orchestration should quietly support the parent-child ritual while keeping the interface simple.

This stage supports the product formula:

Conversation -> Connection -> Understanding -> Memory -> Legacy

---

Existing Foundation

This feature builds on:

* Stage 1 parent accounts and child profiles.
* Stage 2 `DailyQuestion` and `MemoryResponse`.
* Stage 3 private memory archive.
* Stage 4 voice recordings attached to memories.
* Stage 5 ritual-first child home and selected-question capture flow.

Current implementation notes:

* `DailyQuestion` currently has `prompt`, `active`, and optional `position`.
* `MemoryResponse` belongs to a `DailyQuestion`.
* The child home currently uses `DailyQuestion.active.ordered.first` as today's question.
* The capture form can receive a `daily_question_id` and preselect that active question.
* Seed data currently creates a small set of active prompts.

---

Risk Tier

Use the Standard Path with High-Risk privacy review.

Stage 6 does not introduce AI behavior, third-party calls, transcripts, summaries, or generated content. It does, however, shape child-facing conversation prompts and may store per-child prompt-selection history, so privacy, child data minimization, and product voice need explicit review.

---

In Scope

* Extend the prompt library data shape for curated question metadata.
* Define a small prompt taxonomy using categories and optional tags.
* Add broad age guidance for prompts.
* Keep active/inactive prompt control.
* Select one stable daily question per child per day.
* Avoid recently selected prompts for that child when possible.
* Provide fallback behavior when the library is too small, empty, or age filters are too narrow.
* Keep prompt management seed-first for MVP.
* Update tests around prompt eligibility, selection stability, repeat avoidance, fallback behavior, and capture continuity.
* Preserve the existing memory response relationship to the selected question.

---

Out Of Scope

* AI-generated questions.
* AI summaries, insights, recommendations, labels, or interpretations.
* Prompt personalization based on response content.
* Interest profiles, child traits, temperament, mood, behavior, or developmental labels.
* Gamification, streaks, badges, dashboards, scores, rankings, or graphs.
* Notifications or scheduled delivery.
* Parent-created custom prompts.
* Parent-facing prompt browsing, filtering, voting, ratings, or favorites.
* A complex admin CMS.
* Sharing prompts or memories outside the parent account.
* Clinical, educational, behavioral, diagnostic, or intervention language.

---

Data Model Notes

Recommended Stage 6 model shape:

* Extend `DailyQuestion`
  * `slug` - stable unique identifier for seed upserts and future prompt text edits.
  * `prompt` - existing text, required, unique.
  * `active` - existing boolean, required.
  * `position` - existing optional integer for seed/admin ordering.
  * `category` - required string or enum-like value.
  * `tags` - optional array/json field constrained to the allowed tag list.
  * `min_age_years` - optional integer.
  * `max_age_years` - optional integer.
  * `age_guidance` - optional short text for maintainers, not required in parent UI.
  * `internal_notes` - optional curator notes, not shown to parents.

* Add `DailyQuestionSelection`
  * `child_profile_id` - required.
  * `daily_question_id` - required.
  * `selected_on` - required date.
  * timestamps.

Relationships:

* `ChildProfile has_many :daily_question_selections`
* `DailyQuestionSelection belongs_to :child_profile`
* `DailyQuestionSelection belongs_to :daily_question`
* `DailyQuestion has_many :daily_question_selections`
* `MemoryResponse` continues to belong to `DailyQuestion`.

Suggested constraints:

* Unique index on `daily_questions.slug`.
* Unique index on `[child_profile_id, selected_on]` so each child has one stable selected question per day.
* Index on `[child_profile_id, daily_question_id, selected_on]` or `[child_profile_id, selected_on]` plus query-specific coverage for recent history.
* Validate `DailyQuestionSelection.selected_on` presence.
* Validate selected questions are active at selection time.
* Validate `DailyQuestion.category` against the allowed category list.
* Validate `DailyQuestion.tags` against the allowed tag list.
* Backfill existing `DailyQuestion` records with a stable slug and safe default category before enforcing required slug and category validations.

Do not make `MemoryResponse` belong to `DailyQuestionSelection` in Stage 6. The response only needs to preserve which question was answered. Selection history is orchestration history, not the canonical memory artifact.

---

Prompt Categories And Tags

Keep the taxonomy small and curator-facing. Categories should help balance the library, not expose a dashboard to parents.

Recommended initial categories:

* `daily_life` - ordinary moments, routines, small details.
* `feelings` - gentle emotional reflection without diagnosis.
* `imagination` - pretend, possibility, creativity.
* `relationships` - friends, family, kindness, belonging.
* `growth` - effort, learning, trying, noticing change.
* `memory` - what the child wants to remember.

Optional tags can be used sparingly for seed/admin organization. Stage 6 should constrain tags to this allowed list:

* `quick`
* `bedtime`
* `after_school`
* `weekend`
* `gratitude`
* `wonder`
* `story`

Tags should not describe the child. Avoid tags such as anxious, sensitive, gifted, difficult, defiant, advanced, delayed, lonely, or shy.

Tradeoff:

* A normalized `PromptCategory` model would support richer admin tools later, but it is unnecessary for the MVP.
* A string or enum-like column keeps Stage 6 small and testable.
* Tags should be optional metadata, not a parent-facing filtering system.
* Constraining tags to a small allowed list prevents accidental child labels from entering prompt metadata.

---

Age Guidance

Stage 6 should support broad age suitability without creating developmental assessment.

Recommended approach:

* Use optional `min_age_years` and `max_age_years`.
* Treat null bounds as open-ended.
* Calculate age from the child profile birthday when present.
* If age cannot be calculated, include prompts with no age limits and use broad all-age prompts first.
* Keep `age_guidance` as maintainer text only.

Examples of age guidance:

* "Works best for children who can describe a day in simple sentences."
* "May need parent rephrasing for younger children."
* "All-age prompt."

Avoid guidance that sounds clinical, educational, diagnostic, or comparative.

Tradeoff:

* Exact age filtering can overfit and make the library brittle.
* Broad optional bounds are enough to avoid obviously mismatched prompts while preserving variety.
* Stage 6 should not infer maturity, reading level, temperament, or development from saved memories.

---

Active And Inactive Prompts

`DailyQuestion.active` remains the primary publishing control.

Behavior:

* Only active prompts are eligible for new daily selections.
* Inactive prompts remain valid for historical `MemoryResponse` records.
* Inactive prompts should still render in existing memory detail and archive views.
* An inactive prompt should not be selected through the daily orchestration path or capture selector.

Tradeoff:

* Hard-deleting prompts would risk damaging memory history.
* Keeping inactive prompts preserves past memories while allowing curators to retire weak prompts.

---

Daily Selection Rules

Stage 6 should introduce a small Rails service or model method responsible for daily question selection. The behavior should be deterministic enough for user trust and simple enough to test.

Recommended rules:

1. Look for an existing `DailyQuestionSelection` for the child and `Date.current`.
2. If one exists and the question still exists, use it for today's question.
3. If none exists, build an eligible prompt set from active questions.
4. Prefer prompts that match the child's broad age range when age is available.
5. Exclude prompts selected for that child in the recent-repeat window when enough alternatives exist.
6. Choose from the remaining prompts using a simple stable ordering or lightweight rotation.
7. Persist the selection for that child and date.
8. Pass the selected question into the existing capture flow.

The child home and capture form should continue to show the same question for the same child on the same day.

Do not enforce category rotation in Stage 6. Categories are curator metadata only.

Do not expose the algorithm to parents in the UI. The product should feel like a quiet daily ritual, not a recommendation engine.

---

Avoiding Recent Repeats

Recommended initial repeat window:

* Avoid the last 14 selected questions for the same child when the library has enough alternatives.

Fallback rule:

* If excluding recent selections leaves no eligible prompts, automatically relax the repeat window rather than showing no question.

Tradeoff:

* Avoiding only answered questions misses prompts that were shown but not captured.
* Storing daily selections avoids visible repeats even when no memory is saved.
* A long repeat window requires a larger library. Fourteen days is a reasonable MVP default that can be shortened automatically when the library is small.

---

Fallback Behavior

The app should remain useful even when curation data is imperfect.

Fallback order:

1. Existing selection for child and date.
2. Active prompts matching age guidance and outside recent selections.
3. Active prompts matching age guidance, allowing recent repeats.
4. Active all-age prompts outside recent selections.
5. Any active prompt.
6. If no active prompts exist, show the existing "No questions are ready yet" state and keep capture disabled.

If a previously selected question becomes inactive later the same day:

* Prefer keeping the existing selection for that day if the prompt still exists, so the parent sees a stable ritual.
* Do not allow inactive prompts to be selected for new dates.

If a selected question is deleted despite the preservation guidance:

* Fall back to a new eligible active prompt.
* Historical memories that referenced the deleted question may break, so prompt deletion should remain discouraged.

---

Admin And Seed Management

Stage 6 should stay seed-first.

Recommended MVP management:

* Expand `db/seeds.rb` or a small seed helper with structured prompt content.
* Use idempotent seed behavior keyed by `slug`, not prompt text.
* Allow seeds to update metadata for existing prompts without duplicating records.
* Keep admin-only prompt editing out of Stage 6 unless implementation discovery shows seed management is too brittle.
* If a minimal admin tool is later added, it should be restricted to application admins and support only prompt text, active state, category, tags, age bounds, position, and internal notes.

Seed content target:

* Include at least 40 active prompts before Stage 6 is release-ready.
* Include at least 10 all-age prompts before Stage 6 is release-ready.
* Include at least 4 prompts per category before Stage 6 is release-ready.
* Keep prompts short, open-ended, non-leading, and easy to ask aloud.

Tradeoff:

* A CMS would make prompt iteration easier, but it adds authorization, UI, validation, audit, and content-governance work.
* Seed-first management keeps Stage 6 Rails-simple and appropriate for an MVP before product-market learning.

---

Future AI Personalization Preparation

Stage 6 prepares for future AI without adding AI.

Useful future foundations:

* Prompt metadata can help AI summaries understand the intent of a memory without interpreting the child.
* Categories can support gentle reflection grouping later.
* Daily selection history can show which prompts led to saved memories without analyzing private response text.
* Age guidance can prevent obviously mismatched future suggestions without building a child profile.
* Active/inactive prompt state allows retiring prompts before AI-assisted reflection uses them as context.

Boundaries for future AI:

* Future AI may suggest prompts only inside a dedicated brief.
* Future AI should not infer child traits from responses to choose questions in Stage 6.
* Future AI should not label children or parents.
* Future AI should use the smallest useful context and keep parent review in control.
* Original memories remain the source of truth.

---

UI Notes

Stage 6 should not create a large new parent-facing prompt interface.

Expected UI behavior:

* Child home continues to lead with today's conversation.
* Today's question comes from the new daily selection behavior.
* "Answer today's question" passes the selected question into capture as Stage 5C does today.
* Capture still lets the parent choose another active question as a secondary option.
* If no active prompt exists, keep the current gentle empty state.

Parent-facing copy should not mention scoring, algorithms, optimization, child profiling, or personalization.

---

AI Behavior Notes

No AI behavior is required for Stage 6.

Prompts remain curated application content, not generated content. Daily selection uses structured metadata and recent selection history only. It should not inspect memory response text, voice recordings, transcripts, or inferred child interests.

Any future AI-generated prompts, AI-assisted prompt recommendations, AI summaries, or personalization based on memory content must wait for a separate feature brief and architecture review.

---

Privacy And Child Data Notes

* Prompt text, prompt metadata, selection history, and memory responses are sensitive in context because they relate to a child's private family archive.
* Do not send prompts, selections, responses, or recordings to third-party services.
* Do not log response text, prompt-selection history, or voice content beyond normal Rails request metadata.
* Store only the minimum selection history needed to keep the daily ritual stable and avoid repeats.
* Prompt categories and tags must describe prompt intent, not the child.
* Do not create child labels, interest profiles, behavior profiles, mood states, or inferred traits.
* Inactive prompts should preserve historical memory readability.
* Deletion/export guarantees remain broader open questions and should not be expanded accidentally in Stage 6.

---

User Stories

* As a parent, I see one stable daily question for a child on a given day.
* As a parent, I can answer the same question I saw on the child home.
* As a parent, I am less likely to see the same question repeatedly in a short period.
* As a parent, I can still save a memory if the question library is small.
* As a maintainer, I can curate prompts by category, active state, and broad age guidance.
* As a maintainer, I can retire a prompt without breaking past memories.

---

Acceptance Criteria

* `DailyQuestion` supports slug, category, optional tags, optional age bounds, optional age guidance, and active state.
* `DailyQuestion.slug` is stable and unique.
* Seeds upsert prompts by slug, not prompt text.
* Tags are optional and constrained to the allowed list.
* Existing prompt history remains readable after prompts are made inactive.
* A child has at most one selected daily question per date.
* Opening a child home repeatedly on the same date shows the same selected question.
* Same-day selections remain stable even if the selected prompt is later marked inactive.
* The selected daily question is passed into the capture flow.
* Active prompt selection avoids recently selected questions for the same child when alternatives exist.
* Selection falls back gracefully when the library is small or age filters eliminate all prompts.
* Inactive prompts are not newly selected.
* Seeds create at least 40 active prompts, including at least 10 all-age prompts and at least 4 prompts per category.
* Seeds remain idempotent.
* No AI behavior is introduced.
* No gamification, dashboards, scores, child labels, or clinical language are introduced.

---

Verification Plan

Automated:

* Model specs for new `DailyQuestion` metadata validations.
* Model specs for unique slugs and allowed tags.
* Model specs for `DailyQuestionSelection` associations, uniqueness, and selected date validation.
* Service/model specs for daily selection stability.
* Service/model specs confirming same-day selections remain stable if the selected prompt is made inactive after selection.
* Service/model specs for active-only eligibility.
* Service/model specs for age-bound eligibility and fallback.
* Service/model specs for recent-repeat avoidance and small-library fallback.
* Request specs for child home showing a stable selected question.
* Request specs for capture preselecting the selected question.
* Request specs confirming inactive questions are not available for new selection.
* Existing memory response specs should still pass.

Run:

* `bundle exec rspec`
* `bundle exec rubocop`

Manual:

* Seed the prompt library.
* Confirm seeds upsert by slug and do not duplicate prompts when rerun.
* Confirm the seeded library has at least 40 active prompts, 10 all-age prompts, and 4 prompts per category.
* Open a child profile and confirm today's question appears.
* Refresh the page and confirm the question stays the same.
* Open capture and confirm the same question is featured.
* Create a memory and confirm it saves under that question.
* Simulate recent selections and confirm a recent prompt is avoided when alternatives exist.
* Mark a prompt inactive and confirm it is not selected for a new day.
* Confirm an old memory with an inactive prompt still renders.
* Confirm the no-active-prompt state remains calm and usable.
* Check mobile-sized child home and capture surfaces.

Documentation-only verification before implementation:

* Confirm this brief exists under `docs/features/active/`.
* Confirm the brief does not require AI summaries, generated prompts, gamification, dashboards, scores, labels, or clinical language.
* Confirm implementation waits for human approval.

---

Challenge Notes

The tempting larger version of Stage 6 would add AI-generated prompts, custom parent prompts, prompt browsing, favorites, streaks, engagement analytics, prompt performance dashboards, and child-specific personalization.

Those features would shift attention away from the relationship and toward managing a system. The smallest useful Stage 6 slice is a curated structured library plus stable daily selection with recent-repeat avoidance.

The main tradeoff is whether to persist daily selections. A stateless deterministic algorithm would avoid a new table, but it cannot reliably prevent visible repeats when a parent sees a prompt and does not save a memory. A small `DailyQuestionSelection` record is justified because it preserves ritual continuity and uses minimal child-scoped data.

---

Implementation Decisions

* Recent-repeat window defaults to 14 days, but the selector relaxes the window automatically when the eligible library is too small.
* Stage 6 does not enforce category rotation. Categories are curator metadata only.
* `DailyQuestion` includes a stable unique `slug`; seeds upsert by slug, not prompt text.
* Tags are optional and constrained to the allowed tag list.
* Same-day selections remain stable even if the selected prompt is later marked inactive.
* Stage 6 is release-ready when seeds provide at least 40 active prompts, including at least 10 all-age prompts and at least 4 prompts per category.

---

Implementation Summary

* Added structured prompt metadata to `DailyQuestion`: slug, category, tags, age guidance, age bounds, and internal notes.
* Added `DailyQuestionSelection` to persist one stable daily question per child per date.
* Added `DailyQuestionSelector` with age guidance, a 14-day recent-repeat window, automatic fallback relaxation, all-age fallback, and no category rotation.
* Updated child home to use the selector for today's question.
* Preserved same-day selected prompts even if a prompt is later made inactive.
* Kept inactive prompts out of new daily selection and normal active prompt browsing.
* Updated seeds to provide a structured prompt library keyed by slug.
* Added model, service, request, and seed verification specs.

---

Verification Results

Automated:

* `bundle exec rspec` - 189 examples, 0 failures.
* `bundle exec rubocop` - 137 files inspected, no offenses detected.

Seed/manual:

* `bin/rails db:migrate` completed.
* `bin/rails db:seed` completed against the development database.
* Running `bin/rails db:seed` a second time kept the daily question count stable at 45, confirming idempotence in the migrated development database.
* Seed specs confirmed at least 40 active prompts, at least 10 all-age prompts, and at least 4 prompts per category.

Known notes:

* The development database retains one older active prompt in addition to the 44 structured Stage 6 seed prompts. This preserves prompt history and still satisfies release-readiness thresholds.
* Browser/mobile manual verification was not run in this pass; the changed UI surface reuses the existing child home and capture form structure.

---

Open Questions

* Should prompt tags use a Postgres array column or JSON column?
* Should the prompt seed content live directly in `db/seeds.rb` or in a separate seed data helper for readability?
