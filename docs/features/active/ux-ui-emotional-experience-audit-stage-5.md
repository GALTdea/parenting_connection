# UX/UI & Emotional Experience Audit - Stage 5

Status

Audit complete. Stage 5A implemented. Stage 5B approved and in implementation.

Audit date: June 26, 2026

Risk tier

Standard path for audit documentation. Follow-up implementation may become high-risk if it changes voice recording, authorization, privacy, or child data handling.

---

## Executive Summary

The current application proves the non-AI memory loop at a functional level: a parent can sign up, sign in, create a child profile, answer a question, save a memory, revisit the archive, open an individual memory, and see voice-memory cues and playback surfaces.

Emotionally, the product is not yet consistently delivering the promise:

Conversation -> Connection -> Understanding -> Memory -> Legacy

The strongest product moments are inside the memory content itself, especially the capture form, empty archive copy, archive grouping, and individual memory page. Those screens are close to the intended experience.

The surrounding shell still feels like an MVP CRUD application and Rails starter template. Public landing, authentication, profile/settings, navigation, account menu, flash messages, and profile pages repeatedly use administrative or starter-SaaS language. On mobile, the parent reaches profile management before the daily ritual, and the first-screen hierarchy often says "manage a child record" before it says "connect with your child."

Overall impression: the app has the right product foundation, but the emotional experience is currently interrupted by generic starter surfaces, transactional copy, and ritual flow friction. The next best work is not a redesign. It is a focused product-alignment pass that removes starter residue, makes the daily question the primary path, and turns save/empty/return moments into gentle relationship cues.

---

## Audit Method

Durable docs reviewed:

- `docs/AGENTS.md`
- `docs/process/ai-dev-flow.md`
- `docs/product/strategy-2026.md`
- `docs/product/mvp-product-goal.md`
- `docs/product/product-principles.md`
- `docs/features/_constraints.md`
- `docs/architecture/mobile-strategy.md`
- Stage 1, 2, 3 completed briefs
- Stage 4 active voice-recordings brief

Manual/browser walkthrough:

- Local Rails app launched on `http://127.0.0.1:3003`
- Browser viewport set to 390 x 844 for primary mobile evaluation
- Demo parent: `audit.parent@example.com`
- Demo children: Leo with saved memories, Nina with an empty archive
- A new parent account was also created through sign-up to evaluate first-time state
- A local sample audio fixture was attached to one demo memory to inspect voice archive/detail surfaces

Verification limitations:

- Actual microphone recording was not completed because accepting browser microphone permission requires explicit user approval at action time.
- Real iOS Safari and Android Chrome were not checked in this pass.
- Browser automation intermittently timed out while reading pages, but server logs and follow-up reconnects confirmed the relevant pages loaded.
- Stage 4 already documents that browser recording and cross-browser playback remain release-verification gaps.

---

## Flow Evaluation

### Public Entry

Current state:

The root page is still the Rails starter landing page. It says "My Rails Starter," "Sample landing page for your next Rails app," "Batteries included," "Example pricing," and includes starter docs/blog/pricing/footer links.

Emotional assessment:

This is the largest product-promise break. Before a parent reaches the private memory loop, the product presents as a generic SaaS template. It does not feel calm, private, relationship-centered, or worthy of storing child memories.

Recommended direction:

Replace the starter landing page with a minimal product entry surface. It does not need a marketing redesign. It should simply name the product, explain the private daily conversation ritual, and provide sign-in/sign-up paths.

### Parent Sign Up

Current state:

The sign-up form is short and functional. It asks only for email and password, then lands on the child profile list.

Emotional assessment:

The flow is low-friction, but generic. The Devise layout still says "My Rails Starter," the heading says "Create new account," and there is no reassurance about privacy or why the parent is starting. Because first and last name are not collected, the account avatar/menu can appear blank for a new user.

Recommended direction:

Keep the form short. Update the layout branding and copy. Consider collecting parent first name only, or gracefully handling blank names in the avatar/menu. Add one small line of context after sign-up: "Start by adding the child whose moments you want to remember."

### Parent Sign In

Current state:

Sign-in works. Labels are visually present, but browser accessibility lookup did not find the email/password labels; placeholders were needed for automation. The page still uses "My Rails Starter" and "Login to your account."

Emotional assessment:

Functional, but not especially warm or trustworthy. It feels like entering an app account, not returning to a family ritual.

Recommended direction:

Use product branding, accessible labels, and softer copy such as "Welcome back" with a short private-memory reassurance.

### First-Time Onboarding

Current state:

There is no dedicated onboarding. After sign-up, the parent sees "Your children," "Add child," and an empty state: "Start with just a name or nickname and birthday."

Emotional assessment:

This is simple, which is good. It does not yet explain the ritual or reduce uncertainty about child data. The parent may wonder why birthday is required.

Recommended direction:

Keep this as a lightweight first screen, not a wizard. Add a single orientation block: private, one child, one question, one memory. Explain that nickname and birthday help organize the child's private memory record.

### Creating The First Child

Current state:

The form is quick and mobile-usable. Validation works and preserves the form. Empty submission shows "Name can't be blank" and "Birthday can't be blank."

Emotional assessment:

Effortless, but administrative. The form title is "Add child" and the page pretitle is "Child profile," which reinforces record creation more than relationship.

Recommended direction:

Keep required fields minimal. Improve context and validation copy. For example, "Add a name or nickname" and "Add a birthday so memories can be organized by age."

### Viewing Today/Child Home

Current state:

Child profile pages show Edit/Remove first, then name/birthday details, then "Daily ritual" with "Recent memories," "Memory archive," and "Answer a question."

Emotional assessment:

This is the core mobile hierarchy issue. On a phone, the parent sees profile management before connection. The relationship content is present but below administrative controls. The product feels more like a profile record than a daily ritual.

Recommended direction:

Make the child's page a ritual home. Lead with the child name and a primary "Answer today's question" action. Move Edit/Remove into a lower-priority settings area or overflow. Birthday can be secondary context, not first-screen content.

### Answering Today's Question

Current state:

The capture form is clear and calm. It includes a question selector, response/note textarea, optional voice controls, date, cancel, and save. The question itself is not preselected or emotionally presented as "today's question."

Emotional assessment:

This is one of the best screens, but it starts with a choice task. Choosing from a dropdown adds cognitive load and weakens the daily ritual feeling.

Recommended direction:

Default to a single today's question while allowing "choose another" as a secondary action. Show the question as a warm prompt, not only as a select field.

### Recording A Voice Memory

Current state:

The form includes parent-initiated recording controls, stop disabled until recording, timer, permission-aware status text, preview audio, remove-before-save, and file-input fallback. A saved voice memory shows "Includes voice" in the archive and an audio control on the detail page using the child-scoped playback route.

Emotional assessment:

The intent is aligned. The copy avoids surveillance and keeps voice optional. The controls are understandable, but the file input is visually prominent even when browser recording is the main path, making the experience feel more technical.

Recommended direction:

After release verification, reduce fallback visual weight when MediaRecorder is available. Keep permission copy gentle. Preserve parent control. Add a more emotionally rewarding saved-state cue for voice memories.

### Saving A Text Memory

Current state:

Saving redirects to the child profile and flashes "Response was saved." The new memory appears in recent memories.

Emotional assessment:

The mechanical outcome is correct. The emotional reward is underplayed. This is an important moment: the parent has preserved something meaningful, but the app responds like a database form.

Recommended direction:

Use a warmer confirmation such as "Saved to Leo's memory archive." Consider a small return cue: "Come back tomorrow for another question."

### Viewing The Timeline/Archive

Current state:

Archive entries are grouped by month, show dates, prompts, previews, "Read memory," and "Includes voice" when relevant.

Emotional assessment:

The archive is calm and readable. It feels closer to a memory record than a dashboard. The heading "saved responses" is less warm than "memories," and entries could better preserve the feeling of rediscovery.

Recommended direction:

Rename "saved responses" to "memory archive" or "memories." Keep chronological grouping. Avoid counts, streaks, filters, or analytics until clearly needed.

### Opening An Individual Memory

Current state:

The detail page is focused: prompt, date, optional audio playback, response text, "Capture another," and links back to profile/archive.

Emotional assessment:

This screen is strong. It avoids clutter and gives the memory space. It could add subtle emotional closure after capture without becoming performative.

Recommended direction:

Keep the page minimal. Consider a small memory-oriented label or confirmation state. Avoid overdecorating this screen.

### Switching Between Children

Current state:

Switching happens through the children list. There is no direct child switcher in the ritual flow.

Emotional assessment:

Works for MVP, but it feels like navigating records. For parents with multiple children, switching interrupts the daily ritual.

Recommended direction:

For now, improve the children list labels and make each child card lead with the ritual action. Defer a full child switcher until there is evidence it is needed.

### Empty States

Current state:

Empty archive/profile copy says the archive will grow one conversation at a time and invites the first memory.

Emotional assessment:

This is aligned and gentle. The empty state does not shame the parent or imply failure.

Recommended direction:

Keep this tone. Move it higher in the first child/profile experience so it is not buried under admin details.

### Validation Errors

Current state:

Errors preserve entered state and are visible. Some messages are technical, such as "Daily question must exist." Child form messages use model field names, such as "Name can't be blank."

Emotional assessment:

Functional but clinical/technical. Errors are moments where parents may already feel interrupted.

Recommended direction:

Use parent-facing language: "Choose a question" and "Add a written note or record a voice memory."

### Navigation

Current state:

Authenticated mobile navigation uses a drawer/sidebar pattern with "Children" and "Spaces." Breadcrumbs are visible in the top nav. Account menu includes Profile, Change password, Spaces, status, and Logout.

Emotional assessment:

Predictable, but shell-like. "Children" and "Spaces" make the app feel like a SaaS dashboard. The sidebar is not aligned with a daily ritual app yet.

Recommended direction:

Hide `Spaces` from parent MVP navigation. Rename or reframe "Children" around the memory ritual, such as "Family" or "Memories," if product language supports it. Keep navigation sparse.

### Settings

Current state:

The Profile menu link generated `/users/maya-rivera/edit`, but `UsersController#set_user` uses `User.find(params[:id])`, causing `ActiveRecord::RecordNotFound`. The underlying user settings form still contains Bootstrap/Tabler-era classes and "Details/Appearance" settings language.

Emotional assessment:

This is both a flow break and a trust break. A parent trying to manage their account hits a Rails error page.

Recommended direction:

Fix or remove the Profile link before broader UX polish. Then simplify account settings to the fields needed for this MVP.

### Logout

Current state:

Logout works, then returns the parent to the starter landing page with "Signed out successfully."

Emotional assessment:

Technically complete, emotionally abrupt. The exit point returns to an unrelated product promise.

Recommended direction:

Once the landing page is product-aligned, logout will feel acceptable. Consider warmer flash copy only after the landing page is fixed.

---

## Findings

### Critical

| Issue | User flow | Description | Why it matters | Suggested solution | Complexity | Impact |
| --- | --- | --- | --- | --- | --- | --- |
| Starter landing page breaks trust | Public entry, logout | Root page still presents "My Rails Starter," SaaS pricing, docs, blog, and developer copy. | This directly contradicts the product promise and makes the app feel unsafe for private child memories. | Replace with a minimal Parenting Connection landing page focused on private daily conversation ritual. | Medium | Very high |

### High

| Issue | User flow | Description | Why it matters | Suggested solution | Complexity | Impact |
| --- | --- | --- | --- | --- | --- | --- |
| Profile link crashes | Account menu, settings | User menu links to a friendly slug, but `UsersController` finds by numeric ID, causing `ActiveRecord::RecordNotFound`. | A settings crash damages trust and blocks account management. | Fix lookup/link behavior or remove Profile from menu until settings are product-ready. | Low | High |
| Starter/admin shell leaks into parent experience | Navigation, account menu, settings | `Spaces`, account status, empty spaces table, and starter settings are visible to parents. | The app feels like a generic SaaS/admin dashboard instead of a private family ritual. | Hide `Spaces` and non-MVP admin concepts from parent navigation and menus. | Low-Medium | High |
| Child profile page prioritizes administration over ritual | Child profile, returning parent | Edit/Remove and birthday details appear before the daily conversation action. | The relationship is visually secondary on the core screen. | Make the child page a ritual home with "Answer today's question" first; move profile management lower. | Medium | High |
| Today's question is not immediate | Capture flow | Parent must choose from a dropdown before capturing a memory. | Adds cognitive load and weakens the daily ritual. | Default to a daily question; make "choose another" secondary. | Medium | High |
| Voice recording not release-verified | Voice capture | Browser recording, permission denial, fallback upload, and mobile browser behavior remain documented Stage 4 gaps. | Voice is sensitive child data and a trust-heavy flow; unverified permission behavior can feel broken or alarming. | Complete Stage 4 manual release verification on target browsers before polishing voice UX. | Medium | High |

### Medium

| Issue | User flow | Description | Why it matters | Suggested solution | Complexity | Impact |
| --- | --- | --- | --- | --- | --- | --- |
| Auth pages are generic and not fully accessible | Sign in, sign up | Devise layout says "My Rails Starter"; labels are not reliably associated with fields in browser automation. | First trust moment feels generic; accessibility and autofill/focus behavior may suffer. | Rebrand Devise layout and ensure labels use proper `for`/input IDs or Rails label helpers. | Low | Medium-High |
| New sign-up can produce blank avatar/menu identity | Sign up, account menu | Sign-up does not collect name; menu can show a blank avatar and only "active." | Feels unfinished and impersonal immediately after account creation. | Handle blank names gracefully or ask for parent first name during onboarding. | Low | Medium |
| Success messages are transactional | Save memory, create child, logout | Flash copy says "Response was saved" and "Child profile was created." | Important emotional moments feel like CRUD operations. | Update flashes to memory-oriented, child-specific copy. | Low | Medium-High |
| Validation copy is technical | Capture, child form | "Daily question must exist" and "Name can't be blank" expose implementation language. | Errors add friction at sensitive moments. | Customize validation messages for parent-facing flows. | Low | Medium |
| Archive language says responses more than memories | Archive | "Leo's saved responses" frames memories as form answers. | Slightly weakens memory/legacy positioning. | Prefer "Leo's memory archive" or "Leo's memories." | Low | Medium |
| Child switching is record-list based | Multi-child use | Switching children requires returning to the children index and selecting View. | Works, but interrupts daily ritual flow for multi-child parents. | Improve child cards with ritual-first actions; defer full switcher. | Low-Medium | Medium |
| File input is prominent in voice recorder | Voice capture | Technical audio file upload is visually equal to recording controls. | Makes voice capture feel like file management. | When browser recording is available, reduce fallback prominence. | Medium | Medium |

### Low

| Issue | User flow | Description | Why it matters | Suggested solution | Complexity | Impact |
| --- | --- | --- | --- | --- | --- | --- |
| Birthday formatting has leading zero in some dates | Children list | Example: "September 03, 2021." | Small polish issue; dates feel less human. | Use a friendlier date format. | Low | Low |
| Generic buttons lack emotional specificity | Capture and archive | "Capture a response," "Answer a question," and "Read memory" are serviceable but uneven. | Consistent ritual language can reduce hesitation. | Standardize verbs around "today's question," "save memory," and "open memory." | Low | Medium |
| Mini-profiler appears in development DOM | Manual audit only | Development performance UI appears in snapshots. | Not a product issue if disabled outside development. | No product change needed; ignore for production. | None | Low |

---

## Emotional Opportunities

- First landing moment: replace starter copy with one quiet promise about preserving conversations in a private family archive.
- First child creation: explain that a nickname and birthday are enough to begin; avoid making the child feel like a data profile.
- Returning parent: make the child's page start with "Today's question for Leo" rather than profile fields.
- Save confirmation: acknowledge that the parent preserved a memory, not just submitted a response.
- Empty archive: keep "one conversation at a time" and pair it with a direct first-memory action.
- Voice memory detail: after saving voice, label it as preserving the child's voice, not merely an attachment.
- Tomorrow anticipation: after save, gently invite return without streaks, badges, or pressure.
- Account menu: remove status/admin language so the private family space feels intentional.

---

## Delight Opportunities

Small, non-gamified improvements with disproportionate emotional payoff:

- A single "Saved to Leo's memory archive" confirmation after capture.
- A "Today's question" presentation that feels like a prompt card, not a select field.
- A subtle "Listen to this moment" label above voice playback on detail pages.
- Child cards that show the next ritual action, not only View/Edit.
- Empty states that name the child and invite one small conversation.
- A product-aligned logout landing page that feels calm rather than abrupt.
- A gentle return line after saving: "One more piece of Leo's story is here."

---

## Recommended Roadmap

1. Fix trust-breaking shell issues.
   - Replace public starter landing page.
   - Rebrand Devise layout.
   - Hide `Spaces` from parent navigation/account menu.
   - Fix the Profile link crash or remove the link.

2. Make the core mobile hierarchy ritual-first.
   - Rework child profile show page so today's question/capture is first.
   - Move Edit/Remove and birthday metadata below the ritual section.
   - Update children index cards to make the next action obvious.

3. Reduce capture friction.
   - Default to a daily question.
   - Keep choose-another available but secondary.
   - Improve validation and success copy.

4. Polish memory reward moments.
   - Rename archive headings from responses to memories.
   - Improve save confirmation and memory-detail microcopy.
   - Keep archive chronological and minimal.

5. Complete Stage 4 release verification.
   - Test browser recording and permission denial in desktop Chrome/Safari.
   - Test iOS Safari and Android Chrome.
   - Verify fallback upload.
   - Decide whether the 100 MB limit should be reduced.

6. Only then consider larger UX patterns.
   - Child switcher.
   - Parent settings redesign.
   - Future AI reflection entry points.

---

## Product Alignment Notes

Screens that currently support the philosophy:

- Capture form, especially response/note plus optional voice.
- Empty archive copy.
- Archive grouping by month.
- Individual memory detail page.
- Private, child-scoped voice playback route.

Screens that currently fight the philosophy:

- Public landing page.
- Devise layout.
- Account menu.
- Spaces.
- User settings/profile link.
- Child profile first-screen hierarchy.

The core issue is not that the app lacks features. The core issue is that relationship-centered moments are present but surrounded by generic application scaffolding. The smallest high-impact path is to make existing flows say, visually and verbally, "this is a private daily ritual with your child."

---

## Pause Before Implementation

Initial implementation approval was granted after the audit for the first UX polish slice.

Approved first implementation slice:

- Product-aligned public landing page.
- Product-aligned Devise/auth branding.
- Hide `Spaces` from parent-facing navigation/account menus.
- Remove the broken Profile link for MVP.
- Improve basic success flash copy for child creation and memory save.

Still out of scope for this slice:

- Voice recording behavior changes.
- AI features.
- Gamification, streaks, badges, scores, dashboards, or clinical language.
- Parent first-name collection during signup.
- Navigation label changes away from "Children."

---

## Stage 5B - Ritual-First Child Home

Approved scope:

- Make the child profile/show page feel like the parent's daily ritual home, not a child record management page.
- Lead with the child's name and today's question.
- Make "Answer today's question" the primary action.
- Move edit/remove/profile metadata below ritual content.
- Keep "Children" as the main navigation label.
- Keep the design simple and mobile-first.
- Improve recent memories language where useful.
- Add gentle anticipation copy after saving a memory if not already present.

Out of scope:

- AI features.
- Gamification, streaks, scores, badges, dashboards, or clinical language.
- Voice recording behavior changes.
- A full illustration or visual identity system.

Implementation intent:

This slice should change hierarchy and copy, not the underlying memory model. The child show page should first answer: "What can I do with my child today?" Profile management should remain available but visually secondary.
