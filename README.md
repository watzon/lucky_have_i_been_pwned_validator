# Have I Been Pwned Lucky Validator

This is a simple password validator for Lucky that ensures the password isn't in the [Have I Been Pwned](https://haveibeenpwned.com/) database.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     lucky_have_i_been_pwned_validator:
       github: watzon/lucky_have_i_been_pwned_validator
   ```

2. Run `shards install`

## Usage

First require the shard

```crystal
# Require this anywhere before your validations
require "lucky_have_i_been_pwned_validator"
```

Then implement

```crystal
def prepare
  # Where `field` is the field instance (probably password).
  Avram::Validations::HaveIBeenPwned.validate_not_pwned(field)
end
```

The `validate_not_pwned` method accepts a second argument for a custom message.

```crystal
Avram::Validations::HaveIBeenPwned.validate_not_pwned(field, "is PWNED!")
```

## Contributing

1. Fork it (<https://github.com/watzon/lucky_have_i_been_pwned_validator/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
