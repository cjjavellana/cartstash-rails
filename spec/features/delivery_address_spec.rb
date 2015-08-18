require 'rails_helper'

describe 'Manage delivery address' do

  before do
    user = create(:user)
    login_as(user, :scope => :user)

    create(:foobar_delivery_address)

    countries = [
      build_stubbed(:ph)
    ]

    RedisClient.set("countries", countries.to_json)    
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

  it 'creates new delivery address' do
    visit delivery_address_index_path
    click_link 'Add Delivery Address'

    fill_in 'delivery_address_recipient_name', :with => 'Foobar Kadigan'
    fill_in 'delivery_address_contact_no', :with => '+639178888888'
    fill_in 'delivery_address_address_line_1', :with => '#07-07 BLK 111, Make Believe Street'
    fill_in 'delivery_address_zip_code', :with => '520111'
    find('#delivery_address_country').find(:css, 'option[value="PH"]').select_option

    click_button 'Save'
    expect(page).to have_selector('.delivery-address-item')
  end
end
