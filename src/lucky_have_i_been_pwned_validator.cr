require "digest/sha1"
require "http/client"

module HaveIBeenPwned
  extend self

  # Validataes that a password is not in the Have I Been Pwned database.
  def validate_not_pwned(
    attribute : Avram::Attribute,
    error_message = "has been pwned!",
    raise_exception = false
  ) : Void
    attribute.value.try do |value|
      found = password_in_hibp?(value, raise_exception)

      attribute.add_error(error_message % found) if found
    end
  end

  private def password_in_hibp?(
    password : String,
    raise_exception : Bool
  ) : Int32?
    hash = Digest::SHA1.hexdigest(password)
    prefix = hash[0...5]
    suffix = hash[5..-1]

    response = HTTP::Client.get "https://api.pwnedpasswords.com/range/#{prefix}"

    if response.status_code == 200
      response.body.each_line do |line|
        if line =~ /^#{suffix}\:(\d+)$/i && (found = $1.to_i?)
          return found
        end
      end
    end

    if raise_exception
      raise ApiError.new("api.pwnedpasswords.com returned #{response.status_code}")
    end
  end

  class ApiError < Exception; end
end
