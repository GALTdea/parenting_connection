Voice Recordings - Stage 4

Status

Draft. Architectural decisions resolved; awaiting implementation approval.

Risk Tier

High-risk path.

This stage touches voice recordings, browser microphone permissions, file uploads, storage, playback, child data protection, deletion implications, and future mobile/native behavior.

---

User Problem

A parent may want to preserve a child's actual voice, pauses, laughter, and phrasing, not only a written summary of what was said.

The existing text capture flow preserves meaning, but it cannot preserve the sound and feeling of the moment.

---

Product Intent

Extend the core capture loop so a parent can save an original voice recording as part of a private memory.

The value of a voice recording is not merely the spoken words. It preserves tone, pacing, laughter, hesitation, pronunciation, emotion, and other qualities that written text cannot capture.

Preserving the original recording is the primary product goal for Stage 4. Transcription and AI can wait because they are derivative; the original voice memory is valuable on its own.

This stage should answer:

Can a parent capture and revisit a short voice memory with low friction, while keeping recording consent, privacy, and storage boundaries clear?

The product should still feel like a quiet memory ritual, not like surveillance, assessment, or data collection.

---

Existing Foundation

This feature builds on Stages 1-3:

* Devise-authenticated parent accounts.
* Parent-owned `ChildProfile` records.
* `DailyQuestion` records for curated prompts.
* `MemoryResponse` records for saved memories.
* Private child-scoped memory archive and detail views.
* Pundit authorization.
* Rails server-rendered views.
* Hotwire-compatible navigation.
* Tailwind CSS + daisyUI styling.
* Stimulus for focused client-side interaction.
* Active Storage configuration already present in Rails environments.
* Existing RSpec and FactoryBot conventions.

---

In Scope

* A parent-initiated browser audio recorder on the existing memory capture form.
* A single original audio recording attached to a `MemoryResponse`.
* Support for text plus audio, or audio with a short parent note, without requiring transcription.
* Server-side validation that accepts either written response text or a voice recording.
* Audio attachment validation for content type and file size.
* Playback on private memory detail pages.
* A clear archive/detail indication when a memory includes audio.
* Authorization so parents cannot create, view, or play another parent's recording.
* Mobile-aware recording controls that do not depend on hover interactions.
* Request, model, and system or feature specs for the core audio flow and authorization boundaries.
* Documentation of privacy, storage, and deletion implications discovered during implementation.

---

Out Of Scope

* Transcription.
* AI summaries, labels, recommendations, or interpretation of audio.
* Sending recordings to an AI provider or third-party transcription service.
* Background audio processing.
* Multiple recordings per memory.
* Standalone voice-note memories not tied to a daily question.
* Editing, replacing, clipping, trimming, or deleting individual recordings after save.
* Offline recording support.
* Native wrapper implementation.
* Notifications, reminders, streaks, analytics, or recording usage metrics.
* Sharing recordings outside the parent account.
* Public recording URLs.
* Export tools or formal retention guarantees beyond existing dependent cleanup.

---

Starting Assumptions

* `MemoryResponse` should remain the canonical memory record for Stage 4.
* A voice recording is an original memory artifact attached to `MemoryResponse`, not a separate timeline model yet.
* The first useful slice can allow one audio attachment per memory.
* The parent is responsible for deciding when recording is appropriate and initiating the recording action.
* The app should not auto-record.
* The saved original audio is the canonical source artifact for future transcript or AI work while the parent chooses to retain it.
* Any future transcript, summary, reflection, or AI-generated artifact should be treated as a derivative of the original recording rather than a replacement for it.
* Transcripts and AI processing should wait for a later dedicated brief.
* Rails Active Storage is the preferred storage mechanism unless implementation reveals a blocking reason.
* Development and test may continue using local Active Storage, but production should use Active Storage with durable S3-compatible object storage before voice recordings ship publicly.
* Stage 4 is optimized for short conversational memories rather than long interviews or continuous recordings.
* Audio-only memories should remain valid because the daily question already provides meaningful context.
* Parent notes should remain optional, but the UI may gently encourage notes because parent observations can enrich the memory.
* Stage 4 should support memory-level deletion only. Individual recording deletion, export, retention, editing, transcript deletion, and derived artifact cleanup should be handled in a later dedicated brief.

---

Data Model Notes

Proposed Stage 4 model shape:

* `MemoryResponse has_one_attached :voice_recording`

Recommended validation behavior:

* `response_text` may be blank only when a `voice_recording` is attached.
* A voice recording should be optional so existing text-only memories remain valid.
* Attached files should be limited to audio content types accepted by current browser recording support.
* Attached files should have a 100 MB maximum size unless implementation testing shows a lower limit is safer.
* The implementation should enforce a maximum recording length of up to 15 minutes.

Recommended accepted content types:

* `audio/webm`
* `audio/mp4`
* `audio/mpeg`
* `audio/wav`
* `audio/x-wav`

Stage 4 should enforce recordings of up to 15 minutes with an initial 100 MB file size limit. If implementation testing shows that 100 MB is too large for reliable browser uploads, the lower tested limit should be documented before implementation is considered complete.

Storage should favor preserving meaningful memories while discouraging unnecessarily large recordings during the MVP. Limits should balance storage cost, upload reliability, and the product intent of preserving short conversational moments.

Do not introduce a generalized `TimelineItem`, `MemoryArtifact`, `Transcript`, or `VoiceRecording` table in this stage unless Active Storage attachment metadata proves insufficient for the acceptance criteria.

The original recording should remain portable enough to support future export and family archive features without requiring reprocessing.

---

Implementation Contract

Routes should remain private, authenticated, and child-scoped.

Use the existing memory response routes:

* `GET /child_profiles/:child_profile_id/memory_responses/new`
* `POST /child_profiles/:child_profile_id/memory_responses`
* `GET /child_profiles/:child_profile_id/memory_responses`
* `GET /child_profiles/:child_profile_id/memory_responses/:id`

The create action should continue to build responses through the authorized child profile:

* Do not find child profiles globally.
* Do not find memory responses globally.
* Serve voice recording playback through an authenticated, child-scoped application route that authorizes the owning `MemoryResponse` before exposing the attachment.
* Do not use default public or broadly reusable Active Storage blob URLs for sensitive child voice recordings.
* Do not expose blob or attachment links unless the parent is authorized to view the owning memory response.
* Avoid logging recording filenames, blob metadata beyond normal Rails internals, or memory content in application logs.

Recording should be parent-initiated through a modest Stimulus controller using the browser `MediaRecorder` API when available.

When browser recording is unavailable, the form may fall back to a direct audio file input.

---

UI Notes

* The capture form should keep the daily question visible.
* Recording controls should be explicit: start, stop, preview, remove before save.
* The UI should clearly show when microphone access is unavailable or denied.
* Copy should stay calm and permission-aware without becoming legalistic or alarming.
* The form should communicate that recording is optional.
* Text plus audio should feel like one memory, not two separate tasks.
* Playback should appear on the memory detail page near the saved response text.
* Playback should require no additional navigation beyond opening the memory itself.
* Playback should remain exclusive to the memory detail page during Stage 4.
* Archive entries should include a small "Includes voice" cue when audio exists.
* Empty states and archive views should not become counts, streaks, or analytics.
* Touch targets should be comfortable on phone widths.

Voice recordings should encourage authentic family conversations rather than performance. The interface should remain simple enough that recording feels like preserving a moment instead of producing content.

The UI may gently communicate that voice memories are intended for meaningful conversation moments rather than continuous recording.

Opening a memory should encourage parents to revisit the entire moment: the daily question, written notes, and recording. Archive playback should wait until there is evidence that playing audio directly from the archive improves memory revisiting without turning recordings into standalone media files.

Suggested copy direction:

* "Record a voice memory"
* "Start recording"
* "Stop recording"
* "Listen before saving"
* "Voice recording saved with this memory"
* "Your browser needs microphone permission before recording."

Avoid copy that implies continuous listening, analysis, scoring, or diagnosis.

---

AI Behavior Notes

No AI behavior is required for Stage 4.

Do not transcribe recordings.

Do not send recordings to an AI provider.

Do not generate summaries, labels, sentiment, topics, developmental observations, or reflection drafts from recordings in this stage.

This stage preserves original audio so future AI or transcription features can be designed with explicit parent review and privacy notes.

---

Privacy & Child Data Notes

* Voice recordings are highly sensitive child data.
* Recordings must remain private to the authenticated parent who owns the child profile.
* The app must not auto-record or record in the background.
* The parent must clearly initiate recording.
* The app should save only recordings the parent submits with the form.
* Do not introduce public recording URLs.
* Do not send audio to third-party services.
* Do not add analytics events containing recording metadata, memory text, transcript-like content, or child identifiers.
* Do not log recording content, generated blob URLs, or transcript-like data.
* Existing dependent cleanup from child profile deletion should remove attached recordings through the owning `MemoryResponse`.
* Stage 4 supports memory-level deletion only.
* Formal individual recording deletion, export, retention, editing, transcript deletion, derived artifact cleanup, and recovery guarantees remain open for a later dedicated brief.
* Durable S3-compatible object storage should be configured before public production use so recordings are stored durably and can support future archive/export work.

---

Mobile And Native Notes

* Browser microphone support varies across iOS Safari, Android Chrome, and desktop browsers.
* Recording controls should degrade gracefully to an audio file input when `MediaRecorder` is unavailable.
* Permission errors should keep the parent in the capture flow and preserve entered text.
* The form should remain usable at common phone widths.
* Native wrapper behavior should be revisited before relying on browser recording as the only long-term implementation path.
* Offline or interrupted recording behavior is out of scope for this stage.

Minimum manual browser verification before release:

* Current iOS Safari.
* Current Android Chrome.
* Desktop Chrome.
* Desktop Safari.

Other browsers should gracefully fall back to file upload if recording APIs are unavailable.

---

Future Transcript Architecture Notes

Future transcription should be designed in a separate feature brief.

Expected direction:

* The original recording remains the canonical artifact while retained.
* Machine transcripts should reference the original recording.
* Parent corrections should be stored separately from machine transcripts.
* AI summaries and reflections may consume transcripts or approved parent edits when explicitly designed, but they must never overwrite or replace the original recording.

---

User Stories

* As a parent, I can open a child's capture form and choose to record a short voice memory.
* As a parent, I can stop and preview the recording before saving.
* As a parent, I can save a memory that includes text and voice.
* As a parent, I can save a memory that includes voice with only a short note or no full written transcript.
* As a parent, I can see which archive entries include voice.
* As a parent, I can open a memory detail page and play back the saved recording.
* As a parent, I cannot view or play another parent's voice recording.
* As a parent, I can still save a text-only memory when I do not want to record.

---

Acceptance Criteria

* Capture form includes optional voice recording controls.
* Recording is started only by parent action.
* Parent can stop and preview audio before saving.
* Parent can remove an unsaved recording before submitting.
* Parent can create a text-only memory as before.
* Parent can create a memory with an attached voice recording.
* Parent can create an audio memory when `response_text` is blank or minimal, if a valid recording is attached.
* Memory creation fails when both `response_text` and `voice_recording` are blank.
* Invalid audio content types are rejected.
* Recordings longer than 15 minutes are rejected or stopped before submission.
* Recordings larger than 100 MB are rejected unless implementation testing documents a lower supported limit.
* If recording upload fails, the parent receives a clear error while preserving any entered text.
* Validation failures never silently discard a successfully recorded clip without informing the parent.
* Archive entries indicate when a memory includes voice.
* Memory detail page plays the saved recording for the authorized parent.
* Archive entries do not play recordings directly in Stage 4.
* Playback is served through an authenticated, child-scoped application route that authorizes the owning `MemoryResponse`.
* Default public or broadly reusable Active Storage blob URLs are not used for playback.
* Parent cannot access another parent's recording through archive, detail, or attachment URLs.
* No transcription or AI behavior is introduced.
* No public recording URLs are introduced.

---

Verification Plan

Automated:

* Model specs for `MemoryResponse` attachment association and text-or-audio validation.
* Model specs for audio content type and file size validation.
* Request specs for audio memory creation.
* Request specs for validation errors preserving form behavior.
* Request specs for authorization boundaries on archive/detail access.
* Request or system specs confirming text-only memory creation still works.
* System or feature spec for recording control rendering and fallback file input, if practical in the test environment.
* Existing Stage 1-3 specs should still pass.

Run:

* `bundle exec rspec`
* `bundle exec rubocop`

Manual:

* Parent login.
* Open a child profile.
* Open the capture form.
* Save a text-only memory.
* Record, stop, preview, and save an audio memory.
* Try recording permission denial and confirm the form remains usable.
* Try a failed or invalid upload and confirm entered text is preserved with a clear error.
* Upload a fallback audio file if browser recording is unavailable.
* Confirm archive voice cue appears.
* Confirm archive entries do not expose direct playback controls.
* Confirm detail-page playback works.
* Confirm another parent cannot access the memory detail page.
* Check capture, archive, and detail pages at a mobile viewport width.
* Check current iOS Safari, current Android Chrome, desktop Chrome, and desktop Safari before release.

---

Challenge Notes

The tempting larger version of Stage 4 would add transcription, AI summaries, multiple clips, standalone voice notes, native recording, audio editing, exports, and deletion controls.

Those are real product needs, but they create much larger privacy, storage, provider, and UX questions.

The smallest useful Stage 4 slice is original-audio capture and playback attached to the existing private memory record, with no transcript and no AI processing.

---

Implementation Decisions

Resolved:

* Use Active Storage for original audio attachments.
* Attach one `voice_recording` to `MemoryResponse`.
* Keep `MemoryResponse` as the private archive entry for text and voice memories.
* Use Stimulus and `MediaRecorder` for parent-initiated browser recording.
* Provide a file input fallback for browsers without recording support.
* Keep direct audio playback on the individual memory detail page for Stage 4.
* Allow audio-only memories; encourage but do not require parent notes.
* Enforce a maximum recording length of up to 15 minutes.
* Enforce an initial 100 MB file size limit unless implementation testing shows a lower limit is safer.
* Keep development and test on local Active Storage.
* Require Active Storage with durable S3-compatible object storage before public production use.
* Serve playback through an authenticated, child-scoped application route.
* Support memory-level deletion only in Stage 4.
* Keep transcription and AI out of scope.

---

Verification Results

Pending implementation.

---

Open Questions

* Which object storage provider and production storage settings should be used before public release?
* Should the initial 100 MB limit be lowered after implementation testing on target browsers and network conditions?
* How should individual recording deletion be added in a later retention/editing/export stage, and how should it interact with text notes and future derived artifacts?
* How should future transcripts, parent corrections, and AI summaries be exposed in the UI without replacing the original recording?
