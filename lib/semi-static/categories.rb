module SemiStatic
    ##
    # A group of posts in the site that have the same category or tag in
    # their metadata.
    class Category < Array
        ##
        # Display name (i.e., Semi Static)
        attr_reader :name
        
        ##
        # URL-ified name (i.e., semi-static)
        attr_reader :slug
        
        ##
        # Initializes a new Category
        #
        # +name+: The Category's name
        # +slug+: The Category's slug
        def initialize(name, slug)
            @name, @slug = name, slug
        end
    end
    
    ##
    # A list of all categories (or tags) in the site.
    class Categories < Hash
        ##
        # Convert the given display name to a URL-ified one.
        def self.slugize(name)
            name.to_s.gsub(/ /, '-').downcase.to_sym
        end
        
        ##
        # Find the category with the given name.
        #
        # +name+: The Category's name (either its dipslay name or URL-ified name).
        def [](name)
            slug = Categories.slugize name
            category = super(slug)
            if category.nil?
                category = Category.new name.to_s, slug
                self[slug] = category
            end
            return category
        end
        
        ##
        # List all categories' URL-ified names, sorted alphabetically.
        def slugs
            keys.sort { |l,r| l.to_s <=> r.to_s }
        end
        
        ##
        # List all categories' display names, sorted alphabetically.
        def names
            values.collect { |c| c.name }.sort { |l,r| l.to_s <=> r.to_s }
        end
        
        ##
        # Use each category's name as a path, and arrange them into tree.
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
        
        ##
        # Iterate over all categories
        #
        # +order+ can be:
        #   +:name+:   Sorted alphabetically by display name
        #   +:count+:  Sorted by post count, largest to smallest
        #   +:tree+:   Sorted alphabetically bo display name and arranged into a tree
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
