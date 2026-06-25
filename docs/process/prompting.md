# Prompting Standards

Use this file when asking Codex, Cursor, ChatGPT, Claude, Gemini, or another AI tool to work in this repo.

## Core Standard

Do not ask AI to build broad features from chat context alone.

Instead, prompt AI to:

- Read the required durable docs.
- Use the selected risk tier and standing constraints.
- Follow the relevant feature brief.
- Challenge scope before implementation.
- Implement only the next slice.
- Add or update tests appropriate to the change.
- Run targeted verification.
- Update docs only when decisions or durable plans changed.
- Stop before implementing unrelated features.

## Good Prompt Shape

```text
Read docs/AGENTS.md and follow its required reading order for the selected risk tier and change.

If this starts a new stage or new feature brief, draft or update the brief first, summarize it, and stop for my review before implementation.

After I approve the brief, implement only the next slice described in it.

Before coding, challenge the scope: can this be smaller, simpler, postponed, or removed?

Apply the standing constraints in docs/features/_constraints.md.
Do not introduce AI behavior unless the feature brief explicitly calls for it.
Do not add unrelated models, controllers, migrations, jobs, or UI flows.

Add/update focused tests, run targeted verification, and update docs only if durable decisions changed.
End with a handoff summary using docs/process/handoff.md.
```

## Avoid

Avoid prompts like:

- "Build child profiles."
- "Add the AI summary system."
- "Create the whole memory archive."
- "Make it more personalized."
- "Improve the dashboard."

These are too broad. They invite scope creep and make it too easy to bypass product safety, privacy, and parent-review constraints.

## Better

Prefer prompts like:

- "Implement the Stage 1 child profile creation slice from the active feature brief."
- "Add validations and request specs for parent-owned child profiles only."
- "Draft a feature brief for voice recordings. Do not implement recording yet."
- "Review whether this proposed AI summary flow preserves parent review and avoids diagnostic language."
