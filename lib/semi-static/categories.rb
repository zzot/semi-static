module SemiStatic
    class Categories < Hash
        def self.slugize(name)
            name.to_s.gsub(/ /, '-').downcase.to_sym
        end
        
        class Category < Array
            attr_reader :slug, :name
            
            def initialize(name, slug)
                @name, @slug = name, slug
            end
        end
        
        # def initialize
        #     super { |hash,key| hash[key] = Category.new(key) }
        # end
        
        def [](name)
            slug = Categories.slugize name
            category = super(slug)
            if category.nil?
                category = Category.new name.to_s, slug
                self[slug] = category
            end
            return category
        end
        
        def slugs
            keys.sort { |l,r| l.to_s <=> r.to_s }
        end
        
        def names
            values.collect { |c| c.name }.sort { |l,r| l.to_s <=> r.to_s }
        end
    end
end
