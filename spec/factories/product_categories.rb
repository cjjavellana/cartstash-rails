FactoryGirl.define do

  factory :rice_and_breads, class: ProductCategory do
    name  "Rice & Breads"
    description  "Rice & Breads"
  end

  factory :thai_rice, class: ProductCategory do
    name  "Thai Rice"
    description  "Thai Rice"

    association :product_category, factory: :rice_and_breads, strategy: :build
  end

  factory :breads, class: ProductCategory do
    name  "Breads"
    description  "Breads"

    association :product_category, factory: :rice_and_breads, strategy: :build
  end
end