class Supplier < ActiveRecord::Base
  include Utilities::Slug

  before_save :generate_slug

  protected

    def generate_slug

      # i = 1
      # while true do
      #   supplier = Supplier.find_by_slug("#{i}-#{name.parameterize}")
      #   unless supplier.nil?
      #     i = i + 1
      #     next
      #   end
      #
      #   self.slug = "#{i}-#{name.parameterize}"
      #   break
      # end

      self.slug = generate(Supplier, name)
    end

end
