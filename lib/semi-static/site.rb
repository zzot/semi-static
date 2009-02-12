module SemiStatic
    class Site
        attr_reader :source_dir, :layouts, :pages, :posts, :categories, :tags
        attr_reader :year_index, :month_index, :day_index
        attr_reader :metadata, :stylesheets
        
        def initialize(source_dir)
            @source_dir = source_dir
            
            load
        end
        
        def self.open(source_dir)
            raise ArugmentError, "block required" unless block_given?
            site = SemiStatic::Site.new source_dir
            yield site
        end
        
        def output(path)
            FileUtils.mkdir_p path
            Dir.chdir(path) do
                pages.each do |name, page|
                    FileUtils.mkdir_p page.output_dir unless File.directory?(page.output_dir)
                    File.open(page.output_path, 'w') { |f| f.write page.render }
                end

                posts.each do |name, post|
                    FileUtils.mkdir_p post.output_dir unless File.directory?(post.output_dir)
                    File.open(post.output_path, 'w') { |f| f.write post.render }
                end
                
                unless stylesheets.nil?
                    stylesheets.each do |name, stylesheet|
                        FileUtils.mkdir_p stylesheet.output_dir unless File.directory?(stylesheet.output_dir)
                        File.open(stylesheet.output_path, 'w') { |f| f.write stylesheet.render }
                    end
                end
                
                unless year_index.nil? && month_index.nil? && day_index.nil?
                    posts.each_index do |dir, posts|
                        Dir.chdir(dir) do
                            context = dir.split('/').collect { |c| c.to_i }
                            date_index = case context.length
                            when 1
                                year_index
                            when 2
                                month_index
                            when 3
                                day_index
                            else
                                nil
                            end
                            date_index.posts = posts
                            date_index.context = Date.new *context
                            File.open('index.html', 'w') { |f| f.write date_index.render }
                        end
                    end
                end
            end
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
        
        def config_file_path
            File.join source_dir, 'semi.yml'
        end
        
        def load
            if File.file?(config_file_path)
                @metadata = File.open(config_file_path) { |io| YAML.load io }
            end
            load_stylesheets
            load_layouts
            load_pages
            load_posts
            load_indices
        end
        
        def load_stylesheets
            unless metadata.nil? || metadata['stylesheets'].nil?
                Dir.chdir(File.join(source_dir, 'stylesheets')) do
                    config = metadata['stylesheets']
                    if config.is_a?(Array)
                        config = config.inject({}) { |hash,name| hash[name] = {}; hash }
                    end
                    @stylesheets = config.inject({}) do |hash,pair|
                        name, opts = pair
                        hash[name.to_sym] = Stylesheet.new self, name, opts
                        hash
                    end
                end
            end
        end
        
        def load_layouts
            @layouts = Hash.new
            with_source_files('layouts', '*.{haml,erb}') do |path|
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
            @posts = Posts.new(self)
            @categories = Categories.new
            @tags = Categories.new
            with_source_files('posts', '*.{html,haml,txt,md,markdown}') do |path|
                posts << path
            end
        end
        
        def load_indices
            return unless File.directory?(File.join(source_dir, 'indices'))
            
            with_source_files('indices', '{year,month,day}.{haml,erb}') do |path|
                # puts path
                next unless File.file?(path)
                
                file = File.basename(path)
                name = File.basename(file, File.extname(file))
                case name
                when 'year'
                    @year_index = Index.new self, path
                when 'month'
                    @month_index = Index.new self, path
                when 'day'
                    @day_index = Index.new self, path
                else
                    raise ArgumentError, "Unexpected index file: #{path}"
                end
            end
        end
    end
end
