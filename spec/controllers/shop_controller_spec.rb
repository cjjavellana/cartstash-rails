require 'rails_helper'

RSpec.describe ShopController, type: :controller do

  let(:products) {
    %{
    [
      {
        "slug": "1-rice-breads",
        "name": "Rice & Breads",
        "products": [
          {
            "id": 1,
            "name": "Thai Fragrant Rice"
          }
        ]
      }
    ]
    }
  }

  let(:categories) {
    [
        build_stubbed(:rice_and_breads)
    ]
  }

  let(:rice) {
    [
        build_stubbed(:thai_fragrant_rice)
    ]
  }

  it 'lists the product categories' do
    expect(RedisClient).to receive(:get).with("cart_#{session.id}").and_return nil
    expect(RedisClient).to receive(:get).with('shop_index').and_return products
    expect(RedisClient).to receive(:get).with('menu_categories').and_return products

    get :index
    expect(assigns(:products)[0][:name]).to eq('Rice & Breads')
    expect(assigns(:categories)[0][:slug]).to eq('1-rice-breads')
    expect(response).to have_http_status :success
  end

  it 'queries from the database when products are not in cache' do
    expect(RedisClient).to receive(:get).with("cart_#{session.id}").and_return nil
    expect(RedisClient).to receive(:get).with('shop_index').and_return nil
    expect(RedisClient).to receive(:get).with('menu_categories').and_return products

    expect(ProductCategory).to receive(:where).and_return(categories)
    expect(Product).to receive_message_chain(:joins, :where, :limit).and_return(rice)
    expect(RedisClient).to receive(:set)

    get :index
    expect(assigns(:products)[0][:name]).to eq('Rice & Breads')
    expect(assigns(:categories)[0][:slug]).to eq('1-rice-breads')
    expect(response).to have_http_status :success
  end


end
