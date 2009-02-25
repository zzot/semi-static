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
        
        def nested_values
            result = Hash.new { |hash,key| hash[key] = Hash.new }
            values.each do |item|
                parent, child = item.slug.to_s.split '/'
                if child.nil?
                    result[parent.to_sym][nil] = item
                else
                    result[parent.to_sym][child.to_sym] = item
                end
            end
            
            result.collect do |parent_slug,items|
                parent = items.delete(nil)
                children = items.values.sort { |l,r| l.name.casecmp r.name }
                
                class << parent
                    attr_accessor :slug, :children
                end
                parent.children = children
                parent
            end.sort { |l,r| l.name.casecmp r.name }
        end
        
        def each(options={}, &block)
            list = case options[:order]
            when :name, nil
                values.sort { |l,r| l.name.casecmp r.name }
            when :count
                values.sort { |l,r| r.count <=> l.count }
            when :tree
                nested_values
            else
                raise ArgumentError, "Unknown order: #{options[:order]}"
            end
            list.each(&block)
        end
    end
end
