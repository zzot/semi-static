module SemiStatic
    class Posts
        attr_reader :site, :posts, :length

        def initialize(site)
            @site = site
            @posts = Hash.new do |years,year|
                years[year] = Hash.new do |months,month|
                    months[month] = Hash.new do |days,day|
                        days[day] = Hash.new
                    end
                end
            end
            @length = 0
        end
        
        def <<(path)
            file = File.basename(path)
            if File.file?(path) && file[0..0] != '_'
                post = Post.new site, path
                posts[post.year][post.month][post.day][post.slug] = post
                @length += 1
            end
        end
        
        def [](name)
            path = name.split('-', 4)
            return nil unless path.length == 4
            
            hash = posts
            while hash.is_a?(Hash) && path.length > 0
                hash = hash[path.shift]
            end
            return hash if hash.is_a?(Post)
        end
    end
end

