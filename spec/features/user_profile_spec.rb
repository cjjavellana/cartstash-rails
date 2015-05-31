require 'rails_helper'

describe "User Profile" do

  before do
    user = create(:user)
    login_as(user, :scope => :user)
  end

  it "allows the user to view his/her profile" do
    visit user_profile_index_path
    expect(page).to have_selector(".user-profile-header")
  end

  it "allows the user to update his/her profile details" do
    visit user_profile_index_path
    fill_in("user_first_name", with: "Foobarbaz")
    click_button("Save")
    expect(page).to have_selector(".flash", text: "User profile successfully updated")
  end

  it "allows the user to change his/her password" do

  end

end