# Have I Been Pwned Lucky Validator

This is a simple password validator for Lucky that ensures the password isn't in the [Have I Been Pwned](https://haveibeenpwned.com/) database.

![In Action](https://raw.githubusercontent.com/watzon/lucky_have_i_been_pwned_validator/master/img/in-action.gif)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     lucky_have_i_been_pwned_validator:
       github: watzon/lucky_have_i_been_pwned_validator
   ```

2. Run `shards install`

## Usage

First require the shard:

```crystal
# in your app's src/shards.cr
require "lucky_have_i_been_pwned_validator"
```

Then perform the call in your operation(s):

```crystal
class SignUpUser < User::SaveOperation
  ...

  before_save do
    ...
    HaveIBeenPwned.validate_not_pwned(password)
    ...
  end
end
```

The `validate_not_pwned` method accepts a second argument for a custom message:

```crystal
HaveIBeenPwned.validate_not_pwned(password, "is PWNED %s times!")
```

And you can also choose to catch API errors from the pwned API to make your app
more resilient:

```crystal
begin
  HaveIBeenPwned.validate_not_pwned(password, raise_exception: true)
rescue e : HaveIBeenPwned::ApiError
  # report this to an error monitoring service for example...
end
```

## Contributing

1. Fork it (<https://github.com/watzon/lucky_have_i_been_pwned_validator/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
