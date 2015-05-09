require 'rails_helper'

describe "The Login Process" do 

    it "allows a registered user to sign in" do
        user = create(:user)

        visit new_user_session_path
        fill_in("user_email", :with => user.email)
        fill_in("user_password", :with => user.password)
        click_button("Log in")

        expect(page).to have_selector(".user-info-btn", text: "Welcome, Foobar")
    end

    it "does not allow a non-registered user to sign in" do
        non_registered_user = build(:unregistered)

        visit new_user_session_path
        fill_in("user_email", :with => non_registered_user.email)
        fill_in("user_password", :with => non_registered_user.password)
        click_button("Log in")

        expect(page).to have_selector(".alert", text: "Invalid email or password")
    end
end