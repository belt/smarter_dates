# SmarterDates

Natural-language date and datetime attribute parsing for Ruby and Rails.

Date/datetime attributes ending in `_d`, `_on`, `_dt`, or `_at` are
parsed from human-friendly strings ("yesterday", "noon march 15") into
proper `Date` or `DateTime` values. Works with ActiveRecord, plain Ruby
objects, ActiveModel attributes, or as a standalone parser.

## Installation

```ruby
gem "smarter_dates"
```

## Usage

The suffix on the attribute name decides what type is produced:

| Suffix | Coerced to | Examples                             |
| ------ | ---------- | ------------------------------------ |
| `_d`   | `Date`     | `birth_d`, `start_d`                 |
| `_on`  | `Date`     | `created_on`, `due_on`               |
| `_dt`  | `DateTime` | `meeting_dt`, `event_dt`             |
| `_at`  | `DateTime` | `created_at`, `updated_at`           |

### ActiveRecord

```ruby
class Activity < ActiveRecord::Base
  include SmarterDates::ActiveRecordIntegration
end

a = Activity.new
a.birth_d = "22 April 1976"  # => stored as Date
a.meeting_dt = "next friday at noon"  # => stored as DateTime
a.created_on = "one week ago"
a.updated_at = "yesterday"
```

The legacy mixin still works:

```ruby
class Activity < ActiveRecord::Base
  include SmarterDates  # auto-detects AR base class
end
```

### Plain Ruby Object

```ruby
class Reminder
  attr_accessor :due_on, :remind_at
  include SmarterDates::PlainIntegration
end

r = Reminder.new
r.due_on = "next monday"
r.remind_at = "in 30 minutes"
```

### ActiveModel custom types

```ruby
class Draft
  include ActiveModel::Attributes
  attribute :start_on, :chronic_date
  attribute :remind_at, :chronic_datetime
end
```

With Rails, `:chronic_date` and `:chronic_datetime` register
automatically via the Railtie.

### Validator

```ruby
class Activity < ActiveRecord::Base
  validates :birth_d, chronic_parsable: true
  validates :meeting_dt, chronic_parsable: { datetime: true }
end
```

### Standalone parser

```ruby
SmarterDates::Parser.to_date("yesterday")        # => #<Date: 2026-05-24>
SmarterDates::Parser.to_datetime("in 2 hours")   # => #<DateTime: ...>
SmarterDates::Parser.parsable?("noon march 15")  # => true
```

### Opt-in refinements

Lexically scoped — no global monkey-patching.

```ruby
require "smarter_dates/core_ext"
using SmarterDates::CoreExt

"yesterday".to_chronic_date
"noon march 15".to_chronic_datetime
"now".to_chronic_time
```

## How it works

The parser tries `Chronic.parse` first (when `gitlab-chronic` or the
original `chronic` gem is loaded), then falls back to `DateTime.parse`
and `Date.parse` from the stdlib. Unparseable input returns `nil`.

`gitlab-chronic` is the actively-maintained Chronic fork. The original
`mojombo/chronic` is unmaintained but remains API-compatible — both
work as drop-in runtime dependencies.

## Requirements

- Ruby >= 3.2.0
- ActiveModel >= 7.2 (for the validator and custom types)
- ActiveRecord >= 7.2 (for the AR integration)

Tested matrix: Ruby 3.4 + 4.0 × ActiveRecord 7.2 + 8.1.

## Migration from 0.x

Version 1.0 is a clean rewrite. Breaking changes:

- `String#to_chronic_*` is no longer a global monkey-patch. Use
  `using SmarterDates::CoreExt` to opt in per-file.
- `include SmarterDates` still works, but routes through
  `ActiveRecordIntegration` or `PlainIntegration`.
- The `Configuration.for("smarter_dates")` install generator and
  initializer template were removed (the option was never wired to
  anything).
- Minimum Ruby is 3.2; minimum ActiveRecord is 7.2.

## License

MIT — see [LICENSE](LICENSE).
