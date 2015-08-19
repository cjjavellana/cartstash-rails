FactoryGirl.define do

  factory :rice_and_breads, class: ProductCategory do
    name  "Rice & Breads"
    description  "Rice & Breads"
    slug "1-rice-breads"
  end

  factory :thai_rice, class: ProductCategory do
    name  "Thai Rice"
    description  "Thai Rice"
    slug "1-thai-rice"

    association :product_category, factory: :rice_and_breads, strategy: :build
  end

  factory :breads, class: ProductCategory do
    name  "Breads"
    description  "Breads"
    slug "1-breads"

    association :product_category, factory: :rice_and_breads, strategy: :build
  end
end
