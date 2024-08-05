require "rails_helper"

RSpec.describe User, type: :model do
  before :each do
    @user = User.create!(email: "user@email.com", password: "password", password_confirmation: "password")
  end

  describe "validations" do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should have_secure_password }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }

    it { should have_secure_token :api_key }
    it { should validate_uniqueness_of :api_key }
  end

  it "should have a secure password and secure api_key" do
    expect(@user.authenticate("password")).to eq(@user)
    expect(@user).to_not have_attribute(:password)
    expect(@user.password_digest).to_not eq("password")
    expect(@user.api_key).to_not eq(nil)
    expect(@user.api_key).to_not eq("")
  end
end