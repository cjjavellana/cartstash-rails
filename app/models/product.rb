class Product < ActiveRecord::Base
  # Dependencies
  include Utilities::Slug

  # Relationships
  belongs_to :product_category

  # Pagination parameter
  paginates_per 12

  # Callbacks
  before_save :generate_slug

  # Retrieves the list of products under a given
  # category or subcategory
  def self.products_by_category(category_slug)
    category = RedisClient.get "_prod_category_#{category_slug}"
    if category.nil?
      category = ProductCategory.find_by_slug(category_slug)
      category = category.as_json.symbolize_keys
      products = Product.joins(:product_category).where(%{products.product_category_id = ? or
        products.product_category_id in (
          select id from product_categories where product_category_id = ?
          )}, category[:id], category[:id])
      category[:products] = products.inject([]) { | arr, product | arr.append(product.as_json.symbolize_keys)}
      RedisClient.set "_prod_category_#{category_slug}", category.to_json
      category
    else
      JSON.parse category, :symbolize_names => true
    end
  end

  # Internal functions
  protected
    def generate_slug
      self.slug = generate(Product, self.name)
    end

end
