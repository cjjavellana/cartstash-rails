require 'rails_helper'

describe User do

  context "User's name" do
    it "returns the user's name" do
      user = build(:user)
      expect(user.get_name).to eq("Foobar Kadigan")
    end

    it "returns 'empty string' when first name and last name are empty" do
      user = build(:user_with_no_name)
      expect(user.get_name).to eq("")
    end
  end

end