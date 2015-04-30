FactoryGirl.define do
  factory :sales_order_item do
    sku "01-0001-00001"
    name "Kleenex Facial Tissue 170 Sheets x 2 Ply, box of 5"
    quantity 2
    price 55.49
    total 110.98
    status "active"
    remarks nil
    discount 0.0

    association :sales_order, factory: :sales_order, strategy: :build
  end

end
