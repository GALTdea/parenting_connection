# Product Principles

This app should help parents build a quiet ritual of connection, preserve meaningful memories, and notice who their children are becoming over time.

The product should feel private, gentle, and human. It should not feel like a dashboard, assessment tool, productivity system, or authority over the parent-child relationship.

## North Star

Every meaningful product change should support at least one part of the product formula:

- Conversation
- Connection
- Understanding
- Memory
- Legacy

If a feature does not clearly support one of these, it should be challenged, postponed, or removed.

## Product Shape

Prefer features that make it easier for a parent to:

- Start a meaningful conversation
- Capture a child response with low friction
- Revisit memories in context
- Notice gentle patterns over time
- Preserve a private family archive

Avoid features that push the product toward:

- Parenting scores
- Child scores, labels, rankings, or profiles
- Clinical, educational, or behavioral assessment
- Productivity tracking
- Social sharing
- Generic AI chat
- Administrative complexity that does not protect privacy, trust, or memory quality

## Product Voice

The voice should be warm, calm, and respectful. It should treat the parent as capable and the child as a whole person, not as a data source to optimize.

Use language that feels:

- Gentle
- Clear
- Specific
- Non-clinical
- Non-judgmental
- Parent-centered

Avoid language that sounds:

- Diagnostic
- Certain about a child's inner state
- Comparative
- Alarmist
- Optimizing
- Performative

## Privacy And Trust

Privacy is part of the product value, not a background implementation detail.

Product work should:

- Collect the minimum useful child data
- Keep child profiles and memories private by default
- Preserve original parent-authored memories as the source of truth
- Make parent review and control obvious before saving, sending, or sharing generated content
- Avoid public sharing, public links, or multi-household access until explicitly designed
- Treat voice recordings, transcripts, prompts, and generated summaries as sensitive child data

## AI Product Boundary

AI may support reflection, memory preservation, and parent noticing. It must not become an authority over the child, the parent, or the relationship.

At the product level:

- AI output is always secondary to original memories.
- AI output should be framed as draft reflection, not fact.
- Parents must review AI-assisted content before it is saved, sent, or shared.
- AI should operate only inside specific product features.
- The product should remain useful when AI is unavailable.

For AI implementation details, use `docs/architecture/ai-architecture.md`.

## MVP Bias

During the MVP, prefer the smallest product slice that proves the core ritual:

1. Parent signs in.
2. Parent creates or selects a child profile.
3. Parent captures a meaningful response.
4. The response becomes part of a private timeline.
5. Parent can revisit the archive.
6. AI may later help draft gentle reflections for parent review.

Build the non-AI version of a core feature before layering AI onto it.

## Design And Interaction

Authenticated product surfaces should feel quiet, task-focused, and mobile-friendly.

Prefer:

- Short flows
- Clear forms
- Touch-friendly controls
- Predictable navigation
- Server-rendered Rails and Hotwire-compatible interactions
- Interfaces that help parents capture and revisit memories quickly

Avoid:

- Marketing-style layouts inside authenticated flows
- Desktop-only interactions
- Hover-required controls
- Dense dashboards
- Graphs, rankings, or visualizations that imply evaluation

## Decision Filter

Before shipping meaningful product work, ask:

- Does this support conversation, connection, understanding, memory, or legacy?
- Does this keep the parent in control?
- Does this avoid scoring, diagnosing, labeling, or ranking?
- Does this collect only the child data the feature truly needs?
- Does this preserve the original memory?
- Does this keep the MVP loop simpler rather than broader?
