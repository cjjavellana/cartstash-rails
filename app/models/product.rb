class Product < ActiveRecord::Base
  # Dependencies
  include Utilities::Slug

  # Relationships
  belongs_to :ProductCategory

  # Pagination parameter
  paginates_per 8

  # Callbacks
  before_save :generate_slug

  # Internal functions
  protected
    def generate_slug
      self.slug = generate(Product, self.name)
    end

end
