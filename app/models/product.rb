class Product < ActiveRecord::Base
  # Dependencies
  include Utilities::Slug

  # Relationships
  belongs_to :product_category

  # Pagination parameter
  paginates_per 12

  # Callbacks
  before_save :generate_slug

  # Internal functions
  protected
    def generate_slug
      self.slug = generate(Product, self.name)
    end

end
