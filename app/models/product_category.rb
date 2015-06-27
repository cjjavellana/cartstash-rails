class ProductCategory < ActiveRecord::Base
  include Utilities::Slug

  belongs_to :product_category
  has_many :products, dependent: :destroy

  before_save :generate_slug

  protected
      def generate_slug
        self.slug = generate(ProductCategory, name)
      end

end
