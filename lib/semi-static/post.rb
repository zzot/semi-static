module SemiStatic
    # Post represents a single post in the site.  Post itself only
    # represents a single source file, but can have a Layout and any number
    # of Snippets, each of which has its own source file.  Post's modification
    # time is the most recent of itself, its Layout, and any Snippets used.
    class Post < Base
        include Convertable
        
        ##
        # The Post's name
        attr_reader :name
        
        ##
        # The Post's Tags
        attr_reader :tags
        
        ##
        # The Post's output directory
        attr_reader :output_dir
        
        ##
        # The Post's output path
        attr_reader :output_path
        
        ##
        # The Post's slug
        attr_reader :slug
        
        ##
        # The Post's URI
        attr_reader :uri
        
        ##
        # Date Post was created
        attr_reader :created
        
        ##
        # Date the Post was last updated
        attr_reader :updated
        
        # attr_reader :year
        # attr_reader :month
        # attr_reader :day
        
        ##
        # Initializes a new Post
        #
        # +site+:: The Site object we belong to
        # +path+:: The relative path to the source file
        def initialize(site, path)
            super
            @metadata = [ :title, :layout, :author ]
            
            @name = File.basename(source_path, source_ext)
            
            @tags = []
            unless source_metadata[:tags].nil?
                for tag in source_metadata[:tags]
                    @tags << site.tags[tag]
                    @tags.last << self
                end
            end
            
            if name =~ /^(\d+-\d+-\d+)-(.+)$/
                @created = Time.parse $1
                @updated ||= @created
                @slug = $2
                @output_dir = created.strftime('%Y/%m/%d')
                @output_path = File.join output_dir, "#{slug}.html"
                @uri = "/#{output_path}"
            else
                raise ArgumentError, "Bad file name: #{name}"
            end
        end
        
        ##
        # Get the Post's unique identifier
        def id
            name.gsub /-/, '_'
        end
        
        ##
        # Get the Post's permalink
        def permalink
            return "#{uri}"
        end
        
        # def comments_link
        #     "#{uri}#comments"
        # end
        # 
        # def comment_count
        #     0
        # end
        
        ##
        # Formatted date the Post was published (i.e., "March 15, 2009")
        def date
            created.strftime '%B %e, %Y'
        end
        
        ##
        # Year the Post was published as a String (i.e., "2009")
        def year
            created.strftime '%Y'
        end
        
        ##
        # Month the Post was published as a String (i.e., "03")
        def month
            created.strftime '%m'
        end
        
        ##
        # Day the Post was published as a String (i.e., "15")
        def day
            created.strftime '%d'
        end
        
        ##
        # Does the post have a Time set?
        def time?
            false
        end
    end
end
