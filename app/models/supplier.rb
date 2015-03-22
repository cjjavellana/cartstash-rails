class Supplier < ActiveRecord::Base
  include Utilities::Slug

  before_save :generate_slug

  protected

    def generate_slug
      self.slug = generate(Supplier, name)
    end

end
