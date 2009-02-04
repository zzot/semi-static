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
        def with_source_files(subdir, pattern)
            raise ArgumentError unless block_given?
            Dir.chdir(File.join(source_dir, subdir)) do
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
            with_source_files('layouts', '*.haml') do |path|
                next unless File.file?(path)
                
                file = File.basename(path)
                if file[0..0] != '_'
                    layout = Layout.new self, path
                    self.layouts[layout.name.to_sym] = layout
                end
            end
        end
        
        def load_pages
            @pages = Hash.new
            with_source_files('pages', '**/*.{html,haml,txt,md,markdown}') do |path|
                next if File.directory?(path)
                next unless path.split('/').grep(/^_/).empty?
                
                page = Page.new self, path
                self.pages[page.name] = page
            end
        end
        
        def load_posts
            @posts = Hash.new
            @categories = Categories.new
            @tags = Categories.new
            with_source_files('posts', '*.{html,haml,txt,md,markdown}') do |path|
                next unless File.file?(path)
                
                file = File.basename(path)
                if file[0..0] != '_'
                    post = Post.new self, path
                    self.posts[post.name] = post
                end
            end
        end
    end
end
