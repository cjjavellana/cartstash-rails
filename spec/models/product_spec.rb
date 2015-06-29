require 'rails_helper'

describe Product do

  let(:products) {
    [
      build_stubbed(:thai_fragrant_rice)
    ]
  }

  it 'retrieves products by category from database when not in cache' do
    expect(RedisClient).to receive(:get).with('_prod_category_1-rice-breads').and_return(nil)
    expect(ProductCategory).to receive(:find_by_slug).and_return(build_stubbed(:rice_and_breads))
    expect(Product).to receive_message_chain(:joins, :where).and_return(products)
    expect(RedisClient).to receive(:set)

    result = Product.products_by_category(build_stubbed(:rice_and_breads).slug)
    expect(result[:products][0][:name]).to eq('Thai Fragrant Rice, 5kg')
  end

end
