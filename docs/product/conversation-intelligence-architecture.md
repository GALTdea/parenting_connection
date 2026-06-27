# Conversation Intelligence Architecture

Status

Product architecture note. This document captures durable product direction for future conversation intelligence work. It does not authorize implementation by itself.

---

## Purpose

This document defines the product-level architecture and philosophy for the app's future question engine, living understanding layer, first-session personalization, and parent reflection/coaching direction.

It should guide future Stage 8+ feature briefs before additional implementation work begins.

Mission:

Help parents become students of their children.

Product formula:

Conversation -> Connection -> Understanding -> Memory -> Legacy

Core boundary:

The relationship is the product.

The app is not a parenting dashboard, tracker, assessment, therapy tool, school tool, child evaluation system, or generic AI chat product. It should help parents have better conversations, understand their children more deeply, and preserve meaningful memories.

---

## Current Foundation

The current product foundation includes:

* Parent accounts.
* Child profiles.
* Daily questions.
* Structured prompt library.
* Daily question selections.
* Prompt snapshots.
* Memory responses.
* Voice memories.
* Memory archive and timeline.
* Ritual-first child home.
* Selected question carried into capture.
* Non-AI curated category-based follow-ups.
* No AI summaries yet.
* No child labels, scores, dashboards, streaks, badges, or clinical language.

This architecture builds from that foundation without changing the core ritual shape:

child home -> one selected question -> capture -> save memory -> archive

---

## Core Thesis

The product should not merely ask generic daily prompts.

It should become a thoughtful conversation companion that helps parents enter the child's inner world at the right depth, at the right time, in the right tone.

The app should eventually feel like:

* A wise question appears.
* The parent asks it.
* The child opens up.
* The memory is preserved.
* The app learns how to help the parent connect better next time.

The app should help the parent know the child more deeply while always leaving the child free to keep becoming.

This matters because the product's value begins before a memory is saved. Better questions create better conversations. Better conversations create better memories. Better memories create more meaningful reflection later.

---

## Question Quality Philosophy

A magical question in this app is not simply clever, profound, or personalized. It is askable in a real parent-child moment and generous toward the child.

A strong question may be:

* Personal.
* Open-ended.
* Age-aware.
* Emotionally safe.
* Askable out loud.
* Playful or imaginative.
* Thought-provoking.
* Memory-preserving.
* Relationship-deepening.
* Specific enough to spark conversation.
* Gentle enough not to pressure the child.

Guiding example:

A parent asked his daughter:

"How is it to have a father like me?"

The child talked for 30 minutes.

This worked because:

* It was relational.
* It gave the child authority.
* It invited honesty.
* It was open-ended.
* It treated the child's perspective as valuable.
* It created space for stories.

This is a deep question. It should be used rarely, not daily. Its power comes partly from restraint. If every prompt asks for vulnerability, the product starts to feel heavy, performative, or exhausting.

---

## Question Families

Question families help the product maintain variety, emotional rhythm, and editorial intent. A family is not a parent-facing taxonomy by default; it is an internal design shape for prompt creation, selection, review, and future AI candidate generation.

### Relationship Mirror Questions

Questions that help the child reflect on the parent-child relationship.

Examples:

* What is it like having me as your dad?
* When do you feel like I really understand you?
* What is something about you that you think I sometimes miss?
* What is one memory with me that you hope we never forget?

Use with restraint. These questions can create powerful conversations, but they ask for relational honesty and should not dominate the daily ritual.

### Inner World Questions

Questions that help the parent understand the child's lived experience.

Examples:

* What is something grown-ups don't understand about being your age?
* What is something you think about a lot but don't usually say?
* What part of your day feels most like the real you?

These questions should make space for the child's perspective without turning the child into a subject being analyzed.

### Imagination Doorway Questions

Questions that create wonder, play, and children's-book-like magic.

Examples:

* If your mind had a secret room, what would be inside?
* If your bedroom had a magical door, where would it lead?
* If your feelings were weather today, what kind of sky would it be?

These questions help the app stay playful and childlike. They can become meaningful without demanding seriousness.

### Memory-Preserving Questions

Questions that create heirloom value.

Examples:

* What is something about your life right now that you might miss someday?
* What should I remember about you at this age?
* What is one small thing from today that future-you might want to remember?

These questions should help preserve childhood in the child's own words.

### Becoming Questions

Questions that help parents notice growth without labeling the child.

Examples:

* What is something you're starting to care about more than you used to?
* What is something you want to be brave enough to try?
* What kind of person do you hope you are becoming?

These questions should avoid fixed identity claims. They should invite the child to narrate growth, not be defined by the app.

### Silly-to-Deep Questions

Questions that start playful but can become meaningful.

Examples:

* If your family was a team of superheroes, what would everyone's power be?
* If today had a title like a book chapter, what would it be?
* If your week was a flavor, what would it taste like?

These are especially valuable because they keep the ritual light while still creating a doorway into stories, feelings, and meaning.

---

## Question Depth And Rhythm

Question depth should be designed intentionally.

Light:

Fun, easy, silly, low emotional demand.

Medium:

Reflective, story-based, memory-building.

Deep:

Identity, relationship, vulnerability, meaning, legacy.

Recommended healthy rhythm:

* 70% light, fun, or curious.
* 20% reflective or memory-building.
* 10% deep or relationship-opening.

Principles:

* Not every question should be profound.
* Deep questions are powerful because they are rare.
* Too many heavy questions can make the app feel exhausting.
* Restraint is part of the magic.

The product should protect ordinary, playful, low-pressure conversation. A child who only receives meaningful questions may start to feel observed instead of invited.

---

## First-Session Personalization

Recommended concept:

First Question Setup

Goal:

Make the first question feel slightly personal without turning signup into an assessment.

Preferred framing:

"Help us choose a first question your child might enjoy."

Avoid:

* "Tell us who your child is."
* "Describe your child's personality."
* "What are your child's challenges?"

Suggested optional inputs:

* Child nickname/name.
* Age or birthday.
* Recent interests.
* Preferred first-question style.
* Preferred depth.
* Optional topic parent would love to hear more about.

Example prompt:

What kind of question might your child enjoy today?

Example choices:

* Something playful.
* Something imaginative.
* Something about their day.
* Something about family.
* Something thoughtful.
* Surprise me.

Example depth prompt:

How deep should the first question feel?

Example choices:

* Light and fun.
* A little thoughtful.
* Something meaningful.

Example free text prompt:

What has your child been into lately?

Example free text answers:

drawing, animals, Minecraft, baking, soccer, architecture, music

Important:

This should collect conversation preferences, not a child profile. It should be optional and skippable. The setup should help the app choose a good first question, not invite the parent to summarize, evaluate, diagnose, or define the child.

---

## Living Understanding, Not Labels

The app should build an evolving understanding of the child, but not a labeling profile.

Avoid:

* Gianna is anxious.
* Gianna is sensitive.
* Gianna is creative.
* Gianna avoids conflict.
* Gianna needs X.

Prefer:

* Gianna often lights up when talking about designing things.
* Recent conversations have included architecture, fairness, friendships, and independence.
* Relationship questions with Dad have opened longer conversations.
* A good next question might invite her perspective without putting her on the spot.

Core principles:

* Observe, don't label.
* Reflect, don't diagnose.
* Suggest, don't prescribe.
* Remember, don't define.

Possible names:

* Living Portrait.
* Living Understanding.
* Conversation Portrait.
* What We're Learning.
* Memory Map.

Recommended product concept:

Living Portrait

Definition:

A parent-reviewed, evolving memory-based portrait of what the child has shared and what helps the parent connect with them.

The Living Portrait should be humble, editable, and corrigible. It should not be a personality profile, scorecard, behavioral record, school readiness profile, or clinical summary.

---

## Architecture Layers

Conversation intelligence should develop as layered product capability. Each layer should remain useful without requiring the next layer to exist.

### Memory Layer

Source-of-truth artifacts:

* Saved text memories.
* Saved voice memories.
* Prompt snapshots.
* Dates.
* Child ownership.

The Memory Layer preserves what the parent captured. It is the canonical record. Future AI, summaries, portraits, and letters are derivative and must never overwrite the original memory.

### Conversation Signal Layer

Lightweight signals that help the system understand conversations without labeling the child:

* Prompt category.
* Age band.
* Question depth.
* Parent chose another.
* Memory saved.
* Voice included.
* Optional parent debrief.
* Response length/presence.
* Open loops.
* Question types that seem to lead to richer conversations.

Signals should be operational and humble. They should help the product choose better questions and support continuity, not create hidden judgments about the child or parent.

### Living Understanding Layer

Parent-reviewed synthesis:

* Recurring interests.
* Meaningful themes.
* Relationship moments.
* Questions that seem to open conversation.
* Things to revisit.
* Parent notes.
* Humble observations.

This layer should be reviewable by the parent and correctable over time. It should speak in observations, not conclusions.

### Question Engine

Uses:

* Age.
* Prompt history.
* Conversation signals.
* Living understanding.
* Question family.
* Depth rhythm.
* Conversation goal.

Outputs:

* Selected daily question.
* Follow-up question.
* AI-assisted adapted question later.
* Fallback curated question.

The Question Engine should keep the main ritual simple. The parent should see one thoughtful question, not a configuration panel or prompt marketplace.

### Parent Reflection Coach

Future optional layer:

* Post-session reflection.
* Gentle communication suggestions.
* Never scores.
* Never shames.
* Never diagnoses.

This layer should help the parent notice and try small relational moves. It should not grade parenting, assess the child, or replace the parent's judgment.

---

## Parent Debrief And Coaching Direction

Future concept:

After saving a memory, the parent may optionally answer:

"How did the conversation feel?"

Options:

* Easy and natural.
* Short but meaningful.
* Hard to get started.
* They didn't want to talk much.
* It surprised me.

Optional note:

"Anything you noticed?"

Future coaching could suggest:

* How to follow up.
* How to respond when the child gives short answers.
* How to make space without pressure.
* How to ask a softer version.
* How to listen with curiosity.

This should be framed as reflection, not evaluation.

Avoid:

* Parenting scores.
* Communication grades.
* "You did this wrong."
* Clinical advice.
* Therapy language.
* Claims about what the child needs.

Preferred framing:

"A small thing to try next time..."

The debrief should remain optional. A parent should be able to save a memory and leave without completing another task.

---

## AI Role

AI should be a craft assistant inside the product's editorial system.

AI should not be the unrestricted source of truth.

AI may eventually:

* Generate candidate questions.
* Adapt approved question patterns.
* Rewrite for age band.
* Suggest playful variants.
* Evaluate prompts against the question quality rubric.
* Propose gentle follow-ups from safe context.
* Help synthesize a Living Portrait with parent review.

AI should not:

* Diagnose.
* Label.
* Score.
* Claim certainty about the child.
* Analyze raw voice.
* Use unreviewed transcripts.
* Generate fully autonomous prompts without safeguards.
* Speak directly to the child.
* Replace the parent's attention.

Recommended pattern:

1. The app determines constraints.
2. AI creates candidates.
3. The app validates.
4. The parent remains in control.
5. Fallback always exists.

AI output should be draft-like, reviewable, and bounded to specific product flows. The original memory, parent notes, and parent choices remain more authoritative than generated synthesis.

---

## Question Quality Rubric

The rubric is internal only. Do not expose scores to parents.

Internal quality dimensions:

* Age fit.
* Askability aloud.
* Warmth.
* Specificity.
* Openness.
* Conversation potential.
* Memory potential.
* Playfulness.
* Emotional safety.
* Novelty.
* Non-clinical tone.
* Not too intense.
* Not too generic.
* Relationship sensitivity.

The rubric should support human curation, deterministic validation, and future AI-assisted candidate review. It should not imply that conversation quality can be fully scored, optimized, or automated.

---

## User Flow Shape

Desired future parent flow:

1. Parent creates child.
2. Optional First Question Setup.
3. App presents one thoughtful first question.
4. Parent asks the question.
5. Parent captures text and/or voice.
6. Parent optionally debriefs.
7. App preserves the memory.
8. Over time, the app builds a Living Portrait.
9. Future questions improve through memory, rhythm, and parent feedback.

Main ritual flow should stay simple:

child home -> one selected question -> capture -> save memory -> archive

Do not turn the product into:

* Prompt browsing.
* Dashboard management.
* AI configuration.
* A parent homework system.
* A child analysis surface.

---

## Guardrails

This architecture must avoid:

* Child labels.
* Personality profiles stated as fact.
* Emotional scoring.
* Behavior scoring.
* Developmental claims.
* Diagnosis.
* Therapy advice.
* Parent shaming.
* Surveillance language.
* Dashboards.
* Gamification.
* Streaks.
* Badges.
* Child-facing AI chat.
* Full archive analysis by default.
* Raw voice analysis.
* Unreviewed transcript use.
* AI claims that sound certain.

Language should remain gentle, specific, and non-clinical. The app may help parents notice, remember, and prepare for better conversations. It must not tell families what the child is, what the parent is doing wrong, or what the child needs as if the app knows.

---

## Connection To Future Stage Briefs

This document should guide future briefs such as:

* Stage 8: Question Philosophy, Metadata, and Quality Rubric.
* Stage 9: First Question Setup.
* Stage 10: Conversation Signals and Parent Debrief.
* Stage 11: Living Portrait Foundation.
* Stage 12: AI-Assisted Question Candidate Generation.
* Stage 13: Parent Reflection Coach.
* Stage 14: Parent-Reviewed AI Summaries.
* Stage 15: Monthly Reflection Letter.

The exact numbering can change. Future briefs should refer back to this architecture and reconcile any differences explicitly.

If a future brief introduces a durable AI provider behavior, generated prompt storage model, transcript eligibility policy, derived understanding model, deletion/export rule, or parent-review workflow, it should also consider whether a decision record is needed.

---

## Open Questions

Unresolved product decisions:

* What should the Living Portrait be called?
* How much first-session data should be collected?
* Should parent debrief happen immediately after save or later?
* What signals should be stored before AI exists?
* When should AI-generated questions be allowed into the parent experience?
* Should AI-generated questions require human/admin review first?
* How should parents edit or correct the Living Portrait?
* How should deletion/export apply to derived understanding?
* How should voice recordings and transcripts become eligible for understanding later?
* Should coaching be post-MVP only?

These questions require product approval before the corresponding feature briefs move into implementation.
