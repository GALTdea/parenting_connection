# Data Model Direction

This document captures intended data model direction before implementation. It is not a migration plan by itself.

## Current Foundation

The starter Rails app already includes a Devise-backed `User` model and related account infrastructure. Stage 1 should use that foundation unless implementation discovery shows a clear need for a separate account or household boundary first.

## MVP Domain Concepts

Expected MVP concepts:

- Parent account
- Child profile
- Daily question
- Memory response
- Text response
- Voice recording
- Timeline item
- Memory archive entry
- AI summary
- Monthly reflection letter

## Likely Ownership Shape

Initial direction:

- A parent account owns child profiles.
- Child profiles own memories and responses.
- AI summaries and monthly reflection letters are derived from parent-reviewed memory content.

Potential later direction:

- Introduce a household/account container if co-parenting, invitations, shared billing, or multi-adult access becomes important.

Do not introduce the household abstraction until a feature brief requires it or Stage 1 implementation analysis proves it is necessary.

## Child Data Principles

- Store only what the product needs.
- Keep child profiles private by default.
- Keep original memories available independent of generated summaries.
- Treat voice recordings and transcripts as sensitive child data.
- Avoid using child data in logs, analytics payloads, or broad third-party calls.

## Open Data Model Questions

- Should `User` be renamed conceptually as parent, or should naming stay generic for future guardians and caregivers?
- Should birth date be stored, or is approximate age enough for MVP prompts?
- What deletion guarantees should apply to child profiles, memories, recordings, transcripts, and AI summaries?
- How should generated summaries reference source memories for review and correction?
