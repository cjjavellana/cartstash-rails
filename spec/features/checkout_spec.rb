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

  it "allows the user to choose the delivery location and schedule" do
    visit checkout_index_path
    find(:css, ".pm-checkbox:last-child").set(true)
    click_button 'checkout-next-btn'
    expect(page).to have_selector(".del-location", text: "Choose Delivery Location")
  end

end

