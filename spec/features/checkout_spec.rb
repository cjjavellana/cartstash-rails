require 'rails_helper'

describe "Checkout" do

  it "allows the user to view the checkout page" do
    visit checkout_index_path
    expect(page).to have_selector(".review-order", text: "Review Order")
  end

end

