module SemiStatic
    class Post < Base
        include Convertable
        
        attr_reader :name, :category, :tags, :output_dir, :output_path, :slug,
                    :uri, :created, :updated
        
        def initialize(path)
            super
            @metadata = [ :title, :layout, :author ]
            
            @name = File.basename(source_path, source_ext)
            @category = source_metadata[:category].to_sym
            @tags = source_metadata[:tags].collect { |t| t.to_sym }
            
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
            return "http://example.com#{uri}"
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
