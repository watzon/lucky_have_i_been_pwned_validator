require "./spec_helper"

def make_password_attribute(value)
  Avram::Attribute.new(
    name: :password,
    param: "password",
    value: value,
    param_key: "fake"
  )
end

describe HaveIBeenPwned do
  describe "validate_not_pwned" do
    before_each do
      WebMock.stub(:get, "https://api.pwnedpasswords.com/range/cbfda")
        .to_return(body: File.read("spec/fixtures/password123.txt"))
      WebMock.stub(:get, "https://api.pwnedpasswords.com/range/b4529")
        .to_return(body: "")
      WebMock.stub(:get, "https://api.pwnedpasswords.com/range/e6b6a")
        .to_return(status: 500)
    end

    it "errors with a pwned password" do
      attribute = make_password_attribute("password123")
      HaveIBeenPwned.validate_not_pwned(attribute)

      attribute.valid?.should be_false
      attribute.errors.should contain("has been pwned!")
    end

    it "allows use of a custom error message with interpolation" do
      attribute = make_password_attribute("password123")
      HaveIBeenPwned.validate_not_pwned(attribute, "is PWNED! (times found: %s)")

      attribute.valid?.should be_false
      attribute.errors.should contain("is PWNED! (times found: 126927)")
    end

    it "validates with a secure password" do
      attribute = make_password_attribute("superlongandsupersecurepasswordthatsdefinitelynotpwned")
      HaveIBeenPwned.validate_not_pwned(attribute)

      attribute.valid?.should be_true
      attribute.errors.should be_empty
    end

    it "allows to raise an exception" do
      expect_raises(HaveIBeenPwned::ApiError, "api.pwnedpasswords.com returned 500") do
        attribute = make_password_attribute("password1234")
        HaveIBeenPwned.validate_not_pwned(
          attribute,
          error_message: "is PWNED %s times!",
          raise_exception: true
        )

        attribute.valid?
      end
    end
  end
end
