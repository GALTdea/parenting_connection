# Handoff Checklist

Every AI-assisted task should leave a clear trail, but the trail should match the risk tier. Use this guidance in final summaries, pull request notes, or feature brief updates.

## Fast Path Handoff

For low-risk fast-path work, keep the handoff concise:

- What changed
- Files changed
- Checks run
- Known risks or follow-ups, if any

If the task did not change product behavior, child data, AI behavior, privacy expectations, authorization, or navigation, do not force the full product and privacy checklist.

## Standard And High-Risk Handoff

For standard-path and high-risk-path work, include the full trail:

- What changed
- Why it changed
- Product promise supported
- Tests/checks run
- AI/privacy risks considered
- Docs updated: yes or no
- Known risks or follow-ups

## Product Promise

For standard-path and high-risk-path product work, name how the change supports at least one part of the product formula:

- Conversation
- Connection
- Understanding
- Memory
- Legacy

If a meaningful product change does not support one of these, it probably needs more product definition before implementation.

## Verification Notes

Be specific about what ran:

- Exact test command
- Exact lint command
- Manual checks
- Checks not run and why

## AI And Privacy Notes

For AI or child-data work, include:

- Whether child data was added, changed, sent, logged, or retained
- Whether AI output is parent-reviewed
- Whether language remains gentle, non-clinical, and non-diagnostic
- Any unresolved deletion, export, storage, or provider questions
