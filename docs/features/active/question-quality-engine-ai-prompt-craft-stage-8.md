# Question Quality Foundation - Stage 8

Status

Stage 8A, Stage 8B, and Stage 8C implemented. Stage 8D and later remain draft; do not implement later slices until reviewed and approved.

---

Parent Document

This brief is governed by `docs/product/conversation-intelligence-architecture.md`.

Stage 8 implements the first editorial foundation of the future Question Engine. It does not implement Living Portrait, Parent Reflection Coach, AI generation, AI summaries, parent debrief, or any derived understanding layer.

---

User Problem

The app now supports a coherent daily ritual loop:

Parent opens a child home -> sees today's selected question -> captures that same question -> saves a private memory.

Stage 6 created a structured prompt library and stable daily question orchestration. Stage 7 added the foundation for memory-aware follow-ups without AI calls, memory text parsing, voice transcript usage, or child profiling.

The next problem is question quality. If the app asks ordinary, repetitive, awkward, or emotionally mismatched questions, the ritual will feel thin even if the capture flow works. Parents need prompts that help them start conversations their children actually want to answer.

---

Product Intent

Create the next foundation for excellent parent-child conversation prompts before AI summaries.

Question quality is central because the product's value begins before anything is saved. Better questions create better conversations. Better conversations create better memories. Better memories eventually make better AI summaries and reflection letters.

This stage supports the product formula:

Conversation -> Connection -> Understanding -> Memory -> Legacy

The question is not the product; the relationship is the product. A great question should make the parent feel helped, not replaced. It should make the app feel quietly thoughtful without becoming a chatbot, therapist, assessment tool, or surveillance system.

Why generic prompts are not enough:

* Generic prompts are easy to exhaust and easy to ignore.
* Generic prompts often sound like worksheets, icebreakers, or interview questions.
* Generic prompts do not reliably fit a child's age, mood, imagination, or everyday world.
* Generic prompts can create saved memories that are factual but not emotionally alive.

Why question quality matters before early summaries:

* Summaries can only reflect the quality of the memories captured.
* Strong questions improve the source material without requiring AI interpretation.
* A better prompt library strengthens the core ritual even if AI is unavailable.
* The safety patterns needed for AI-generated summaries begin with safe input design, review, and tone.

---

Existing Foundation

This feature builds on:

* Parent accounts.
* Child profiles.
* Daily questions.
* Structured prompt library.
* Daily question selections.
* Prompt snapshots.
* Text memories.
* Voice memories.
* Memory archive and timeline.
* Ritual-first child home.
* Today's selected question carried into capture.
* Curated category-based follow-ups.
* Parent-controlled memory saving.

Relevant current implementation notes:

* `DailyQuestion` is the curated prompt library.
* `DailyQuestion` already includes slug, category, tags, optional age guidance, active state, and internal notes.
* `DailyQuestionSelection` persists one selected question per child per date and can preserve presented prompt text.
* Stage 7 added prompt source handling and non-AI follow-up eligibility.
* There is no approved AI prompt generation, AI question evaluation, child profile inference, or voice transcript usage.

---

Risk Tier

Use the High-Risk Path.

Stage 8 defines the first editorial foundation for future question quality, child prompt selection, possible AI-generated content, and context boundaries for child data. Even though Stage 8A is metadata-only and non-AI, the feature brief must apply the AI behavior and child-data privacy constraints in `docs/features/_constraints.md`, `docs/architecture/ai-architecture.md`, and `docs/product/conversation-intelligence-architecture.md`.

Release constraints:

* Parent review and human curation remain required for AI-assisted prompt publishing.
* AI-generated questions must not become autonomous child-facing output.
* Prompt quality must not become scoring, diagnosis, therapy, schoolwork, or child profiling.
* The core ritual must remain useful when AI is unavailable.
* Stage 8A must remain non-AI: no AI calls, no AI-generated prompts, no AI summaries, no Living Portrait implementation, and no Parent Reflection Coach implementation.

---

In Scope

* Define the product purpose of question quality.
* Define question design principles and anti-patterns.
* Define broad age-aware prompt strategy.
* Define prompt categories and conversation goals.
* Define question families, depth rhythm, variety, rotation, and repeat-avoidance expectations.
* Define the future AI role in prompt quality without implementing AI calls.
* Define an internal question quality rubric.
* Define AI prompt architecture for future question generation, adaptation, and evaluation.
* Define context boundaries for any future AI-assisted prompt work.
* Analyze possible `DailyQuestion` and related model changes.
* Define the role of human curation and review.
* Discuss future parent feedback signals without building analytics.
* Define safety and tone rules.
* Describe UX surfaces affected by question quality.
* Recommend small implementation slices.

---

Out Of Scope

* AI summaries.
* Monthly reflection letters.
* Personality profiles.
* Temperament labels.
* Emotional scoring.
* Developmental assessment.
* Therapy recommendations.
* Parent advice engine.
* Child-facing chatbot.
* Dashboards.
* Streaks.
* Badges.
* Gamification.
* Educational recommendations.
* Full archive analysis.
* Raw voice analysis.
* Unreviewed transcript use.
* Automatic publishing of AI-generated prompts.
* Fully autonomous AI prompt generation without review.
* Parent-facing question scores.
* Child labels, rankings, or inferred traits.
* Living Portrait implementation.
* Parent Reflection Coach implementation.
* Parent debrief implementation.

---

Product Purpose

Question quality is the engine of the daily ritual.

A strong question does three jobs at once:

* It gives the parent a natural opening.
* It gives the child room to surprise the parent.
* It creates a memory worth preserving.

The app should not compete with the parent for attention. It should help the parent become more curious, more consistent, and more present. The best prompts should feel like something a thoughtful parent might have asked on their own, at just the right moment.

Question quality can make the app feel magical without overusing AI because the magic comes from timing, fit, voice, and variety. A parent does not need to see a generated explanation or analysis for the product to feel intelligent. The daily question simply needs to feel askable, warm, and worth answering.

---

Question Design Principles

A good question for this app should generally:

* Be easy for a parent to ask out loud.
* Invite a story, choice, image, memory, or small explanation.
* Avoid yes/no answers unless the follow-up path is obvious.
* Create curiosity.
* Sometimes be playful or silly.
* Sometimes be reflective.
* Sometimes preserve childhood memories.
* Fit the child's broad age range.
* Feel warm without being sentimental all the time.
* Feel specific without needing private context.
* Avoid sounding like therapy.
* Avoid sounding like schoolwork.
* Avoid sounding like a parenting assessment.
* Avoid being too abstract for younger children.
* Avoid being too emotionally heavy too often.
* Avoid forcing vulnerability.
* Leave room for surprise.

Questions should often use concrete anchors:

* Today.
* A favorite thing.
* A small moment.
* A place.
* A person or relationship.
* A made-up scenario.
* A choice between two possibilities.
* A memory the child wants to keep.

Questions should avoid pretending to know the child's inner world. They can invite reflection, but they should not tell the child what they feel, why they acted, or what their answer means.

Bad question patterns:

* Too generic: "How was your day?"
* Too adult: "What values are guiding your decisions lately?"
* Too clinical: "What emotion regulation strategy did you use?"
* Too leading: "Why do you think you were upset because you felt left out?"
* Too emotionally intense: "What is your deepest fear right now?"
* Too worksheet-like: "List three examples of kindness you showed today."
* Too advice-oriented: "What should you do next time?"
* Too hard to answer: "What defines who you are?"
* Too similar to recent questions: several days of favorites, fears, or future dreams in a row.
* Too evaluative: "What are you getting better at compared with last month?"
* Too surveillance-like: "I noticed you keep talking about..."

---

Age-Aware Prompt Strategy

Age should influence question selection without turning the app into a developmental tool.

Recommended broad age bands:

* 4-6: concrete, playful, imaginative, sensory, simple choices.
* 7-9: story-based, favorites, silly hypotheticals, friendships, daily life.
* 10-12: identity, creativity, dreams, values, friendships, future self.
* 13-15: independence, meaning, relationships, choices, self-reflection, future.

Age handling:

* Use the child's birthday, when available, to calculate current age.
* Prefer prompts that fit the broad age band.
* Keep all-age prompts eligible when age is unknown or when variety is needed.
* Treat age guidance as flexible curator guidance, not a hard claim about development.
* Avoid prompts that would feel babyish for older children.
* Avoid prompts that require abstract self-analysis from younger children.
* Let the parent choose another question when a prompt does not fit today's conversation.

Age guidance should never imply a child is advanced, delayed, mature, immature, anxious, gifted, defiant, sensitive, or any other trait. It should describe the question, not the child.

Examples by age style:

* 4-6: "If your stuffed animals planned a party, what would they serve?"
* 7-9: "What was the funniest tiny thing that happened today?"
* 10-12: "What is something you would like to get better at because it sounds fun?"
* 13-15: "What is one small choice lately that felt like it was really yours?"

---

Question Categories And Conversation Goals

Categories should help the system balance the library and avoid repetition. They should remain internal or curator-facing unless a later UX brief designs parent controls.

Recommended categories:

* `imagination`
* `daily_life`
* `relationships`
* `memories`
* `feelings`
* `dreams`
* `courage`
* `kindness`
* `problem_solving`
* `family_stories`
* `curiosity_wonder`
* `favorites`
* `silly_playful`
* `future_self`
* `creativity`
* `gratitude`
* `change_growth`

Recommended conversation goals:

* Spark laughter.
* Invite storytelling.
* Preserve a memory.
* Understand the child's inner world.
* Revisit something meaningful.
* Deepen connection.
* Encourage imagination.
* Notice small moments.
* Create anticipation for tomorrow.

Question families should become first-class prompt metadata. Recommended `question_family` values:

* `relationship_mirror` - helps the child reflect on the parent-child relationship.
* `inner_world` - helps the parent understand the child's lived experience.
* `imagination_doorway` - creates wonder, play, and children's-book-like magic.
* `memory_preserving` - creates heirloom value by preserving childhood in the child's own words.
* `becoming` - helps parents notice growth without labeling the child.
* `silly_to_deep` - starts playful but can become meaningful.

`question_family` should be internal metadata for curation, rotation, and future candidate review. It should not create a parent-facing taxonomy unless a later UX brief explicitly designs that surface.

Question depth should be balanced:

* `light`: fun, easy, silly, low emotional demand.
* `medium`: reflective, story-based, memory-building.
* `deep`: identity, relationship, vulnerability, meaning, legacy.

Recommended rhythm:

* 70% light, fun, or curious.
* 20% reflective or memory-building.
* 10% deep or relationship-opening.

Deep prompts should be rare and should never require disclosure. The default rhythm should be warm, varied, and sustainable, not deep every day.

---

Golden Questions

Golden Questions are especially effective real-world questions that reveal the product's editorial taste. They should be documented as reference examples for prompt curation, seed review, and future AI candidate evaluation.

A Golden Question record should include:

* Question text.
* Age fit.
* Question family.
* Depth.
* Why it worked.
* Risks.
* Softer variants.
* Recommended frequency.

Guiding example:

"How is it to have a father like me?"

This is a deep `relationship_mirror` question. It worked because it gave the child authority, invited honesty, treated the child's perspective as valuable, and created room for stories. It is powerful precisely because it is direct and relational.

Risks:

* It can feel emotionally demanding.
* It can put the child in the position of caring for the parent's feelings.
* It can feel too intense if asked casually, too often, or at the wrong moment.

Softer variants:

* What is something I do that helps you feel understood?
* When do you feel like I really listen to you?
* What is one thing about being in our family that you hope we always keep?

Recommended frequency:

Use rarely. Deep relationship mirror questions should be occasional invitations, not daily ritual defaults.

---

Question Variety And Rotation

The app should avoid becoming predictable or repetitive.

Selection should consider:

* Recent prompt text.
* Recent prompt category.
* Recent question family.
* Recent conversation goal.
* Question depth.
* Age-band fit.
* Whether the child recently received a follow-up.
* Whether the prompt is all-age or age-specific.

Recommended rotation principles:

* Avoid repeating the same prompt for a child within a long window.
* Avoid asking the same category several days in a row when alternatives exist.
* Avoid too many reflective or deep prompts in a short period.
* Keep playful and ordinary prompts in the mix.
* Use follow-ups occasionally, not as the default daily experience.
* Prefer normal curated prompts when a child has few saved memories, when safe context is unavailable, or when a follow-up would feel forced.
* Use follow-ups when there is a clear, safe, concrete prior memory or category pattern that can be revisited lightly.

To prevent predictability:

* Rotate between playful, reflective, memory-preserving, and curiosity-driven goals.
* Keep some all-age prompts with high replay value.
* Maintain enough prompts per age band and category that repeat avoidance does not collapse into a tiny set.
* Allow future parent choice without turning the app into a content library.

---

AI Role

AI should eventually help improve question quality, but it should not simply be asked to "generate a question for this child."

Safer AI patterns:

* AI adapts approved prompt patterns.
* AI generates multiple candidate questions within strict constraints.
* AI evaluates candidate questions using an internal rubric.
* AI rewrites a question to fit an age band.
* AI creates playful variants of a curated prompt.
* AI creates follow-up candidates from safe, limited context.
* AI rejects questions that are clinical, generic, too intense, or not askable aloud.

AI should:

* Support the parent.
* Preserve the app's tone.
* Avoid diagnosis.
* Avoid labels.
* Avoid sensitive inference.
* Avoid child-facing chatbot behavior.
* Remain useful only inside specific feature flows.
* Fail quietly with deterministic fallback.

Recommended safest MVP approach:

Stage 8 should begin without AI calls. First, create a stronger internal rubric and metadata model for prompt quality. Then expand and review the curated prompt library manually. Only after that should AI assist with draft candidate generation or evaluation, and any AI-generated prompts should remain inactive until reviewed.

Do not show unreviewed AI-generated questions to parents or children.

---

Question Quality Rubric

The rubric is internal only. Do not expose scores to parents.

Recommended dimensions:

* Age fit: Does the question fit the child's broad age band without sounding babyish or too mature?
* Clarity: Is it immediately understandable?
* Warmth: Does it feel like something a caring parent might ask?
* Askability aloud: Can a parent say it naturally without awkward setup?
* Novelty: Does it avoid sounding like a generic prompt deck?
* Emotional safety: Does it avoid pressure, diagnosis, excessive depth, and sensitive disclosure?
* Conversation potential: Is it likely to create more than a one-word answer?
* Playfulness: Does it leave room for fun when appropriate?
* Specificity: Does it include a concrete anchor without requiring private knowledge?
* Openness: Does it leave room for the child's own answer?
* Memory potential: Could the answer become a meaningful saved memory?
* Non-clinical tone: Does it avoid therapy, assessment, schoolwork, and labels?
* Freshness: Is it meaningfully different from recent prompts?
* Depth balance: Does it fit the current prompt rhythm?

Suggested internal rating shape:

* `pass` - ready for active curated use.
* `revise` - promising but needs edit.
* `reject` - not appropriate for this product.

Optional internal scoring can exist for tooling, but the product should prefer simple review status and notes over pretending question quality is mathematically precise.

Deterministic or AI-assisted:

* Deterministic checks should catch required metadata, forbidden terms, missing age/category/family/depth fields, inactive draft status, repeat windows, and depth balance.
* AI-assisted checks may help evaluate tone, askability, genericness, and age fit.
* Human review remains the publishing control.

---

AI Prompting Architecture

Future AI-assisted question work should use feature-scoped prompts with explicit constraints and structured output.

System/developer prompt principles:

* You help craft warm parent-child conversation questions.
* You do not diagnose, label, score, rank, or assess children.
* You do not create therapy homework, schoolwork, parenting advice, or clinical language.
* You write questions a parent can naturally ask out loud.
* You keep questions age-aware, emotionally safe, concrete, and open-ended.
* You reject unsafe or mismatched requests instead of forcing an answer.

Input context shape:

* Child nickname or placeholder, if needed.
* Broad age band.
* Selected category.
* Desired conversation goal.
* Desired question family.
* Desired question depth.
* Recent prompt categories.
* Recent question families.
* Recent selected prompt texts.
* Approved prompt pattern or seed prompt.
* Limited safe memory context only for a later approved slice.
* Forbidden outputs and forbidden language.

Candidate output format:

* `question_text`
* `category`
* `question_family`
* `conversation_goal`
* `age_band`
* `question_depth`
* `quality_rationale`
* `safety_notes`
* `review_status_recommendation`
* `rejection_reason`, if rejected

Validation expectations:

* Output must be one question, not advice or a script.
* Output must be askable aloud.
* Output must not include diagnosis, labels, scores, rankings, or interpretation claims.
* Output must not include sensitive content unless the parent explicitly chose a later approved feature path.
* Output must not reference memories that were not included in the context packet.
* Output must pass deterministic forbidden-language checks before review.

Fallback behavior:

* If AI fails, times out, or returns unsafe output, use curated prompts.
* If candidate quality is uncertain, keep the candidate inactive.
* If safe context is unavailable, generate or select only from approved all-purpose patterns.
* AI failure must not block the daily question ritual.

Provider details:

* Do not choose a specific AI provider in Stage 8 unless implementation requires it.
* Any future provider choice must document data sent, retention behavior, training behavior, failure handling, and parent review.

---

Context Boundaries

Allowed context for future AI-assisted prompt quality:

* Child nickname or placeholder.
* Broad age band.
* Recent prompt categories.
* Recent selected prompts.
* Safe curated prompt metadata.
* Approved prompt patterns.
* Desired conversation goal.
* Desired question family.
* Desired question depth.
* Short parent-saved text excerpts in a later slice only if explicitly approved.

Excluded context:

* Other children's memories.
* Raw voice recordings.
* Unreviewed transcripts.
* Sensitive memories.
* Full archive by default.
* Medical, disciplinary, trauma, bullying, family conflict, religious, sexuality, legal, or safety-sensitive content.
* Inferred personality traits.
* Scores, labels, diagnoses, or emotional interpretations.
* Long-term child interest graphs.
* Parent notes not explicitly selected for the feature.

This prepares for future summaries by establishing safe context packets, structured prompt versions, review status, fallback behavior, and deletion/export questions before the app begins generating interpretive content. It is safer than summaries because the output is a question, not a claim about the child.

---

Data Model Notes

Stage 8 does not require model changes in the brief-only step.

Possible model changes for later implementation:

Extend `DailyQuestion`:

* `age_band` or structured age-band metadata.
* `conversation_goal`.
* `question_family`.
* `question_depth`.
* `quality_status`.
* `review_status`.
* `prompt_pattern`.
* `source`.
* `quality_notes`.
* `reviewed_at`.
* `reviewed_by_id`, if admin ownership exists later.
* `prompt_version`.

Possible values:

* `conversation_goal`: storytelling, memory, laughter, imagination, connection, reflection, curiosity, gratitude, anticipation.
* `question_family`: relationship_mirror, inner_world, imagination_doorway, memory_preserving, becoming, silly_to_deep.
* `question_depth`: light, medium, deep.
* `review_status`: draft, needs_revision, approved, rejected, retired.
* `source`: human_curated, ai_draft, ai_adapted, imported_seed.

AI-generated candidate storage:

* AI-generated candidates should not automatically become active `DailyQuestion` records.
* The safest path is to store candidate prompts as draft or inactive records only after the app has a review workflow.
* If no review workflow exists, AI candidates can be generated for developer review outside the runtime product and added through seed updates.
* Generated candidates should store prompt version, generation context summary, review status, and rejection reason if retained.

Parent-facing versus internal text:

* Parent-facing prompt text should stay clean and natural.
* Internal notes, quality rationale, safety notes, and scores must not render in parent UI.

Versioning:

* Prompt snapshots should continue preserving what the parent saw.
* Edits to prompt text should not alter historical memory meaning.
* `slug` remains important for seed upserts and editorial tracking.

Recommended first implementation shape:

* Prefer refining existing `DailyQuestion` metadata before adding new tables.
* Keep metadata enum-like and constrained.
* Avoid a complex admin CMS until the library and review process need it.

---

Human Review And Curation

Questions should not become fully autonomous.

Human curation is required because the product depends on taste, restraint, voice, and trust. AI can produce many plausible questions, but it cannot decide what the product should feel like.

Recommended curation model:

* Maintain a reviewed seed library.
* Keep approved prompt patterns for AI-assisted variants.
* Store rejected examples and reasons so future reviews are consistent.
* Require dev/admin review before prompts become active.
* Use internal prompt quality notes to preserve editorial judgment.
* Retire prompts that feel generic, awkward, too intense, or repetitive.

Human taste and AI assistance should work together:

* Humans define the voice, boundaries, categories, and approval bar.
* AI drafts options, variants, rewrites, and critique.
* Deterministic checks enforce hard rules.
* Human review decides what becomes part of the active ritual.

---

Parent Feedback Signals Later

Do not implement analytics in Stage 8A.

Future signals that may help improve question quality:

* Parent answers the question.
* Parent chooses another question.
* Parent skips.
* Parent saves voice.
* Parent saves text.
* Parent revisits memory.
* Parent manually favorites a question, if ever added.
* Parent dismisses a follow-up.

These signals should be used carefully. They should improve the ritual, not create manipulative retention loops.

Do not add:

* Dashboards.
* Scores.
* Streaks.
* Badges.
* Engagement mechanics.
* Child rankings.
* Parent performance metrics.

If parent feedback later influences selection, it should remain quiet, private, and scoped to making prompts feel more useful.

---

Safety And Tone Rules

Questions must not:

* Diagnose.
* Label.
* Assess.
* Score.
* Rank.
* Compare children.
* Imply emotional interpretation as fact.
* Pressure a child to disclose.
* Sound like therapy homework.
* Sound like schoolwork.
* Sound like an interview.
* Ask the child to explain distress unless the parent explicitly chooses that direction in a later approved feature.
* Use "I noticed," "you always," "your pattern," "this means," or similar analysis language.
* Make the app sound like the speaker to the child.

Questions should:

* Feel like something a thoughtful parent might naturally ask.
* Use warm, ordinary language.
* Keep the child free to answer lightly.
* Invite story, imagination, memory, curiosity, or connection.
* Keep the parent as the relationship holder.

Forbidden tone examples:

* "I noticed you often feel left out. Why is that?"
* "What does your anger tell you about your needs?"
* "Which coping skill helped you regulate today?"
* "What is one way you failed and what did you learn?"
* "Based on your past answers, why do you avoid hard things?"

Better tone examples:

* "What was one tiny part of today you want to remember?"
* "If today had a funny sound effect, what would it be?"
* "Who made your day a little better?"
* "What is something you are curious about right now?"
* "If you could keep one moment from this week in a jar, what would it be?"

---

User Experience

Question quality should appear inside the existing ritual loop, not as a new dashboard.

Surfaces:

* Child home: today's selected question should feel fresh, age-aware, and askable.
* Capture prompt card: the same question should carry into text and voice capture.
* Choose another question: future selection should offer a small, simple escape when the question does not fit.
* Follow-up question display: personalized follow-ups should remain occasional, clearly parent-facing, and easy to skip.
* Empty states: use strong all-age curated prompts when the app has little context.
* Future prompt preview/review: internal or admin surfaces may show rubric notes, review status, and source.
* Future parent controls: allow parents to choose another question or disable follow-ups without managing a complex prompt system.

UX principles:

* Keep the first screen focused on the ritual.
* Do not expose rubric scores.
* Do not expose internal AI reasoning.
* Do not make parents tune categories, depth, families, or age bands during MVP.
* Do not imply the app knows the child better than the parent.
* Let question quality be felt through better questions, not explained through UI.

---

Recommended Implementation Slices

Stage 8A: Question Quality Rubric & Prompt Metadata

* Refine or add metadata for age band, category, question family, conversation goal, question depth, quality notes, and review status.
* Add validations for allowed values.
* Add internal documentation for the rubric.
* No AI calls.
* No AI-generated prompts.
* No parent-facing scores.
* No summaries.
* No Living Portrait implementation.
* No Parent Reflection Coach implementation.
* No behavior change beyond safer prompt eligibility if needed.

Stage 8B: Prompt Library Expansion

* Add a stronger curated seed set based on the rubric.
* Use human-crafted questions first.
* Ensure coverage across age bands, categories, families, goals, and depth levels.
* Keep active prompts reviewed.

Stage 8C: Question Quality Evaluator

* Add a deterministic internal evaluator for required metadata, forbidden terms, depth, and repeat risk.
* Optionally add AI-assisted evaluation only after provider/privacy review.
* Keep evaluator output internal.
* Do not block the ritual unless a prompt is unsafe or inactive.

Stage 8D: AI-Assisted Candidate Generation

* Generate candidate prompts from approved patterns.
* Store as draft or inactive until reviewed.
* Include prompt version, source, quality rationale, and safety notes.
* Do not auto-show unreviewed AI prompts.

Stage 8E: AI-Assisted Daily Selection

* Use age, category balance, prompt history, and safe context to select from approved prompts.
* Fallback to deterministic selection.
* Do not generate a brand-new daily question at request time for direct parent display.

Stage 8F: AI-Assisted Follow-Up Adaptation

* Adapt curated follow-up templates using limited safe context.
* Keep parent-controlled.
* No freeform archive analysis.
* No raw voice or unreviewed transcript use.

Recommended smallest first implementation slice:

Start with Stage 8A only. Define the internal rubric in code-adjacent documentation, tighten `DailyQuestion` metadata if needed, and prepare the library for higher-quality curation. This gives the product a stronger question engine without introducing AI calls, generated content, new privacy exposure, or complex personalization.

Challenge note:

The tempting larger version would add AI generation, parent feedback loops, adaptive personalization, and prompt analytics at once. That would move the product toward an optimization system before the editorial foundation is ready. Stage 8 should first prove that better reviewed questions can improve the ritual.

---

Acceptance Criteria For Stage 8A

Before Stage 8A is considered complete:

* The prompt quality rubric exists as durable documentation.
* The app has a clear set of allowed categories, question families, conversation goals, and question depth values.
* Any new prompt metadata is internal and not exposed as parent-facing scores.
* Existing daily selection and capture continuity still work.
* Prompt snapshots still preserve what the parent saw.
* No AI provider calls are introduced.
* No AI-generated prompts are introduced.
* No AI summaries are introduced.
* No Living Portrait implementation is introduced.
* No Parent Reflection Coach implementation is introduced.
* No voice recordings, transcripts, full archives, or sensitive memories are sent to AI.
* No child profiles, personality labels, developmental claims, dashboards, scores, streaks, or badges are added.
* Tests cover any model validations, seed behavior, and selection behavior changed by the slice.

---

Stage 8A Implementation Notes

Stage 8A implemented the first non-AI editorial metadata foundation:

* `DailyQuestion` now stores internal `question_family`, `question_depth`, `conversation_goal`, `review_status`, and `quality_notes` metadata.
* `question_family` is constrained to `relationship_mirror`, `inner_world`, `imagination_doorway`, `memory_preserving`, `becoming`, and `silly_to_deep`.
* `question_depth` is constrained to `light`, `medium`, and `deep`.
* `conversation_goal` is constrained to `storytelling`, `memory`, `laughter`, `imagination`, `connection`, `reflection`, `curiosity`, `gratitude`, and `anticipation`.
* `review_status` is constrained to `draft`, `needs_revision`, `approved`, `rejected`, and `retired`.
* Existing curated seed prompts now receive valid internal question-quality metadata and remain active/reviewed.
* The existing `category` field was preserved rather than replaced with the larger future category taxonomy, because Stage 8A is metadata/rubric foundation only and should not become Stage 8B prompt-library expansion.
* Daily question selection behavior, prompt snapshots, curated follow-up behavior, and parent-facing UX were not changed.
* No AI calls, AI-generated prompts, AI candidate storage, summaries, Living Portrait, Parent Reflection Coach, parent debrief, dashboards, scores, streaks, badges, labels, or clinical language were introduced.

---

Stage 8B Implementation Notes

Stage 8B expanded and improved the human-curated prompt library using Stage 8A metadata:

* The seed library now contains 68 curated active prompts in a clean seed load.
* A small number of weaker existing prompts were polished while preserving their slugs.
* New prompts were added across all approved `question_family` values: `relationship_mirror`, `inner_world`, `imagination_doorway`, `memory_preserving`, `becoming`, and `silly_to_deep`.
* New prompts were added across `question_depth` values while keeping deep prompts present but not dominant.
* New prompts include broader age guidance for 4-6, 7-9, 10-12, and 13-15 without making developmental claims.
* Golden Questions were added as approved seed prompts with internal `quality_notes`, including "How is it to have a father like me?" as a rare older-child deep `relationship_mirror` prompt.
* Seed specs now verify metadata validity, family coverage, depth coverage, deep-prompt restraint, broad age eligibility, forbidden clinical/surveillance language, Golden Question notes, and idempotent seed loading.
* Daily question selection behavior, prompt snapshots, curated follow-up behavior, and parent-facing UX were not changed.
* No AI calls, AI-generated prompts, AI candidate storage, summaries, Living Portrait, Parent Reflection Coach, parent debrief, dashboards, scores, streaks, badges, labels, or clinical language were introduced.

---

Stage 8C Implementation Notes

Stage 8C added a deterministic, internal-only question quality evaluator:

* The evaluator lives at `app/services/daily_questions/question_quality_evaluator.rb`.
* The evaluator is callable with `DailyQuestions::QuestionQualityEvaluator.new(scope: DailyQuestion.active).call`.
* It returns a result object with `passed?`, `errors`, `warnings`, and `summary`.
* Hard errors cover missing/invalid metadata, active unapproved prompts, blank prompt text, non-question-like prompt text, overlong prompt text, invalid age bounds, and forbidden clinical/surveillance language.
* Warnings cover ambiguous sensitive language, missing family/depth coverage, deep prompt overuse, relationship mirror overuse, too few light prompts, too few all-age prompts, and missing internal notes on deep prompts.
* The seeded prompt library is expected to pass with no errors and no warnings.
* Normal daily selection now uses `DailyQuestion.approved_for_selection`, which means new curated selections require `active: true` and `review_status: approved`.
* Existing same-day selections remain stable even if a prompt later becomes inactive or unapproved.
* Evaluator output is not exposed in parent-facing UI and does not run on parent requests.
* No AI calls, AI-assisted evaluation, AI-generated prompts, AI candidate storage, summaries, Living Portrait, Parent Reflection Coach, parent debrief, dashboards, scores, streaks, badges, labels, or clinical language were introduced.

Deferred:

* Stage 8D AI-assisted candidate generation.
* Stage 8E AI-assisted daily selection.
* Stage 8F AI-assisted follow-up adaptation.
* Any internal/admin review UI or rake task for evaluator reporting.

---

Verification Plan

For documentation-only Stage 8 brief:

* Verify the brief exists under `docs/features/active/`.
* Verify it agrees with `docs/product/product-principles.md`, `docs/product/mvp-product-goal.md`, `docs/features/_constraints.md`, and `docs/architecture/ai-architecture.md`.
* Verify no app behavior, models, migrations, routes, views, jobs, or services were changed.

For future Stage 8A implementation:

* Run focused model and service specs for any `DailyQuestion` metadata changes.
* Run daily question selector specs if eligibility or rotation changes.
* Run prompt library seed specs if seed data changes.
* Run request specs only if parent-facing prompt selection behavior changes.
* Run `bundle exec rspec` when shared prompt selection behavior changes.
* Run `bundle exec rubocop` before handoff.
* Manually verify child home and capture prompt continuity if UI output changes.

---

AI And Privacy Notes

Stage 8 brief creation does not add child data, send data to AI, log new sensitive fields, or change retention.

Future AI-assisted slices must document:

* Which child data is sent.
* Why that data is necessary.
* Whether child names are included.
* Whether memories, voice recordings, or transcripts are included.
* Whether generated candidates are stored.
* How review, edit, approval, rejection, deletion, and export work.
* What prompt version was used.
* What fallback path runs when AI fails.
* Whether the provider stores or trains on submitted data.

Parent review remains required before AI-assisted content becomes active or durable parent-facing content.

---

Open Questions

* Should the first Stage 8 implementation slice be metadata and rubric only?
  Recommended answer: yes. Stage 8A should be rubric documentation and metadata refinement only, with no AI calls and no generated prompts.
* Should AI-generated prompts ever be shown without human review?
  Recommended answer: no for MVP. AI-generated prompts should remain draft/inactive until reviewed, or be generated offline and committed through seeds.
* Should AI candidate prompts be stored in the app, or generated offline and committed through seeds first?
  Recommended answer: for MVP, generate offline or in developer/admin tooling and commit through reviewed seeds first. App-level candidate storage can wait until there is a real review workflow.
* Are four age bands enough for MVP?
  Recommended answer: yes. Use broad bands for now: 4-6, 7-9, 10-12, 13-15. Keep all-age prompts available.
* Should question depth be tracked as required metadata?
  Recommended answer: yes. Track `question_depth` with values `light`, `medium`, and `deep`.
* Should parent feedback influence future question selection before or after AI summaries?
  Recommended answer: after the question metadata/rubric foundation, but before full AI summaries if kept lightweight. Start only with simple product signals later, such as answered, chose another, skipped, voice included, or saved memory. Do not add dashboards or analytics.
* Should question quality improvements ship before AI summaries?
  Recommended answer: yes. Better questions create better conversations, and better conversations create better source material for future summaries.
* How much child memory context is appropriate for prompt adaptation in a later slice?
  Recommended answer: start with no memory text in Stage 8A. Later, allow only small, parent-authorized, current-child, safe text excerpts. No full archive, raw voice, unreviewed transcripts, sensitive memories, or cross-child context.
* Does the MVP need an internal admin review UI, or are seeds and code review enough for now?
  Recommended answer: seeds and code review are enough for now. Add admin review UI only when prompt volume or AI candidate workflow makes seed review too slow.
* Should follow-up questions and general daily prompts share the same quality rubric?
  Recommended answer: yes. They should share the same core rubric, but follow-ups need additional checks for source safety, specificity, repeat avoidance, and not sounding surveillance-like.
