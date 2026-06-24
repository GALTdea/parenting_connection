# Handoff Checklist

Every AI-assisted task should leave a clear trail. Use this checklist in final summaries, pull request notes, or feature brief updates.

## Required Summary

- What changed
- Why it changed
- Product promise supported
- Tests/checks run
- AI/privacy risks considered
- Docs updated: yes or no
- Known risks or follow-ups

## Product Promise

Name how the change supports at least one part of the product formula:

- Conversation
- Connection
- Understanding
- Memory
- Legacy

If a change does not support one of these, it probably needs more product definition before implementation.

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
