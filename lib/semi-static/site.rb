module SemiStatic
    class Site
        attr_reader :source_dir, :layouts, :pages, :posts, :categories, :tags
        
        def initialize(source_dir)
            @source_dir = source_dir
            
            load
        end
        
        def self.open(source_dir)
            raise ArugmentError, "block required" unless block_given?
            site = SemiStatic::Site.new source_dir
            yield site
        end
        
      private
        def with_source_files(pattern)
            raise ArgumentError unless block_given?
            Dir.chdir(source_dir) do
                Dir.glob(pattern) do |path|
                    yield path
                end
            end
        end
        
        def load
            load_layouts
            load_pages
            load_posts
        end
        
        def load_layouts
            @layouts = Hash.new
            with_source_files('_layouts/*.haml') do |path|
                next unless File.file?(path)
                
                file = File.basename(path)
                if file[0..0] != '_'
                    layout = Layout.new path
                    self.layouts[layout.name.to_sym] = layout
                end
            end
        end
        
        def load_pages
            @pages = Hash.new
            with_source_files('**/*.{html,haml,txt,md,markdown}') do |path|
                next if File.directory?(path)
                next unless path.split('/').grep(/^_/).empty?
                
                page = Page.new path
                self.pages[page.name] = page
            end
        end
        
        def load_posts
            @posts = Hash.new
            @categories = Hash.new { |hash,key| hash[key] = Array.new }
            @tags = Hash.new { |hash,key| hash[key] = Array.new }
            with_source_files('_posts/*.{html,haml,txt,md,markdown}') do |path|
                next unless File.file?(path)
                
                file = File.basename(path)
                if file[0..0] != '_'
                    post = Post.new path
                    # puts post.name
                    self.posts[post.name] = post
                    self.categories[post.category] << post
                    post.tags.each { |tag| self.tags[tag] << post }
                end
            end
        end
    end
end
