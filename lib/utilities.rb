module Utilities
  module Slug

    def generate(klazz, to_slug)

      k = klazz.new
      unless k.has_attribute?(:slug)
        raise "#{k.class} does not have a slug attribute"
      end

      i = 1
      while true do
        o = klazz.find_by_slug("#{i}-#{to_slug.parameterize}")
        unless o.nil?
          i = i + 1
          next
        end

        break
      end # end while true

      # Return the index-parameterized_value
      "#{i}-#{to_slug.parameterize}"

    end # end generate
  end # end Slug

end
