# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'json'
require 'factory_girl_rails'

supplier_json = ActiveSupport::JSON.decode(File.read('db/seeds/supplier.json'))
supplier_json.each do |data|
  supplier = Supplier.new
  supplier.name = data['name']
  supplier.phone_no = data['phone_no']
  supplier.address_line_1 =  data['address_line_1']
  supplier.address_line_2 =  data['address_line_2']
  supplier.zip = data['zip']
  supplier.country = data['country']
  supplier.save
end

product_categories_json = ActiveSupport::JSON.decode(File.read('db/seeds/product_categories.json'))
product_categories_json.each do |data|
  product_category = ProductCategory.new
  product_category.name = data['name']
  product_category.description = data['description']
  product_category.save
end

products_json = ActiveSupport::JSON.decode(File.read('db/seeds/products.json'))
products_json.each do |data|
  product = Product.new
  product.name = data['name']
  product.description = data['description']
  product.price = data['price']
  product.product_category_id = data['product_category_id']
  product.cs_sku = data['cs_sku']
  product.save
end

credit_card_types_json = ActiveSupport::JSON::decode(File.read('db/seeds/credit_card_types.json'))
credit_card_types_json.each do |data|
  cc_type = CreditCardType.new
  cc_type.name = data['name']
  cc_type.description = data['description']
  cc_type.save
end

countries_json = ActiveSupport::JSON::decode(File.read('db/seeds/countries.json'))
countries_json.each do |data|
  country = Country.new
  country.name = data['name']['common']
  country.country_code = data['callingCode'][0]
  country.short_name = data['cca2']
  country.save
end

FactoryGirl.create :foobar_visa