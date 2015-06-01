require 'rails_helper'

describe 'User Profile', :js => true do

  before do
    user = create(:user)
    login_as(user, :scope => :user)
  end

  before(:each) {
    visit user_profile_index_path
  }

  it 'allows the user to view his/her profile' do
    expect(page).to have_selector('.user-profile-header')
  end

  it 'allows the user to update his/her profile details' do
    fill_in 'user_first_name', with: 'Foobarbaz'
    click_button 'Save'
    expect(page).to have_selector('.flash', text: 'User profile successfully updated')
  end

  it 'allows the user to change the password' do
    click_link 'Change Password'
    fill_in('user_current_password', with: 'password')
    fill_in('user_password', with: 'password1')
    fill_in('user_password_confirmation', with: 'password1')
    click_button 'Change Password'

    expect(page).to have_selector('.alert-success', text: 'Password successfully updated')
  end

  it 'displays error messages when current password is wrong' do
    click_link 'Change Password'
    fill_in('user_current_password', with: 'password1')
    fill_in('user_password', with: 'password1')
    fill_in('user_password_confirmation', with: 'password1')
    click_button 'Change Password'

    expect(page).to have_selector('.alert-danger ul li', text: 'Current password is invalid')
  end
end