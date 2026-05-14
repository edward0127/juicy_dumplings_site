# Juicy Dumplings Website (Rails 8)

Modern restaurant website for **Juicy Dumplings (Doncaster East, VIC)** with:

- Public marketing pages
- Online ordering (pickup + delivery request)
- Booking/reservations with slot + capacity validation
- Owner admin dashboard
- Stripe Checkout pay-now flow
- Action Mailer notifications
- RSpec model/request coverage

## Tech Stack

- Ruby `3.3.10`
- Rails `8.1.x`
- SQLite
- Tailwind CSS
- Hotwire (Turbo + Stimulus)
- RSpec
- dotenv (`dotenv-rails`)
- Stripe (`stripe`)

## Main Routes

Public:

- `/` home
- `/menu`
- `/order`
- `/book`
- `/about`
- `/contact`
- `/privacy`
- `/terms`

Admin (session login with `ADMIN_USER` / `ADMIN_PASS`):

- `/admin`
- `/admin/login`

## Local Setup

1. Copy env template:

```bash
cp .env.example .env
```

2. Install gems:

```bash
bundle install
```

3. Ensure `.env` SQLite paths are correct (defaults are already set).

4. Prepare database + seed:

```bash
bundle exec rails db:prepare
bundle exec rails db:seed
```

5. Run app:

```bash
bin/rails s
```

For live Tailwind rebuild in development:

```bash
bundle exec rails tailwindcss:watch
```

Open `http://localhost:3000`.

## Production Docker

1. Copy production env template:

```bash
cp .env.prod.example .env.prod
```

2. Fill required values in `.env.prod` (`RAILS_MASTER_KEY`, `SECRET_KEY_BASE`, admin credentials, etc).

3. Deploy or restart with the Curtain-style script:

```bash
./script/deploy.sh deploy
```

4. Seed menu/settings once after the first production deploy:

```bash
./script/deploy.sh seed
./script/deploy.sh restart
```

5. Deploy from the real Git repo to production:

```bash
./script/deploy_production.sh
```

The production compose file runs `ghcr.io/edward0127/juicy_dumplings_site:latest` on `APP_PORT_BIND` default `3013` with SQLite persisted at `/data/production.sqlite3`.

## Key Environment Variables

- `SQLITE_DATABASE` (local or production path, e.g. `storage/development.sqlite3` or `/data/production.sqlite3`)
- `SQLITE_TEST_DATABASE` (test DB path, e.g. `storage/test.sqlite3`)
- `ADMIN_USER`, `ADMIN_PASS`
- `OWNER_EMAIL`
- `MAIL_FROM`
- `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY`
- `SMS_WEBHOOK_URL` (optional owner SMS hook)
- `HOST`
- `ACTIVE_STORAGE_SERVICE` (`local` by default; set to `amazon` only after S3 env vars are configured)
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `AWS_S3_BUCKET` for Active Storage S3
- `PUBLIC_UPLOAD_ASSET_HOST` (optional CloudFront host for rendered public S3 blob URLs)
- Optional SMTP: `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `SMTP_DOMAIN`, `SMTP_AUTH`, `SMTP_STARTTLS`

## Active Storage S3 + CloudFront

Juicy Dumplings keeps Rails Active Storage responsible for uploads, deletes, attachments, and seeded menu photos. `ACTIVE_STORAGE_SERVICE=local` remains the default in development and production. Set `ACTIVE_STORAGE_SERVICE=amazon` only after AWS S3 values are available.

`PUBLIC_UPLOAD_ASSET_HOST` is optional and should not include a trailing slash. When present, it only changes rendered public URLs for Active Storage blobs whose `service_name` is `amazon`; local blobs continue to use normal Rails Active Storage URLs. Existing local blobs do not automatically move to S3. After switching to `amazon`, run `RESEED_MENU_IMAGES=true` with `db:seed` to reattach seed images to S3.

Local S3/CloudFront test values:

```bash
ACTIVE_STORAGE_SERVICE=amazon
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=ap-southeast-2
AWS_S3_BUCKET=juicy-dumplings-site-staging
PUBLIC_UPLOAD_ASSET_HOST=https://<staging-cloudfront-domain>
```

Production activation later:

```bash
ACTIVE_STORAGE_SERVICE=amazon
AWS_ACCESS_KEY_ID=<real value>
AWS_SECRET_ACCESS_KEY=<real value>
AWS_REGION=ap-southeast-2
AWS_S3_BUCKET=juicy-dumplings-site-production
PUBLIC_UPLOAD_ASSET_HOST=https://<cloudfront-distribution-domain>
```

After updating the live `.env.prod`, restart, reattach seed images to S3, and restart again:

```bash
./script/deploy.sh restart
docker compose -f docker-compose.yml run --rm --no-deps -e RESEED_MENU_IMAGES=true web bin/rails db:seed
./script/deploy.sh restart
```

## Admin Capabilities

- Categories CRUD
- Menu items CRUD
- Opening hours CRUD
- Orders list/detail/status update + CSV export
- Bookings list/detail/status update + CSV export
- Business settings (address/contact/hours/ordering toggles/capacity)

## Stripe Flow

- Order can be placed as `pay_at_pickup` (if enabled)
- `pay_now` redirects to Stripe Checkout
- On successful return, order is marked paid and confirmation emails are sent

## Test

Run RSpec:

```bash
bundle exec rspec
```

Current test focus:

- Model validations (`MenuItem`, `Order`, `Booking`)
- Request flows (order placement, booking creation, admin auth, CSV export)

## Notes

- Business defaults are editable via Admin Settings.
- Menu photos are placeholder blocks ready to be replaced with real assets.
- Contact form includes a honeypot field for basic spam protection.
