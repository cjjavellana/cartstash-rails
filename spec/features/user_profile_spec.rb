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

  end

  it "allows the user to change his/her password" do

  end

end