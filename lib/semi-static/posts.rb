module SemiStatic
    ##
    # Collection of Posts for the current site.
    class Posts
        ##
        # The Site object we belong to.
        attr_reader :site
        
        ##
        # The raw list of posts.
        attr_reader :posts
        
        ##
        # Posts indexed by name.
        attr_reader :names
        
        ##
        # Indices that correspond to the Posts.
        attr_reader :indices
        
        ##
        # Initializes a new Posts
        #
        # +site+: The Site we belong to.
        def initialize(site)
            @site = site
            @posts = []
            @names = {}
            @indices = Set.new
        end
        
        ##
        # The format of the Date portion of a post's filename.
        NAME_RE = /^([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/
        
        ##
        # Parse the given file as a Post and add it to the list.
        #
        # +source_path+: Path to the source file
        def <<(source_path)
            unless File.file?(source_path)
                $stderr.puts "[#{source_path}]"
                return
            end
            if source_path =~ NAME_RE
                post = Post.new site, source_path
                self.posts.push post
                names[post.name] = post
                indices << File.join(post.year, post.month, post.day)
                indices << File.join(post.year, post.month)
                indices << post.year
            else
                $stderr.puts "{#{source_path}}"
            end
        end
        
        ##
        # Truncate the list of Posts to the given number (to speed up testing).
        #
        # +count+: The number of posts to keep.
        def chop!(count)
            raise ArgumentError unless count > 0
            posts = self.posts.first(count)
            @posts = []
            @names = {}
            @indices = Set.new
            for post in posts
                self.posts << post
                names[post.name] = post
                indices << File.join(post.year, post.month, post.day)
                indices << File.join(post.year, post.month)
                indices << post.year
            end
        end
        
        ##
        # Number of posts.
        def length
            self.posts.length
        end
        
        ##
        # Fetch the least recent posts.
        #
        # +n+: Number of Posts to return.
        def first(n=nil)
            if n.nil?
                self.posts.first
            else
                self.posts.first(n)
            end
        end
        
        ##
        # Fetch the most recent posts.
        #
        # +n+: Number of Posts to return.
        def last(n=nil)
            if n.nil?
                self.posts.last
            else
                self.posts.last(n).reverse
            end
        end
        
        ##
        # Fetch the Posts for the given Date range.
        def from(year, month=nil, day=nil)
            if year.is_a?(String) && month.nil? && day.nil?
                date = year.split('/', 3)
                year, month, day = date.collect { |c| c.to_i }
            end
            
            if month.nil?
                from = Time.local year
                to = Time.local(year + 1) - 1
            elsif day.nil?
                from = Time.local year, month
                if month == 12
                    to = Time.local(year + 1, 1) - 1
                else
                    to = Time.local(year, month + 1) - 1
                end
            else
                from = Time.local year, month, day
                to = Time.local year, month, day, 23, 59, 59
            end
            range = from..to
            result = self.posts.select { |p| range.include?(p.created) }
            class << result
                alias_method :last_without_reverse, :last
                def last_with_reverse(n=nil)
                    last_without_reverse(n).reverse
                end
                alias_method :last, :last_with_reverse
            end
            return result
        end
        
        ##
        # Get the post with the given name.
        def [](name)
            return self.names[name]
        end
        
        ##
        # Iterate over all posts.
        def each(&block) # :yields: Post
            self.posts.each(&block)
        end
        
        ##
        # Iterate over all indices.
        def each_index(&block) # :yields: String
            indices.each(&block)
        end
    end
end
