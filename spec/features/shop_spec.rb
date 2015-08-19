require 'rails_helper'

describe 'Index Page' do

  before do
    products = [
      {
        name: 'Rice & Breads',
        slug: '1-rice-breads',
        products: [
          build_stubbed(:thai_fragrant_rice)
        ]
      }
    ]
    RedisClient.set "shop_index", products.to_json

    categories = [
      build_stubbed(:rice_and_breads),
      build_stubbed(:thai_rice),
      build_stubbed(:breads)
    ]

    RedisClient.set "menu_categories", categories.to_json
  end

  it 'displays the main page when root url is visited' do
    visit root_path
    expect(page).to have_selector('.login-btn')
    expect(page).to have_selector('.signup-btn')
    expect(page).to have_selector('.product-item')
    expect(page).to have_selector('.left-menu')
  end

end
