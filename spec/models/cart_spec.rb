describe Cart do

  let(:cart) {
    Cart.new
  }

  before(:all) do
    create(:breeze_detergent)
    create(:tide_liquid_detergent)
  end

  it "returns an empty cart when there are no items" do
    expect(cart).to be_empty
  end

  it "can add an item into the cart" do
    cart.add_item("40-100-01")
    cart.add_item("40-120-01", 3)

    expect(cart.unique_items).to eq(2)
  end

  it "raises an error when it cannot find the item"  do
    expect{cart.add_item("fake-sku")}.to raise_error
  end

  it "can calculate the price of all items in the cart" do
    cart.add_item("40-100-01")
    cart.add_item("40-120-01", 3)

    expect(cart.price).to eq(910.96)
  end

  it "is able to update the quantity of an item in the cart" do
    cart.add_item("40-100-01")
    cart.add_item("40-100-01")

    expect(cart.item_map["40-100-01".to_sym].quantity).to eq(2)
  end
end