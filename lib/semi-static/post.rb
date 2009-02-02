module SemiStatic
    class Post < Base
        include Convertable
        
        attr_reader :name, :category, :tags, :output_dir, :output_path, :slug,
                    :uri, :created, :updated
        
        def initialize(site, path)
            super
            @metadata = [ :title, :layout, :author ]
            
            @name = File.basename(source_path, source_ext)
            
            @category = site.categories[source_metadata[:category]]
            @category << self
            
            @tags = []
            for tag in source_metadata[:tags]
                @tags << site.tags[tag]
                @tags.last << self
            end 
            
            if name =~ /^(\d+-\d+-\d+)-(.+)$/
                @created = Date.parse $1
                @slug = $2
                @output_path = created.strftime('%Y/%m/%d/') + "#{slug}.html"
                @uri = "/#{output_path}"
            else
                raise ArgumentError, "Bad file name: #{name}"
            end
        end
        
        def id
            name.gsub /-/, '_'
        end
        
        def permalink
            return "#{uri}"
        end
        
        def comments_link
            "#{uri}#comments"
        end
        
        def comment_count
            0
        end
        
        def date
            created.strftime '%B %e, %Y'
        end
        
        def time?
            false
        end
    end
end