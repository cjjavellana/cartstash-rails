require 'rails_helper'

describe "Check Out Process" do

  before do
    user = create(:user)
    login_as(user, :scope => :user)
  end

  it "allows the user to view the checkout page" do
    visit checkout_index_path
    expect(page).to have_selector(".review-order", text: "Review Order")
  end

  it "requires atleast one payment method" do
    visit checkout_index_path
    click_button 'checkout-next-btn'
    expect(page).to have_selector(".alert-danger", text: "Please select a payment method")
  end

  it 'confirms the order using COD' do
    delivery_address = create(:foobar_delivery_address)
    visit checkout_index_path
    find(:css, '.pm-checkbox:last-child').set(true)
    click_button 'checkout-next-btn'
    expect(page).to have_selector('.checkout-section-header', text: 'Choose Delivery Address')
    find(:css, '#delivery_address').set delivery_address.id
    find(:css, '#delivery_schedule').set '27-04-2015 8:00-10:00'
    click_button 'Place Order'
    expect(page).to have_selector('.order-placed-msg')
  end

end

