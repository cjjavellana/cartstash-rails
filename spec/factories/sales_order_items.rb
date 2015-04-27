FactoryGirl.define do
  factory :sales_order_item do
    sales_order nil
sku "MyString"
name "MyString"
quantity 1.5
price "9.99"
total "9.99"
status "MyString"
remarks "MyString"
discount 1.5
  end

end
