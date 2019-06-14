require "http/client"
require "openssl"

module HaveIBeenPwned
  extend self

  # Validataes that a password is not in the Have I Been Pwned database.
  def validate_not_pwned(field, error_message = nil)
    error_message ||= "has been pwned!"

    field.value.try do |value|
      if password_in_hibp?(value)
        field.add_error(error_message)
      end
    end
  end

  private def password_in_hibp?(password)
    hash = get_sha1_hash(password).upcase
    first_five = hash[0...5]
    the_rest = hash[5..-1]

    response = HTTP::Client.get("https://api.pwnedpasswords.com/range/" + first_five)
    hashes = response.body.split("\r\n")
        .map(&.split(':'))
        .to_h

    exists = hashes.has_key?(the_rest)
  end

  private def get_sha1_hash(password)
    digest = OpenSSL::Digest.new("SHA1")
    digest.update(password)
    hash = digest.to_s
    digest.reset
    hash
  end
end
