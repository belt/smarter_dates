# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# Default Gemfile — local dev uses ActiveRecord >= 7.2 (latest available).
# CI matrix lives in gemfiles/activerecord_*.gemfile (each is standalone,
# selected via BUNDLE_GEMFILE).

group :development do
  # Modern debugger (Ruby 3.1+, replaces pry/byebug)
  gem "debug", ">= 1.11", require: false

  # Build / release tasks
  gem "rake", "~> 13.2", require: false

  # Combined quality report (reek + flay + flog)
  gem "rubycritic", "~> 5.0", require: false

  # Code smell detection (also used by rubycritic)
  gem "reek", "~> 6.5", require: false
end

group :development, :test do
  # Testing
  gem "rspec", "~> 3.13"
  gem "activerecord", ">= 7.2", require: false
  gem "sqlite3", "~> 2.9"

  # Property-based / fuzz testing
  gem "rantly", "~> 3.0"

  # Linting (zero-config)
  gem "standard", "~> 1.54", require: false

  # Coverage
  gem "simplecov", "~> 0.22", require: false

  # Security audit
  gem "bundler-audit", "~> 0.9", require: false
end
