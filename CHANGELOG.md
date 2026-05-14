# Changelog

Notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-05-25

### Added

- `SmarterDates::Parser` — standalone module for natural-language parsing.
- `SmarterDates::ActiveRecordIntegration` — Concern for AR models.
- `SmarterDates::PlainIntegration` — mixin for plain Ruby objects.
- `SmarterDates::CoreExt` — opt-in `String` refinements.
- `SmarterDates::ChronicDateType` and `ChronicDateTimeType` — ActiveModel types.
- `:chronic_date` / `:chronic_datetime` types auto-registered in Rails.
- Modernized `ChronicParsableValidator` using `errors.add`.
- CI matrix: Ruby 3.4 + 4.0 × ActiveRecord 7.2 + 8.1.
- Dockerized CI via `Dockerfile`, `docker-compose.yml`, and `docker-bake.hcl`.
- mise-managed Ruby version pin.
- `.standard.yml`, `.reek.yml`, `.rubycritic.yml` — quality tooling.
- `bundler-audit` security check.

### Changed

- **BREAKING**: `String#to_chronic_*` is no longer a global monkey-patch.
  Use `using SmarterDates::CoreExt` per-file.
- **BREAKING**: Minimum Ruby is now 3.2; minimum ActiveRecord is 7.2.
- **BREAKING**: Switched runtime Chronic dep to the maintained
  `gitlab-chronic` fork (API-compatible).
- Replaced module-level `@dt_attributes` shared state with
  per-class scanning (eliminates cross-class contamination).
- `chronic_parsable` validator now uses `errors.add` instead of the
  Rails 4-era frozen `errors[]` array push.

### Removed

- **BREAKING**: `Configuration.for("smarter_dates")` install generator
  and initializer template (never wired to anything).
- **BREAKING**: Rails Engine class (replaced by Railtie).
- `VERSION.yml` (duplicate of `lib/smarter_dates/version.rb`).
- `spec/dummy/` Rails app (replaced by in-memory sqlite3).
- Legacy `test/` Test::Unit suite (covered by RSpec).
- README in RDoc format (replaced by Markdown).
- Ruby 1.9.x debugger gem conditionals.

## [0.2.x]

Historical releases. See git log.
