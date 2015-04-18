FactoryGirl.define do

  factory :food_item, class: ProductCategory do
    name          "Food Items"
    description   "Food Items Category"
  end

  factory :household, class: ProductCategory do
    name          "Household Items"
    description   "Household Items Category"
  end

  factory :hygiene, class: ProductCategory do
    name          "Hygience Products"
    description   "Hygience Products"
  end

  factory :babies, class: ProductCategory do
    name          "Babies"
    description   "Babies Items"
  end


  factory :breeze_detergent, class: Product do
    name          "Breeze Washing Machine Detergent, 5kg"
    description   "Breeze Washing Machine Detergent, 5kg"
    price         "175.99"
    cs_sku        "40-100-01"
    uom           "ea"
    association :product_category, factory: :household
  end

  factory :tide_liquid_detergent, class: Product do
    name          "Tide Liquid Detergent, 5L"
    description   "Tide Liquid Detergent, 5L"
    price         "244.99"
    cs_sku        "40-120-01"
    uom           "ea"
    association :product_category, factory: :household
  end
end