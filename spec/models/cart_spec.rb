require 'rails_helper'

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

    expect(cart.sub_total).to eq(910.96)
  end

  it "can increase the quantity of an item in the cart" do
    cart.add_item("40-100-01")
    cart.add_item("40-100-01")

    expect(cart.item_map["40-100-01".to_sym].quantity).to eq(2)
  end

  it "can reduce the quantity of an item in the cart" do
    cart.add_item("40-100-01")
    cart.add_item("40-100-01")

    expect(cart.item_map["40-100-01".to_sym].quantity).to eq(2)

    cart.reduce_qty_of("40-100-01")
    expect(cart.item_map["40-100-01".to_sym].quantity).to eq(1)

    cart.reduce_qty_of("40-100-01")
    expect(cart.order_qty("40-100-01")).to eq(0)
  end

  it "can revise the quantity of an item in the cart" do
    cart.add_item("40-100-01", 2)
    expect(cart.item_map["40-100-01".to_sym].quantity).to eq(2)

    cart.update_item("40-100-01", 5)
    expect(cart.item_map["40-100-01".to_sym].quantity).to eq(5)
  end

  it "can remove an item from the cart" do
    cart.add_item("40-100-01")
    expect(cart.unique_items).to eq(1)

    cart.remove_item("40-100-01")
    expect(cart).to be_empty
  end

  it "will calculate the sales tax" do
    cart.add_item("40-100-01")
    cart.add_item("40-120-01", 3)

    expect(cart.sub_total).to eq(910.96)
    expect(cart.sales_tax).to eq(109.32)
  end

  it "returns 0 when product does not exist in cart" do
    qty = cart.order_qty('10001')
    expect(qty).to eq(0)
  end
end
