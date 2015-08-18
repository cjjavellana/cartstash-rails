require 'rails_helper'

describe "Check Out Process" do

  before do
    user = create(:user)
    login_as(user, :scope => :user)

    countries = [
      build_stubbed(:ph)
    ]

    credit_card_types = [
      build_stubbed(:visa)
    ]

    RedisClient.set("countries", countries.to_json)
    RedisClient.set("cc_types", credit_card_types.to_json)
  end

  it "allows the user to view the checkout page" do
    visit checkout_index_path
    expect(page).to have_selector(".section-header", text: "Order Summary")
  end

  it "requires atleast one payment method" do
    visit checkout_index_path
    click_button 'Confirm Order'
    expect(page).to have_selector(".alert-danger")
  end

  it 'confirms the order using COD' do
    date = Date.today

    delivery_address = create(:foobar_delivery_address)
    visit checkout_index_path
    find(:css, '#form_payment_option_cod').set(true)
    find(:css, '#form_delivery_address_1').set(true)
    find(:css, '#form_schedule').set "#{date.strftime("%d-%m-%Y")} 08:00"
    click_button 'Confirm Order'
    #expect(page).to have_selector('.order-placed-msg')
  end

  it 'can navigate to add new payment method' do
    visit checkout_index_path
    click_link 'Add Option'

    expect(page).to have_selector('#return_url')

    fill_in 'payment_method_first_name', :with => 'Foobar'
    fill_in 'payment_method_last_name', :with => 'Kadigan'
    find('#payment_method_credit_card_type').find(:css, 'option[value="visa"]').select_option
    fill_in 'payment_method_expiry_date', :with => '10/2015'
    fill_in 'payment_method_security_code', :with => '536'
    fill_in 'payment_method_credit_card_no', :with => '4539016690974009'
    fill_in 'payment_method_address_line_1', :with => '#10-20, Street 1'
    fill_in 'payment_method_zip_code', :with => '520111'
    find('#payment_method_country').find(:css, 'option[value="PH"]').select_option

    click_button 'Save'
    expect(page).to have_selector(".section-header", text: "Order Summary")
  end
end
