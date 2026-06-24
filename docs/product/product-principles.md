AI Architecture

AI in this app should support reflection, memory preservation, and parent noticing. It should not become an authority over the child, the parent, or the relationship.

AI should feel like a quiet assistant helping parents revisit what they have already captured, not like a system evaluating the family.

Core Principle

Original memories are the source of truth.

AI-generated content is always secondary, always reviewable, and never treated as objective fact.

The app should preserve what the parent captured before preserving what AI interpreted.

AI Responsibilities

MVP AI may help with:

* Basic summaries of saved memories
* Gentle theme extraction across parent-authored entries
* Monthly reflection letter drafts
* Memory resurfacing prompts
* Suggested titles or short descriptions for memories
* Light organization of existing memories

AI should operate only inside specific product features. Do not add general-purpose AI chat, open-ended advice, or always-on AI behavior during MVP.

AI Boundaries

AI must not:

* Diagnose children
* Diagnose parents
* Score parenting
* Score child behavior
* Rank, rate, or compare children
* Predict developmental outcomes
* Present clinical, medical, educational, or behavioral advice
* Recommend interventions
* Replace parent judgment
* Publish, send, or share content without parent review
* Create permanent claims about a child without parent approval
* Present interpretations as certainty

Parent Review Model

AI-generated content should be treated as a draft until the parent reviews it.

The app should preserve:

* Original parent text
* Original voice recording, if stored
* Transcript, if created
* AI-generated draft
* Parent-approved final text, if different
* Review status
* Prompt version used
* Timestamp of generation
* Timestamp of parent approval, edit, or discard

Recommended AI output statuses:

* draft
* reviewed
* approved
* edited
* discarded
* failed

AI should never overwrite original parent-authored memory content. If AI creates a summary, title, letter, or reflection, it should be stored separately from the original memory.

The exact data model should be decided in the relevant feature brief before implementation.

Feature-Scoped AI

Each AI feature should define:

* User-facing purpose
* Input data required
* Output generated
* Storage behavior
* Review flow
* Failure behavior
* Privacy notes
* Prompt version
* Tests or acceptance criteria

Do not implement AI calls until the relevant feature brief and privacy notes are written.

Prompt And Output Style

Prompts should require:

* Warm, gentle language
* Non-clinical framing
* Uncertainty when interpreting patterns
* Respect for family context
* No diagnosis or labels
* No claims beyond the supplied memories
* No advice framed as instruction
* No emotional certainty
* No child personality labeling

Outputs should prefer:

* “A theme you might notice…”
* “This memory may be worth preserving because…”
* “Across these entries, one gentle pattern is…”
* “You may want to revisit…”
* “This could be a meaningful moment because…”

Outputs should avoid:

* “Your child is…”
* “This means…”
* “This indicates…”
* “You should…”
* “Concern detected…”
* “Your parenting style…”
* “Your child’s personality is…”
* “This behavior shows…”

Privacy Requirements

Before sending data to an AI provider, document:

* Which data is sent
* Why the feature needs it
* Whether recordings are included
* Whether transcripts are included
* Whether child names are included
* Whether generated output is stored
* How parents can review, edit, or delete it
* What failure behavior looks like
* Whether the provider stores or trains on submitted data
* Whether the feature can work with less data

Prefer sending the minimum necessary data for the specific feature.

Voice recordings should not be sent to an AI provider unless the feature explicitly requires transcription or voice processing and the parent has clearly initiated that action.

Data Minimization

AI requests should use the smallest useful context.

Prefer:

* Selected memories over the entire archive
* Transcripts over raw audio when possible
* Parent-approved content over drafts
* Recent relevant entries over all entries
* Summaries over full raw history when appropriate

Avoid sending unnecessary child profile details.

Failure Behavior

AI failures should be quiet and recoverable.

A parent should never lose access to original memories because summarization, transcription, theme extraction, or letter generation failed.

When AI fails:

* Preserve the original memory
* Show a simple non-alarming message
* Allow retry when appropriate
* Do not block the parent’s core capture flow
* Log enough technical detail for debugging without exposing unnecessary child data

MVP AI Implementation Rule

For MVP, AI should be implemented only after the non-AI version of the core feature works.

Example:

* Save memory first.
* Review timeline first.
* Generate reflection draft second.

The product should remain useful even if AI is temporarily unavailable.