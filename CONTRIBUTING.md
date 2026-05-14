# Contributing to SmarterDates

Thank you for your interest. This document outlines how to contribute.

## Code of Conduct

Please read and follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting Started

### Prerequisites

- Ruby 3.2.0 or higher (3.4.9 recommended; pinned in `.mise.toml`)
- Bundler 2.x

### Setup

```bash
git clone https://github.com/belt/smarter_dates.git
cd smarter_dates
bundle install
bundle exec rspec
```

## Workflow

### Branch

```bash
git checkout -b feature/your-feature-name
```

### Style

- [Standard Ruby](https://github.com/standardrb/standard) — `bundle exec standardrb`
- Reek for code smells — `bundle exec reek lib/`
- RubyCritic for combined quality reports — `bundle exec rubycritic --no-browser lib/`

### Tests

- Write specs for new functionality
- All specs pass: `bundle exec rspec`
- Property-based fuzz tests live in `spec/fuzz/`

### Commits

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add timezone support to Parser
fix: handle empty string in to_chronic_datetime
docs: clarify suffix conventions
test: add round-trip property tests
refactor: extract Parser dispatch
chore: bump rspec to 3.14
```

### Pull Requests

- Clear description of changes
- Link related issues
- Note testing performed
- Update `CHANGELOG.md` for user-facing changes

## Project Layout

```
lib/smarter_dates/
  parser.rb                       # Standalone parser (no deps)
  active_record_integration.rb    # AR Concern
  plain_integration.rb            # POROs
  type.rb                         # ActiveModel types
  validator.rb                    # ChronicParsableValidator
  core_ext.rb                     # Opt-in refinements
  railtie.rb                      # Rails integration
spec/
  lib/smarter_dates/              # Unit tests
  fuzz/                           # Property-based tests
  support/                        # Shared contexts/examples
```

## Reporting Issues

Include:

- Ruby version
- ActiveRecord version (if applicable)
- Steps to reproduce
- Expected vs actual behavior
- Code snippet or failing spec

## Security

Report security vulnerabilities privately — see [SECURITY.md](SECURITY.md).

## License

By contributing, you agree your contributions will be MIT-licensed.
