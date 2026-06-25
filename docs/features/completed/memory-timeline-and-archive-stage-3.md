Memory Timeline & Archive - Stage 3

Status

Completed.

---

User Problem

A parent who has saved responses needs a calm way to revisit those memories over time, so the daily ritual feels emotionally rewarding instead of like one more form to fill out.

---

Product Intent

Complete the first non-AI version of the memory reward loop:

Parent selects a child, sees saved responses as a private timeline, opens an individual memory, and can return to capturing more memories.

This stage should answer:

Can a parent revisit a growing archive of saved responses and feel that the app is becoming a meaningful private memory record?

---

Existing Foundation

This feature builds on Stage 1 and Stage 2:

* Devise-authenticated parent accounts.
* Parent-owned `ChildProfile` records.
* `DailyQuestion` records for curated prompts.
* `MemoryResponse` records for saved text memories.
* Pundit authorization.
* Rails server-rendered views.
* Hotwire-compatible navigation.
* Tailwind CSS + daisyUI styling.
* Existing RSpec and FactoryBot conventions.

---

In Scope

* A child-specific memory timeline for saved `MemoryResponse` records.
* Chronological browsing grouped by month.
* A private memory detail page for an individual response.
* Navigation from a child profile to the full archive.
* Navigation from archive entries to the individual memory.
* Empty states that encourage capturing the next memory without pressure.
* Authorization so parents cannot view another parent's archive or memory response.
* Request specs for archive/detail access, ordering, and authorization boundaries.
* Mobile-friendly timeline and detail screens.

---

Out Of Scope

* New timeline item or archive entry database models.
* Voice recordings.
* Audio storage, playback, or transcription.
* AI summaries, insights, recommendations, or reflection letters.
* Tags, scores, labels, rankings, moods, graphs, or analytics.
* Advanced search or filtering.
* Custom parent-authored questions.
* Question scheduling, deterministic daily selection, or notifications.
* Sharing memories outside the parent account.
* Public memory URLs.
* Export, retention, or deletion guarantees beyond existing dependent cleanup.

---

Starting Assumptions

* `MemoryResponse` is the archive entry for Stage 3.
* A separate `TimelineItem` model is unnecessary until the product supports multiple memory types such as voice recordings, transcripts, photos, or AI artifacts.
* The child profile remains the natural starting point for archive browsing.
* The archive should make saved memories easier to revisit, not turn them into metrics.
* The original parent-authored response remains the source of truth for future voice, timeline, and AI work.
* `MemoryResponse` remains the canonical saved memory record for text responses. A generalized memory model should wait until multiple memory artifact types exist.

---

Data Model Notes

No new database tables are expected for Stage 3.

Use the existing model shape:

* `ChildProfile has_many :memory_responses`
* `MemoryResponse belongs_to :child_profile`
* `MemoryResponse belongs_to :daily_question`

Recommended query behavior:

* Archive entries should be scoped through the authorized child profile.
* Entries should order by `answered_on` descending, with `created_at` descending as a tiebreaker.
* Detail views should load responses through the authorized child profile rather than by global lookup.
* Stage 3 assumes every `MemoryResponse` has an `answered_on` value because it is required by the existing model.

Do not introduce generalized timeline storage in Stage 3.

---

Implementation Contract

Routes should remain private, authenticated, and child-scoped.

Suggested routes:

* `GET /child_profiles/:child_profile_id/memory_responses`
* `GET /child_profiles/:child_profile_id/memory_responses/:id`

The archive controller should load the child profile through the current parent's authorized scope.

The memory detail action should load the memory response through the authorized child profile:

* Do not find `MemoryResponse` globally by id.
* Do not allow a parent to infer or access another parent's response.
* Do not allow a parent to access one child's response through another child's route.
* Use existing app authorization conventions for inaccessible records.

Archive entries should display:

* Answered date.
* Daily question prompt.
* Short response preview.
* Link to the detail page.

Detail page should display:

* Daily question prompt.
* Full response text.
* Answered date.
* Navigation back to the child profile and archive.
* Link to capture another memory.

---

UI Notes

* The child profile page should keep a recent-response preview and add a clear path to the full archive.
* The child profile page should include a memory archive entry point whether or not responses exist.
* The archive should feel like revisiting memories, not reviewing data.
* The archive should reward attention, not completion.
* The archive should be easy to scan on a phone.
* The memory detail page should show the prompt, response text, and answered date clearly.
* Archive entries should show the prompt, a short response preview, and the exact answered date.
* Copy should stay warm, specific, non-clinical, and non-evaluative.
* Empty states should encourage one small next capture without implying failure or streak loss.
* Empty state copy may use language like: "This archive will grow one conversation at a time. Capture a response today and it will appear here as part of your child's memory record."
* Avoid graphs, counts-as-performance, streaks, rankings, or dashboard-like summaries.

---

AI Behavior Notes

No AI behavior is required for Stage 3.

This stage intentionally creates the non-AI archive foundation that later AI summaries and reflection letters can review with parent control.

---

Privacy & Child Data Notes

* Memory responses are sensitive child data.
* Archives and detail pages must remain private to the authenticated parent who owns the child profile.
* Do not introduce public archive or memory URLs. Private URLs are allowed for authenticated app navigation, but archive and memory URLs must not be publicly accessible, shareable outside authentication, indexed, or exposed without authorization.
* Do not send response text to third-party services.
* Do not add analytics events or logs containing response text.
* Keep collected data unchanged: question, response text, date, and ownership.
* Deletion/export/retention guarantees remain open for a later dedicated brief.

---

User Stories

* As a parent, I can open a child profile and navigate to that child's memory archive.
* As a parent, I can browse saved responses in reverse chronological order.
* As a parent, I can see entries grouped by time so the archive feels easier to revisit.
* As a parent, I can open a single saved memory and read it without distraction.
* As a parent, I can return from the archive or detail page to the child profile or capture flow.
* As a parent, I cannot view another parent's memory archive or memory detail page.

---

Acceptance Criteria

* Child profile show page includes a clear memory archive entry point whether or not responses exist.
* When responses exist, the child profile page previews recent memories and links to the full archive.
* When no responses exist, the child profile page shows a gentle invitation to capture the first memory.
* Archive page lists all responses for the selected child in reverse chronological order.
* Archive page groups responses by month.
* Archive entries show the exact answered date.
* Archive page handles the no-response state with gentle copy and a capture link.
* Memory detail page displays the prompt, response text, and answered date.
* Parent can navigate from archive entry to detail page.
* Parent cannot view another parent's archive or memory detail page.
* No AI behavior is introduced.
* No public archive or memory URLs are introduced.
* No new child data fields are introduced.

---

Verification Plan

Automated:

* Request specs for the child archive page.
* Request specs for the memory detail page.
* Request specs for authorization boundaries on archive and detail pages.
* Request specs confirming archive ordering and key content.
* Request specs confirming the archive includes responses for the selected child only.
* Request specs confirming a parent cannot access a response through the wrong child profile.
* Request specs confirming responses are grouped by month.
* Existing Stage 1 and Stage 2 specs should still pass.

Run:

* `bundle exec rspec`
* `bundle exec rubocop`

Manual:

* Parent login.
* Open a child profile with no responses and confirm the archive empty state.
* Save multiple responses across dates.
* Open the child profile and follow the archive link.
* Confirm archive ordering and grouping.
* Open an individual memory detail page.
* Confirm back/capture navigation remains clear.
* Check archive and detail pages at a mobile viewport width.

---

Implementation Decisions

* Reused `MemoryResponse` as the Stage 3 archive entry.
* Did not add a new timeline, archive, or generalized memory model.
* Added private nested archive and detail routes under child profiles.
* Loaded archive and detail records through the authorized child profile scope.
* Added `MemoryResponsePolicy#show?` and reused it for creation authorization.
* Grouped archive entries by answered month, while still showing exact answered dates on entries and detail pages.
* Added an always-visible memory archive entry point from the child profile page.
* Kept the child profile page as a recent-memory preview rather than a full archive.
* Kept Stage 3 non-AI and did not introduce voice, search, tags, analytics, sharing, editing, or deletion behavior.

---

Verification Results

Automated:

* `bundle exec rspec spec/requests/memory_responses_spec.rb spec/requests/child_profiles_spec.rb` - 26 examples, 0 failures.
* `bundle exec rspec` - 144 examples, 0 failures.
* `bundle exec rubocop` - 126 files inspected, no offenses detected.

Manual:

* Created a local development fixture parent, child profile, and two memory responses.
* Signed in through the browser as the fixture parent.
* Confirmed the child profile page shows a memory archive entry point and recent-memory preview.
* Confirmed the full archive shows June 2026 and May 2026 month groups, exact answered dates, response previews, and detail links.
* Confirmed the detail page shows the prompt, full response text, answered date, archive/profile navigation, and capture-another link.
* Checked archive and detail pages at a 390px mobile viewport with no horizontal overflow.

Known verification gap:

* The browser pass used a local development fixture rather than a persistent seed scenario.

---

Challenge Notes

The tempting larger version of Stage 3 would introduce a timeline abstraction, filters, search, tags, custom prompts, or early AI summaries. Those may become useful later, but they are not needed to prove whether saved responses feel meaningful when revisited.

The smallest useful slice is a private, child-scoped archive and detail view built directly on `MemoryResponse`.

---

Open Questions

* Should individual memory pages eventually support editing or deletion, or should that wait for a broader retention/deletion brief? Stage 3 should not introduce new editing, deletion, retention, or recovery behavior.
* When voice recordings arrive, should `MemoryResponse` evolve into a generalized memory model or remain text-specific?
* How much archive browsing is enough before advanced search becomes valuable? Search/filtering should wait until chronological browsing no longer helps parents rediscover meaningful responses.
