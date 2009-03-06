module SemiStatic
    class Site
        ##
        # Clean the output directory before generating the site.
        attr_accessor :clean_first
        
        ##
        # Only generate a file if its source files are newer than its output file.
        attr_accessor :check_mtime
        
        ##
        # Only process a few posts, to speed up template editing.
        attr_accessor :quick_mode
        
        ##
        # Show conversion stats after outputting the site.
        attr_accessor :show_statistics
        
        ##
        # List of every Layout in the site.
        attr_reader :layouts
        
        ##
        # List of every Page in the site.
        attr_reader :pages
        
        ##
        # List of every Post in the site.
        attr_reader :posts
        
        ##
        # List of every Snippet in the site.
        attr_reader :snippets
        
        ##
        # List of every Stylesheet in the site.
        attr_reader :stylesheets
        
        ##
        # List of all Tags in the site.
        attr_reader :tags
        
        ##
        # Template used to generate the year indices in the output site.
        attr_reader :year_index
        
        ##
        # Template used to generate the month indices in the output site.
        attr_reader :month_index
        
        ##
        # Template used to generate the day indices in the output site.
        attr_reader :day_index
        
        ##
        # Template used to generate the tag indices in the output site.
        attr_reader :tag_index
        
        ##
        # Site configuration.
        attr_reader :metadata
        
        ##
        # Statistics for the conversion process.
        attr_reader :stats
        
        ##
        # Site source directory.
        attr_reader :source_dir
        
        ##
        # Time the output was generated.
        attr_reader :time
        
        ##
        # Initializes a new Site with the given source directory.
        def initialize(source_dir)
            @clean_first = false
            @first_pass = true
            @quick_mode = false
            @check_mtime = false
            @show_statistics = false
            @source_dir = source_dir
            @time = Time.now
            @stats = Statistics.new
            stats.record(:site, :load) { load }
        end
        
        ##
        # Creates a Site with the given source directory and yields it to the
        # given block.
        def self.open(source_dir)
            raise ArugmentError, "block required" unless block_given?
            site = SemiStatic::Site.new source_dir
            yield site
        end
        
        ##
        # Write the Site to the given output directory.
        def output(path)
            if @first_pass
                @first_pass = false
                FileUtils.rm_rf path if clean_first
            end
            FileUtils.mkdir_p path
            
            if quick_mode
                posts.chop! 20
            end
            @stats.reset
            
            unless metadata.nil? || !metadata['static'].is_a?(Array)
                stats.record(:site, :static) do
                    for dir in metadata['static']
                        FileUtils.cp_r File.join(source_dir, dir), File.join(path, dir)
                    end
                end
            end
            
            before = Time.now
            Dir.chdir(path) do
                stats.record(:site, :pages) do
                    pages.each do |name, page|
                        FileUtils.mkdir_p page.output_dir unless File.directory?(page.output_dir)
                        if check_mtime
                            if File.file?(page.output_path) && File.mtime(page.output_path) > page.source_mtime
                                next
                            end
                            page.load
                        end
                        File.open(page.output_path, 'w') { |f| f.write page.render }
                    end
                end
                
                stats.record(:site, :posts) do
                    posts.each do |post|
                        FileUtils.mkdir_p post.output_dir unless File.directory?(post.output_dir)
                        if check_mtime
                            if File.file?(post.output_path) && File.mtime(post.output_path) > post.source_mtime
                                next
                            end
                            post.load
                        end
                        File.open(post.output_path, 'w') { |f| f.write post.render }
                    end
                end
                
                stats.record(:site, :stylesheets) do
                    unless stylesheets.nil?
                        stylesheets.each do |name, stylesheet|
                            FileUtils.mkdir_p stylesheet.output_dir unless File.directory?(stylesheet.output_dir)
                            if check_mtime
                                if File.file?(stylesheet.output_path) && File.mtime(stylesheet.output_path) > stylesheet.source_mtime
                                    next
                                end
                                stylesheet.load
                            end
                            File.open(stylesheet.output_path, 'w') { |f| f.write stylesheet.render }
                        end
                    end
                end
                
                stats.record(:site, :indices) do
                    unless year_index.nil? && month_index.nil? && day_index.nil?
                        posts.each_index do |dir|
                            posts = self.posts.from(dir)
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
                                date_index.context = Time.local *context
                                File.open('index.html', 'w') { |f| f.write date_index.render }
                            end
                        end
                    end
                    
                    unless tag_index.nil?
                        tags.each do |tag|
                            tag_index.context = tag.name
                            tag_index.posts = tag
                            FileUtils.mkdir_p tag.output_dir
                            File.open(tag.output_path, 'w') { |f| f.write tag_index.render }
                        end
                    end
                end
            end
            
            self.stats.display if show_statistics
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
            load_snippets
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
            with_source_files('pages', '**/*.{html,haml,erb,txt,md,markdown}') do |path|
                next if File.directory?(path)
                next unless path.split('/').grep(/^_/).empty?
                
                page = Page.new self, path
                self.pages[page.name] = page
            end
        end
        
        def load_posts
            @posts = Posts.new(self)
            @tags = Tags.new :tag
            with_source_files('posts', '*/*/*/*.{html,haml,erb,txt,md,markdown}') do |path|
                posts << path
            end
            posts.posts.sort! { |l,r| l.created <=> r.created }
        end
        
        def load_snippets
            return unless File.directory?(File.join(source_dir, 'snippets'))
            
            @snippets = Hash.new
            with_source_files('snippets', '*.{html,haml,erb,txt,md,markdown}') do |path|
                next unless File.file?(path)
                next unless ('a'..'z').include?(path[0..0].downcase)
                
                snippet = Snippet.new self, path
                self.snippets[snippet.name] = snippet
            end
        end
        
        def load_indices
            return unless File.directory?(File.join(source_dir, 'indices'))
            
            with_source_files('indices', '{year,month,day,tag}.{haml,erb}') do |path|
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
                when 'tag'
                    @tag_index = Index.new self, path
                else
                    raise ArgumentError, "Unexpected index file: #{path}"
                end
            end
        end
    end
end
