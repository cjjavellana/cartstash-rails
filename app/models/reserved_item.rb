class ReservedItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  # Retrieves items that have been reserved for more than 30 minutes
  # but not purchased back to the inventory
  def self.return_to_inventory
    items = ReservedItem.where("updated_at < ?", Time.current - 2.hours)

    items.each do |item|
      product = Product.find(item.product_id)
      product.update_attribute(:qty, product.qty + item.qty)
      item.destroy
    end

  end

end
