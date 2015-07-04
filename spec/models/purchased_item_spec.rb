require 'rails_helper'

describe PurchasedItem do

  it 'can store the product detail' do

    p = build_stubbed(:thai_fragrant_rice)

    purchased_item = PurchasedItem.new(
        {
            :name => p.name,
            :price => p.price,
            :sku => p.cs_sku,
            :quantity => 10,
            :image_front => p.image_front
        }
    )

    expect(purchased_item.name).to eq('Thai Fragrant Rice, 5kg')
    expect(purchased_item.image_front).to eq('http://lorempixel.com/100/130/food/')
  end

end