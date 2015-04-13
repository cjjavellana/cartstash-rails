describe Cart do

  let(:empty_cart) {
    Cart.new
  }

  it "returns an empty cart when there are no items" do
    expect(empty_cart).to be_empty
  end

end