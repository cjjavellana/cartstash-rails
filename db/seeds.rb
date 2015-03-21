# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'json'

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
