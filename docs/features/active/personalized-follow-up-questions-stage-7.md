# Personalized Follow-Up Questions - Stage 7

Status

Stage 7A and 7B implemented. Do not implement Stage 7C, 7D, or 7E until reviewed and approved.

---

User Problem

The app now supports a coherent daily ritual loop:

Parent opens a child home -> sees today's selected question -> captures that same question -> saves a private memory.

Stage 6 made the question system more intentional with a structured prompt library and stable daily question selection. The next question is whether the app can occasionally make the parent feel, "This remembers what my child shared," without turning the product into surveillance, analysis, therapy, or a child profile engine.

Parents do not need the app to summarize the child yet. They need help continuing meaningful conversations.

---

Product Intent

Create the next foundation for conversation intelligence before AI summaries.

Stage 7 should occasionally surface a thoughtful follow-up question based on a child's prior memories, interests, unfinished stories, or recurring themes. The purpose is to support the parent-child conversation, not to evaluate the child.

This stage supports the product formula:

Conversation -> Connection -> Understanding -> Memory -> Legacy

The question is not the product; the relationship is the product. Personalized follow-ups should feel like gentle memory, not surveillance, diagnosis, optimization, or a generic AI chat feature.

Why this comes before parent-reviewed AI summaries:

* Follow-up questions keep the app inside the existing ritual loop instead of creating a new reflection product.
* They test whether memory-aware assistance feels helpful while the parent remains fully in control.
* They require less durable interpretation than summaries because the output is a question, not a claim about the child.
* They can establish context-building, safety rules, persistence, and review patterns that later summaries can reuse.

---

Existing Foundation

This feature builds on:

* Parent accounts.
* Child profiles.
* Daily questions.
* Structured prompt library.
* Daily question selection history.
* Text memories.
* Voice memories.
* Memory archive and timeline.
* Ritual-first child home.
* Today's question carried into capture.
* Parent-controlled memory saving.

Relevant current implementation notes:

* `DailyQuestion` is the curated prompt library.
* `DailyQuestion` includes slug, category, tags, optional age guidance, and active state.
* `DailyQuestionSelection` persists one selected curated question per child per date.
* `MemoryResponse` belongs to a child profile and a daily question.
* Voice recordings can be attached to memories, but there is no durable transcript foundation documented for Stage 7.

---

Risk Tier

Use the High-Risk Path.

Stage 7 touches child memory content, future AI behavior, personalization, and possible data sent to an AI provider. Even if the first implementation slice avoids AI generation, the feature brief must apply the AI behavior and child-data privacy constraints in `docs/features/_constraints.md` and `docs/architecture/ai-architecture.md`.

Parent review, data minimization, and non-clinical product language are release constraints, not polish.

---

In Scope

* Define a small personalized follow-up MVP.
* Occasionally select or create a follow-up question inspired by prior saved memories.
* Keep normal curated daily prompts as the default path.
* Preserve Stage 6 daily selection stability.
* Keep follow-ups parent-facing and parent-controlled.
* Provide a short parent-facing explanation for why a follow-up was suggested.
* Allow the parent to skip, dismiss, or choose another question.
* Use only authorized memories for the current child.
* Prefer parent-entered text responses in the first slice.
* Use voice memories only when parent-reviewed transcripts exist in a later feature.
* Define context limits, safety rules, persistence, fallback behavior, and verification.

---

Out Of Scope

* AI summaries.
* Monthly reflection letters.
* Personality profiles.
* Temperament labels.
* Clinical interpretation.
* Emotional scoring.
* Dashboards.
* Streaks.
* Gamification.
* Child-facing AI chat.
* Automatic advice to parents.
* Educational recommendations.
* Diagnosis or developmental assessment.
* Fully autonomous prompt generation without parent control.
* Broad child interest profiles.
* Inferred traits, moods, abilities, risks, or needs.
* Parent notification systems.
* Prompt-performance analytics.
* Public sharing or multi-household sharing.

---

Recommended MVP

The smallest useful Stage 7 is an occasional parent-reviewed follow-up suggestion inside the existing daily question ritual.

Recommended first implementation slice:

* Keep curated library prompts as the default.
* Make personalized follow-ups eligible only after a child has enough saved text memories.
* Limit follow-ups to a low frequency, such as at most once every 7 days per child and no more than 20 percent of daily selections.
* Use parent-entered text responses only.
* Exclude voice content unless a transcript already exists and the parent has explicitly allowed transcript use.
* Avoid persistent child profiles, interest graphs, scoring, or theme ledgers.
* Prefer AI-assisted adaptation from curated follow-up templates rather than freeform generation.
* Store only the presented question, source type, source memory reference, explanation, and parent action needed for trust, repeat avoidance, and auditability.

Challenge note:

The tempting larger version would analyze the entire memory archive, infer interests, rank themes, maintain a child model, and generate a new prompt every day. That would move the product away from a quiet relationship ritual and toward an analysis system. Stage 7 should instead prove whether a rare, clearly reviewable memory-aware question feels warm and useful.

---

User Experience

Where follow-up questions appear:

* The child home remains the primary surface.
* Today's question area may show either a normal curated question or an occasional follow-up question.
* Capture continues to carry the displayed question into the memory form.
* The parent can choose another question before capture or from the capture form.

How follow-ups differ from normal library prompts:

* Normal prompts are general curated questions from `DailyQuestion`.
* Personalized follow-ups reference a prior memory, unfinished story, or recurring interest in a light and specific way.
* Follow-ups should still read like natural questions a parent might ask aloud.

Parent-facing explanation:

* The parent may see a small, non-technical reason such as "Inspired by a memory from May" or "Following up on something Leo shared before."
* The explanation should be visible to the parent, not framed as a child-facing label.
* Do not show algorithmic language, scoring, confidence, detected themes, or analysis claims.

Parent controls:

* Answer this question.
* Choose another question.
* Skip this follow-up.
* Dismiss this kind of suggestion for now.
* Future setting: turn personalized follow-ups off for a child or account.

Avoiding a watched feeling:

* Do not use wording like "I noticed you always..." or "The app saw that..."
* Do not tell the child the app analyzed their memories.
* Do not over-reference private or emotionally intense details.
* Use "you once talked about..." only for concrete, parent-saved content that is safe to revisit.
* Keep the parent as the person asking the question. The AI should not become a child-facing speaker.

Warm natural examples:

* "You once talked about building a treehouse. What would be the most important room inside it?"
* "How did the school play end up feeling once it was over?"
* "If you could spend one day helping an animal, which animal would you choose?"

---

Personalization Scope

Stage 7 should personalize from the smallest useful signals:

Allowed MVP signals:

* Recent parent-entered text memories for the current child.
* The prior daily question that led to a memory.
* Prompt category and tags from the source question.
* Simple concrete references in the memory text, when safe.
* Repeated broad interests only when they can be expressed without labeling the child.

Deferred signals:

* Voice recordings without transcripts.
* Voice transcripts that have not been parent-reviewed.
* Full-archive analysis.
* Long-term child interest profiles.
* Sentiment analysis.
* Behavior, personality, temperament, or developmental inference.

Minimum memory threshold:

* No follow-up should be eligible for a new child with no saved memories.
* The first slice should require at least 3 saved text memories for the child.
* A memory-specific follow-up should prefer a source memory from the last 90 days.
* Recurring-interest follow-ups should require at least 2 or 3 recent memories with clearly similar concrete topics, not inferred traits.

Sensitive-context exclusion:

* Do not use memories containing health, medical, safety, discipline, family conflict, trauma, bullying, legal, religious, sexuality, or other highly sensitive content unless a later brief designs explicit parent controls.
* Do not use memories that appear to involve private disclosures by third parties.
* Do not create follow-ups that pressure the child to revisit fear, sadness, conflict, or embarrassment.

---

AI Involvement

Recommended safest MVP approach:

Use AI only to lightly adapt curated follow-up templates, not to freely generate a broad prompt from the whole archive.

Preferred progression:

1. Non-AI eligibility and fallback first.
2. Template-based follow-ups for a small set of safe source categories.
3. AI-assisted adaptation only after the parent-control, persistence, and sensitive-context exclusion path is in place.

Acceptable AI role for Stage 7:

* Receive a small context packet for one child.
* Select the safest applicable follow-up pattern.
* Draft one or two candidate questions in the app's warm, non-clinical voice.
* Produce a short parent-facing explanation.
* Return no diagnosis, labels, scores, advice, or analysis.

Avoid for Stage 7:

* Fully autonomous daily generation.
* Full memory archive analysis.
* Persistent inferred child profiles.
* Model-generated summaries.
* Model-generated advice.
* Child-facing chat.

If implementation discovery shows AI adaptation is too risky or costly for the first slice, Stage 7A should ship with curated non-AI follow-up patterns only and defer AI adaptation.

---

Context Builder

The context builder should send the smallest useful context for a single suggestion.

Allowed context:

* Child profile basics needed for age-appropriate selection, such as first name or nickname and broad age.
* Current date.
* The last 3 to 5 eligible parent-entered text memories for the same child.
* Source memory dates.
* The prompts answered for those memories.
* Daily question categories and safe tags.
* Recent daily question selections to avoid repeats.
* Previously presented personalized follow-ups for repeat avoidance.

Excluded context:

* Other children's memories.
* Other parents' data.
* Raw voice recordings.
* Unreviewed transcripts.
* Account billing or authentication data.
* Internal IDs unless needed by the app after generation.
* Sensitive memories filtered out by eligibility.
* Any hidden chain-of-thought or intermediate reasoning.

Lookback and volume limits:

* Prefer the last 90 days of memories.
* Include at most 5 memory excerpts.
* Keep excerpts short enough to identify the conversation thread without sending the full archive.
* Prefer memories that were saved by the parent and are not empty.
* Fall back to curated prompts when the eligible context is sparse.

Privacy and token-cost considerations:

* Build context server-side for one child at a time.
* Do not log memory text, transcripts, generated candidates, or provider payloads in normal application logs.
* Store only the final presented question and minimal source metadata.
* Do not store provider intermediate reasoning.
* Keep the feature useful when AI is unavailable by falling back to Stage 6 curated selection.

---

Safety And Tone Rules

Follow-up questions must be:

* Warm.
* Curious.
* Age-appropriate.
* Open-ended.
* Short enough to ask aloud.
* Specific enough to feel remembered.
* Gentle enough that skipping feels normal.
* Framed as an invitation, not a test.

Follow-up questions must not:

* Diagnose.
* Label the child.
* Score or rank anything.
* State emotional interpretation as fact.
* Infer sensitive traits or needs.
* Pressure the child to disclose.
* Revisit painful content without parent choice.
* Use therapy, assessment, or intervention language.
* Say "I noticed you always..." or similar surveillance language.
* Say "because you are..." or "this means..."
* Recommend what the parent should do.
* Claim certainty about patterns.

Preferred wording:

* "You once talked about..."
* "Last time, you mentioned..."
* "What happened next with..."
* "If you could imagine..."
* "What would you want to remember about..."

Avoid wording:

* "You seem..."
* "You are always..."
* "You are the kind of kid who..."
* "Your anxiety..."
* "Your behavior shows..."
* "Based on your pattern..."
* "The app noticed..."

---

Data Model Notes

Keep the model small and avoid polluting the curated prompt library.

Recommended direction:

* Keep `DailyQuestion` as the curated library of reusable prompts.
* Keep `DailyQuestionSelection` as the daily orchestration record.
* Add only the minimal fields needed for personalized selection if implementation chooses to extend `DailyQuestionSelection`.

Possible `DailyQuestionSelection` additions:

* `source_type` - curated, personalized_follow_up, or adapted_curated.
* `presented_prompt` - the exact question shown to the parent when it differs from the curated `DailyQuestion.prompt`.
* `source_memory_response_id` - optional reference to the memory that inspired the follow-up.
* `source_daily_question_id` - optional reference to the curated prompt or template that shaped the follow-up.
* `parent_explanation` - short explanation shown to the parent.
* `personalization_status` - presented, skipped, dismissed, answered, or failed.

Alternative:

* Add a small `FollowUpQuestionSuggestion` model and keep `DailyQuestionSelection` only for final daily selection.
* This may be cleaner if the app needs multiple candidates, draft review, or discard history, but it is likely too much for the first MVP slice.

Storage guidance:

* Store the generated or adapted question only after it is selected for presentation.
* Do not store discarded AI candidates unless needed for abuse prevention or repeat avoidance.
* Do not store AI intermediate reasoning.
* Store source references for auditability and repeat avoidance, but do not expose source IDs in UI.
* If the parent answers a follow-up, preserve the exact presented question with the saved memory.

Relationship to Stage 6:

* Stage 6 guarantees one stable selection per child per date.
* Stage 7 should preserve that stability.
* If a personalized follow-up is selected for today, refreshes should show the same question for that child and date.
* Capture should receive the same presented prompt the parent saw on the child home.

Open data-model question:

The current `MemoryResponse` belongs to `DailyQuestion`, which assumes every answered memory has a curated prompt. Stage 7 implementation must decide whether personalized follow-ups are represented by an optional `presented_prompt` snapshot, a generated `DailyQuestion` record with a non-library source type, or a new prompt reference model. The preferred brief direction is a prompt snapshot on the selection/memory path, not new generated rows in the curated library.

---

Selection Rules

Default selection order:

1. Existing selection for child and date.
2. Curated Stage 6 prompt when personalized follow-up is not eligible.
3. Personalized follow-up only when all eligibility, safety, frequency, and fallback checks pass.
4. Curated Stage 6 prompt if personalized generation, adaptation, or validation fails.

When to use a normal curated prompt:

* New child with no memories.
* Fewer than 3 saved text memories.
* No eligible safe source memories.
* Personalized frequency limit has been reached.
* AI or template adaptation fails.
* Parent has disabled or dismissed personalized follow-ups.
* The current day already has a stable curated selection.

When to use a category-based prompt:

* The app has safe prompt metadata but no suitable memory-specific source.
* The selector wants variety without referencing child content.
* A child has age guidance but not enough memory history.

When to use an adapted curated prompt:

* A safe source memory maps clearly to a curated category or template.
* The follow-up can be expressed without sensitive inference.
* The adapted prompt passes tone and safety validation.

When to use a personalized follow-up prompt:

* The child has enough saved text memory history.
* A safe concrete source memory or recurring broad interest is available.
* The child has not recently received a personalized follow-up.
* The output reads naturally and does not analyze the child.
* The parent can skip or choose another question before saving a memory.

Frequency limits:

* Start with at most one personalized follow-up per child every 7 days.
* Cap personalized follow-ups at no more than 20 percent of selections.
* Avoid using the same source memory more than once.
* Avoid showing another personalized follow-up immediately after one was skipped or dismissed.

Repeat avoidance:

* Do not repeat the same presented follow-up question.
* Do not reuse the same source memory within the lookback window.
* Do not adapt the same curated template repeatedly for the same child.
* Relax personalization before relaxing Stage 6 curated fallback.

Fallback behavior:

* If any eligibility, generation, validation, storage, or provider step fails, show a normal curated prompt.
* Do not expose AI failure details to the parent inside the ritual flow.
* Never block memory capture because personalization is unavailable.

---

Parent Control

Parent control is central to Stage 7.

Required controls:

* Parent sees the question before capture.
* Parent can choose another question.
* Parent can skip the personalized follow-up.
* Parent can ignore the prompt and leave without consequence.
* No generated or adapted question is auto-saved as a child memory.
* No AI output becomes part of the memory record until the parent answers and saves.
* No child-facing label explains the personalization.

Recommended future controls:

* Disable personalized follow-ups per child.
* Disable personalized follow-ups for the account.
* Mark a source memory as "do not use for follow-ups."
* Dismiss one suggestion without training a broad profile.

Avoid:

* Regenerating repeatedly in the first slice.
* Showing multiple AI candidates.
* Making the parent tune the algorithm.
* Asking parents to classify their child.

---

Privacy Notes

Child memories are sensitive family data. Personalized follow-ups increase sensitivity because they reuse private content to shape future prompts.

Privacy requirements:

* Use only memories belonging to the current child and authorized parent scope.
* Prevent cross-child memory leakage.
* Use parent-entered text first.
* Do not use raw voice content.
* Do not use voice transcripts until transcription exists, is parent-visible, and is explicitly allowed for this feature.
* Send the smallest useful context if an AI provider is used.
* Do not send full archives by default.
* Do not include unnecessary child profile fields.
* Do not log provider payloads or memory excerpts.
* Do not store unnecessary AI intermediate reasoning.
* Store the exact presented question if it is answered so the memory remains understandable later.
* Keep original parent-authored memories as the source of truth.

Provider review before implementation:

* Which provider receives context?
* Does the provider store or train on submitted data?
* What payload is sent?
* Are child names sent, or can a nickname/placeholder be used?
* Are transcripts included?
* What is retained locally?
* How does deletion/export apply to generated follow-ups and source references?

---

User Stories

* As a parent, I occasionally see a question that gently follows up on something my child shared before.
* As a parent, I can understand why a follow-up was suggested without seeing technical or analytical language.
* As a parent, I can skip a personalized follow-up and choose a normal question.
* As a parent, I never need to let AI speak directly to my child.
* As a parent, I can keep saving memories even if personalization is unavailable.
* As a maintainer, I can verify that follow-ups never use another child's memories.
* As a maintainer, I can confirm generated or adapted questions remain warm, non-clinical, and parent-reviewed.

---

Acceptance Criteria

Brief-level acceptance:

* Stage 7 has a durable active feature brief.
* The brief recommends a small MVP and explicitly excludes summaries, letters, dashboards, scores, labels, and clinical language.
* The brief applies the High-Risk Path for AI and child data privacy.
* The brief defines AI involvement, context limits, parent controls, persistence options, selection rules, and verification expectations.
* No code is implemented before review.

Future implementation acceptance:

* Curated Stage 6 prompt selection remains the default.
* Personalized follow-ups are eligible only after the minimum memory threshold.
* Follow-ups use only current-child authorized memory content.
* New children fall back to normal curated prompts.
* Sparse or sensitive memory contexts fall back to normal curated prompts.
* Personalized follow-ups are frequency-limited.
* The parent can skip or choose another question.
* The exact presented follow-up is preserved if answered.
* AI failures do not block the daily ritual or memory capture.
* No AI summaries, child labels, scores, dashboards, or clinical language are introduced.

---

Verification Plan

Automated tests for a future implementation:

* Follow-up eligibility when a child has enough saved text memories.
* Fallback to normal prompt when memory count is below threshold.
* Fallback to normal prompt when all candidate memories are sensitive or sparse.
* Parent authorization and child ownership for context building.
* No cross-child memory leakage.
* Personalized prompt frequency limits.
* Repeat avoidance for source memories and presented questions.
* Sensitive-context exclusion.
* Generated or adapted question persistence.
* Presented prompt snapshot used by capture and saved memory.
* Skip, dismiss, and choose-another behavior.
* AI provider failure fallback.
* Mobile ritual request flow.

Manual verification for a future implementation:

* Create a child with no memories and confirm normal daily prompt.
* Create a child with enough safe text memories and confirm occasional follow-up eligibility.
* Confirm the parent explanation is gentle and non-technical.
* Confirm choosing another question returns to curated prompts.
* Confirm skipped follow-ups do not immediately reappear.
* Confirm capture shows the same question as the child home.
* Confirm saved memory displays the exact question asked.
* Confirm mobile layout keeps controls touch-friendly.

Documentation-only verification before implementation:

* Confirm this brief exists under `docs/features/active/`.
* Confirm no application code, migrations, jobs, or prompts were implemented.
* Confirm scope matches `docs/product/product-principles.md`, `docs/features/_constraints.md`, and `docs/architecture/ai-architecture.md`.

---

Recommended Implementation Slices

Slice 7A - Non-AI Eligibility And Selection Shell

* Add the minimum persistence needed to represent a selection source and presented prompt snapshot.
* Build an eligibility service that decides whether personalized follow-up is allowed for a child/date.
* Use current-child saved text memory counts, frequency limits, and fallback rules.
* Do not call AI yet.
* Verify fallback behavior, authorization, and selection stability.

Slice 7B - Parent-Controlled Follow-Up UI

* Show a selected follow-up in the existing child home question area.
* Add parent-facing explanation copy.
* Add skip or choose-another behavior.
* Preserve capture continuity.
* Verify mobile ritual flow.

Slice 7C - Curated Template Follow-Ups

* Add a small set of safe follow-up templates tied to prompt categories or source memory patterns.
* Use only parent-entered text memories.
* Avoid sensitive contexts.
* Store the exact presented question.
* Verify repeat avoidance and source-memory references.

Slice 7D - AI-Assisted Adaptation

* Add AI only after slices 7A through 7C establish the safe product path.
* Send a limited context packet for one child.
* Ask the model to adapt a curated template and produce one safe question plus one parent-facing explanation.
* Validate output against tone and safety rules before presentation.
* Fall back to curated prompts on any failure.

Slice 7E - Settings And Refinement

* Add a child or account setting to disable personalized follow-ups if needed.
* Add "do not use this memory for follow-ups" only if parent feedback shows the need.
* Revisit deletion/export behavior before broad release.

---

Open Questions

* Should personalized follow-ups be represented as prompt snapshots on `DailyQuestionSelection`, as generated `DailyQuestion` records with a source type, or as a separate suggestion model?
* Should the first implementation slice avoid AI entirely and ship only template follow-ups?
* What exact sensitive-content filter is acceptable before AI summaries exist?
* Should parent explanations mention the source memory date?
* Should a parent be able to disable personalization per child in the first release, or can dismissal plus curated fallback be enough for MVP?
* How should generated follow-ups participate in future deletion and export flows?
* If transcripts are added later, what parent action makes a transcript eligible for follow-up context?

---

Implementation Notes

Stage 7A implemented the non-AI foundation only:

* `DailyQuestionSelection` now records `source_type` and `presented_prompt`.
* Curated selections default to `source_type: curated` and snapshot the selected `DailyQuestion.prompt`.
* `MemoryResponse` now records `prompt_snapshot` so saved memories preserve the exact question shown at save time.
* Memory archive/detail views render `prompt_snapshot` first, with fallback to the curated daily question prompt.
* `PersonalizedFollowUpEligibility` can determine whether a child/date has enough current-child text memory history and frequency readiness for a future follow-up.
* Stage 7A does not generate, show, summarize, classify, score, or label personalized follow-ups.
* Stage 7A does not use raw voice content, transcripts, or AI provider calls.

Stage 7B implemented the parent-facing display shell only:

* The child home daily ritual now renders `DailyQuestionSelection.presented_prompt`, with fallback to the selected curated `DailyQuestion.prompt`.
* The "Answer today's question" path now carries the selected daily question selection into capture.
* The capture prompt card now renders the selected/presented prompt.
* Saving today's selected question preserves the selected presented prompt in `MemoryResponse.prompt_snapshot`.
* The alternate curated question selector remains available and continues to save the alternate curated prompt when the parent chooses a different question.
* Stage 7B does not generate or select personalized follow-ups.
* Stage 7B does not add skip/dismiss controls, templates, raw voice content, transcripts, or AI provider calls.

Do not implement later Stage 7 slices until reviewed and approved.

Before implementation, create or update a decision record if the team chooses a durable AI provider behavior, a new storage model for generated prompts, or a policy for using transcripts in personalization.
