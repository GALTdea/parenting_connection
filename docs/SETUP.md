# Setup

## First-time setup

### Prerequisites
- Ruby 4.0.1 (rbenv or asdf recommended)
- Bundler 4.x
- Node.js 24.18.0 LTS + npm (for daisyUI)
- PostgreSQL 14+ (or equivalent recent version)

Make sure PostgreSQL is running locally and your user can create databases.
Defaults in `config/database.yml` use:
- host: `127.0.0.1`
- port: `5432`
- user: your current shell user (`$USER`) unless `POSTGRES_USER` is set
- password: `POSTGRES_PASSWORD` env var (optional, but usually needed)
- development databases:
  `parenting_connection_development`,
  `parenting_connection_development_cache`,
  `parenting_connection_development_queue`,
  `parenting_connection_development_cable`

### Setup

  git clone <your-repo-url>
  cd <app-name>
  bin/setup
  bin/dev

Manual equivalent:

  bundle install
  npm install
  bin/rails db:prepare
  bin/rails db:seed

Visit http://localhost:3000

### Verify

  bin/rails about        # confirm Rails boots
  node -v                # should match .node-version
  bundle exec rspec        # target: 0 failures
  bundle exec rubocop      # 0 offenses

## Credentials

Rails 8 uses encrypted credentials for secrets.
This template also supports `.env` for local, non-credential config
like PostgreSQL connection settings.

To view or edit credentials:

  bin/rails credentials:edit

The master key is in config/master.key (gitignored).
Never commit config/master.key.
When deploying, set the RAILS_MASTER_KEY environment
variable in your hosting platform (e.g. Hatchbox).
