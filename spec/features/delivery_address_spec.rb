require 'rails_helper'

describe 'Manage delivery address' do

  before do
    user = create(:user)
    login_as(user, :scope => :user)

    create(:foobar_delivery_address)
  end

  it 'lists all delivery addresses of the user' do
    visit delivery_address_index_path
    expect(page).to have_selector('.delivery-address-item')
  end

  it 'can show the edit page, update some details and save it back' do
    visit delivery_address_index_path
    first('a.edit-delivery-addr-link').click

    expect(page).to have_selector('#delivery_address_recipient_name')
    click_button 'Save'

    expect(page).to have_selector('.flash', text: 'Delivery address updated successfully')
  end
end