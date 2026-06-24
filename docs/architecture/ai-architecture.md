# AI Architecture

AI in this app should support reflection and memory preservation. It should not become an authority over the child, the parent, or the relationship.

## AI Responsibilities

MVP AI may eventually help with:

- Basic summaries of saved memories
- Gentle theme extraction across parent-authored entries
- Monthly reflection letter drafts
- Memory resurfacing prompts

## AI Boundaries

AI must not:

- Diagnose children
- Diagnose parents
- Score parenting
- Score child behavior
- Predict developmental outcomes
- Present clinical or medical advice
- Replace parent judgment
- Publish, send, or share content without parent review

## Parent Review Model

AI-generated content should be treated as a draft until the parent reviews it.

The app should preserve:

- Original parent text
- Original voice recording, if stored
- Transcript, if created
- AI-generated draft
- Parent-approved final text, if different

The exact data model should be decided in the relevant feature brief before implementation.

## Prompt And Output Style

Prompts should require:

- Warm, gentle language
- Non-clinical framing
- Uncertainty when interpreting patterns
- Respect for family context
- No diagnosis or labels
- No claims beyond the supplied memories

Outputs should prefer:

- "A theme you might notice..."
- "This memory may be worth preserving because..."
- "Across these entries, one gentle pattern is..."

Outputs should avoid:

- "Your child is..."
- "This means..."
- "This indicates..."
- "You should..."
- "Concern detected..."

## Privacy Requirements

Before sending data to an AI provider, document:

- Which data is sent
- Why the feature needs it
- Whether recordings or transcripts are included
- Whether generated output is stored
- How parents can review or delete it
- What failure behavior looks like

Do not implement AI calls until the relevant feature brief and privacy notes are written.

## Failure Behavior

AI failures should be quiet and recoverable. A parent should never lose access to original memories because summarization or letter generation failed.
