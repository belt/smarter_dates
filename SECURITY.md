# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

Please do not report security vulnerabilities through public GitHub
issues. Send a report privately via email to
`153964+belt@users.noreply.github.com`.

### What to Include

- Description of the vulnerability
- Potential impact
- Steps to reproduce
- Affected versions
- Suggested fixes or workarounds (if known)

### Response Timeline

- **Initial response**: within 48 hours
- **Assessment**: within 7 days
- **Fix development**: depends on complexity
- **Public disclosure**: after a fix is released

## Security Considerations

### Input handling

`SmarterDates::Parser` accepts strings of arbitrary content. The parser:

- Bounds input length to 256 characters
- Returns `nil` for unparseable input rather than raising
- Catches `ArgumentError`, `TypeError`, and Chronic exceptions
- Does not `eval` or `instance_eval` user input

When parsing user-supplied strings (forms, query parameters), validate
the result before persisting:

```ruby
class Activity < ActiveRecord::Base
  validates :due_on, chronic_parsable: true
end
```

### Logging

Avoid logging unparsed user input verbatim. Use:

```ruby
Rails.logger.warn("invalid date input from user #{user.id}")
```

Not:

```ruby
Rails.logger.warn("invalid date: #{params[:due_on]}")  # ← could log injected content
```

### Dependencies

Run `bundle audit` regularly. The supply chain is intentionally narrow:

- `activemodel` (Rails core)
- `gitlab-chronic` (maintained Chronic fork)

## License

This security policy is based on the
[GitHub Security Policy template](https://github.com/github/security-policy-template).
