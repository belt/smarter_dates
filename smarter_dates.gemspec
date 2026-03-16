# frozen_string_literal: true

require_relative "lib/smarter_dates/version"

Gem::Specification.new do |spec|
  spec.name = "smarter_dates"
  spec.version = SmarterDates::VERSION
  spec.authors = ["Paul Belt"]
  spec.email = ["153964+belt@users.noreply.github.com"]

  spec.summary = "Natural-language date and datetime attribute parsing for Ruby."
  spec.description = <<~DESC
    Parses date/datetime attributes ending in _d, _on, _dt, or _at from
    natural-language strings ("yesterday", "noon march 15") into Date or
    DateTime values. Supports ActiveRecord models and plain Ruby objects,
    plus opt-in String refinements and an ActiveModel chronic_parsable
    validator.
  DESC
  spec.homepage = "https://github.com/belt/smarter_dates"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.required_rubygems_version = ">= 3.4"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/belt/smarter_dates",
    "changelog_uri" => "https://github.com/belt/smarter_dates/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/belt/smarter_dates/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir[
    "lib/**/*.rb",
    "config/locales/*.yml",
    "LICENSE",
    "README.md",
    "CHANGELOG.md"
  ]
  spec.require_paths = ["lib"]

  # Runtime: Chronic for natural-language parsing. The maintained fork
  # `gitlab-chronic` is API-compatible with the original and tracks
  # current Ruby releases. ActiveModel pulls in the bits the validator
  # and types need without forcing the whole AR stack.
  spec.add_dependency "activemodel", ">= 7.2"
  spec.add_dependency "gitlab-chronic", ">= 0.10"
end
