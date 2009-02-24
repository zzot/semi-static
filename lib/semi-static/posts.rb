module SemiStatic
    class Posts
        attr_reader :site, :posts, :names, :indices
        
        def initialize(site)
            @site = site
            @posts = []
            @names = {}
            @indices = Set.new
        end
        
        NAME_RE = /^([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/
        
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
        
        def length
            self.posts.length
        end
        
        def first(n=nil)
            self.posts.first(n)
        end
        
        def last(n=nil)
            self.posts.last(n).reverse
        end
        
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
        
        def [](name)
            return self.names[name]
        end
        
        def each(&block)
            self.posts.each(&block)
        end
        
        def each_index(&block)
            indices.each(&block)
        end
    end
end
