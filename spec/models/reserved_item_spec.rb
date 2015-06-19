require 'rails_helper'

describe ReservedItem, type: :model do

  let(:reserved_items) {
    item = build_stubbed(:reserved_item)
    expect(item).to receive(:destroy)
    expect(item).to receive(:product_id)
    [item]
  }

  it 'returns the items back to product inventory when not purchased' do
    product = build_stubbed(:breeze_detergent)
    expect(product).to receive(:update_attribute)
    expect(product).to receive(:qty).and_return(10.00)
    expect(Product).to receive(:find).and_return(product)
    expect(ReservedItem).to receive(:where).and_return(reserved_items)
    ReservedItem.return_to_inventory
  end

end
