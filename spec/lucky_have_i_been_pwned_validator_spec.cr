require "./spec_helper"

def make_password_field(value)
  Avram::Field.new(name: :password, param: "password", value: value, form_name: "fake")
end

describe HaveIBeenPwned do
  describe "validate_not_pwned" do
    it "errors with a pwned password" do
      field = make_password_field("password123")
      HaveIBeenPwned.validate_not_pwned(field)
      field.valid?.should be_false
      field.errors.should contain "has been pwned!"
    end

    it "allows use of a custom error message" do
      field = make_password_field("password123")
      HaveIBeenPwned.validate_not_pwned(field, "is PWNED!")
      field.valid?.should be_false
      field.errors.should contain "is PWNED!"
    end

    it "validates with a secure password" do
      field = make_password_field("superlongandsupersecurepasswordthatsdefinitelynotpwned")
      HaveIBeenPwned.validate_not_pwned(field)
      field.valid?.should be_true
      field.errors.should be_empty
    end
  end
end
