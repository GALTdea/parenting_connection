# Mobile Strategy

The MVP should be built as a Rails + Hotwire web app with a clear path to Hotwire Native iOS and Android wrappers.

## Direction

- Build responsive Rails views first.
- Use Turbo navigation and frames where they improve flow.
- Use Stimulus for focused client-side interactions.
- Keep screens compatible with eventual native navigation patterns.
- Defer native wrapper implementation until the core MVP loop is proven.

## Mobile Product Context

Parents may use the app in short, interrupted moments. The mobile experience should make it easy to:

- Open the app quickly.
- Pick a child profile.
- Answer a daily question.
- Record a thought or voice note.
- Revisit recent memories.

## Hotwire Native Compatibility

To preserve the wrapper path:

- Avoid SPA-only routing assumptions.
- Keep URLs meaningful.
- Prefer server-rendered screens.
- Avoid hover-only UI.
- Keep forms simple and resilient.
- Design navigation that can map to native tabs or stacks later.

## Voice Recording Considerations

Voice recordings are part of the MVP, but implementation needs a dedicated brief because recordings affect:

- Browser and native permissions
- Storage
- Playback
- Transcription
- Privacy
- Deletion
- Offline or interrupted recording behavior

Do not implement recording until those constraints are documented.

## Mobile Verification

For user-facing flows:

- Check common phone viewport widths.
- Confirm touch targets are comfortable.
- Confirm form errors are visible without layout breakage.
- Confirm primary actions remain obvious.
- Confirm the flow does not depend on desktop hover behavior.
