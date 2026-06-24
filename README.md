# Parenting Connection

An application built from a personal Rails 8 starter template.
Built on Ruby 4.0.1, Rails 8.1.3, Tailwind CSS 4, daisyUI 5.5.23,
Devise, Pundit, Hotwire, and Solid Queue.
This app is PostgreSQL-first.

## Quick Start

### 1. Clone the repo

```bash
git clone <your-repo-url>
cd parenting_connection
```

### 2. Set up
```bash
bin/setup
```

### 3. Start
```bash
bin/dev
```

Visit http://localhost:3000

Default login: `admin@example.com` / `password123`

---

## Stack

| Layer | Technology |
|-------|-----------|
| Language | Ruby 4.0.1 |
| Runtime | Node.js 24.18.0 LTS + npm |
| Framework | Rails 8.1.3 |
| Database | PostgreSQL |
| Frontend | Hotwire (Turbo + Stimulus) |
| CSS | Tailwind CSS 4 + daisyUI 5.5.23 |
| Auth | Devise + devise_invitable |
| Authorization | Pundit |
| Background jobs | Solid Queue |
| Pagination | Pagy |
| Deployment | Kamal |

---

## Development
```bash
bin/dev                      # start server + CSS watcher
bin/rails db:prepare         # create + migrate all postgres DBs
bundle exec rspec            # run tests
bundle exec rubocop          # lint
bin/rails tailwindcss:build  # rebuild CSS manually
bin/rails db:seed            # reload seed data
```

---

## Docs

| File | Purpose |
|------|---------|
| docs/AGENTS.md | AI agent entry point — read first |
| docs/ARCHITECTURE.md | Domain model, layout system |
| docs/CONVENTIONS.md | Coding conventions, daisyUI patterns |
| docs/SETUP.md | Detailed setup instructions |
| docs/template/ | Template build history (ignore for app dev) |

---

## Template Origin

This repository was initialized from `my-rails-starter` and renamed for
Parenting Connection. Template-maintenance notes live in `docs/template/`.

---

## Template Versions

See [releases](../../releases) for changelog.
