require 'rails_helper'

describe PaymentMethod do

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

  it "allows the user to choose the delivery location and schedule" do
    visit checkout_index_path
    find(:css, ".pm-checkbox:last-child").set(true)
    click_button 'checkout-next-btn'
    expect(page).to have_selector(".checkout-section-header", text: "Choose Delivery Address")
  end

end

