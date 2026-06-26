# Use Active Storage For Stage 4 Voice Recordings

## Status

Accepted.

## Date

2026-06-25

## Context

Stage 4 introduces original voice recordings as sensitive child memory data. The app needs a Rails-first way to attach private audio files to existing child-scoped memories without introducing transcription, AI processing, public sharing, or a generalized timeline artifact model.

The current app already uses Rails conventions, has Active Storage services configured by environment, and stores text memories in `MemoryResponse`.

## Decision

Use Active Storage to attach one original audio file to each `MemoryResponse` with a `voice_recording` attachment.

Keep recording ownership and authorization anchored to the existing parent-owned `ChildProfile` and child-scoped `MemoryResponse` routes.

Use local Active Storage for development and test. Before voice recordings ship publicly in production, configure durable S3-compatible object storage through the Active Storage abstraction.

Serve voice recording playback through an authenticated, child-scoped application route that authorizes the owning `MemoryResponse` before exposing the attachment.

Do not use default public or broadly reusable Active Storage blob URLs for sensitive child voice recordings.

Stage 4 supports memory-level deletion only. Individual recording deletion, export, retention, editing, transcript deletion, and derived artifact cleanup should be handled in a later dedicated brief.

Do not introduce a dedicated `VoiceRecording` model, transcript table, or generalized memory artifact model in Stage 4.

## Consequences

This keeps the implementation small, conventional, and close to the existing archive model. Text-only memories remain valid, and voice playback can be added to the existing private detail view.

Active Storage blob URLs and serving behavior need careful implementation because recordings must not become public, broadly reusable, or accessible outside the authenticated memory flow.

Attachment cleanup should follow existing `MemoryResponse` and `ChildProfile` dependent cleanup, but formal export, retention, individual recording deletion, editing, transcript deletion, and derived artifact cleanup remain unresolved.

Production S3-compatible object storage must be configured before shipping real voice recordings publicly. Local storage is acceptable for development and test, but public production use should not rely on app-local disk storage for sensitive family audio archives.

## Alternatives Considered

Dedicated `VoiceRecording` model:

Useful once recordings need independent lifecycle, transcript state, processing jobs, replacement history, or multiple clips. It is larger than needed for one original recording attached to one memory.

Generalized `MemoryArtifact` model:

May become useful when text, voice, transcript, photos, AI summaries, and reflection artifacts need a shared abstraction. Stage 4 does not yet need that complexity.

External audio service:

Unnecessary for the MVP slice and would introduce third-party child data exposure before transcription or processing has been designed.

## Follow-Ups

* Confirm the Stage 4 brief before implementation.
* Enforce recordings of up to 15 minutes.
* Enforce an initial 100 MB file size limit unless implementation testing shows a lower limit is safer.
* Verify authenticated child-scoped playback serving does not bypass parent authorization.
* Choose and configure production S3-compatible object storage before launch with real user recordings.
* Create a later deletion/export/editing brief before promising individual recording deletion, export, retention, transcript deletion, or derived artifact cleanup.
