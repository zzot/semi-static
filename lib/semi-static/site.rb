module SemiStatic
    class Site
        attr_reader :source_dir, :layouts
        
        def initialize(source_dir)
            @source_dir = source_dir
            init_layouts
        end
        
      private
        def with_source_dir
            raise ArgumentError unless block_given?
            Dir.chdir(source_dir) do
                yield
            end
        end
        
        def init_layouts
            @layouts = Hash.new
            with_source_dir do
                Dir.glob('_layouts/*') do |path|
                    next unless File.file?(path)
                    file = File.basename(path)
                    if file[0..0] != '_'
                        layout = Layout.new self.source_dir, path
                        self.layouts[layout.name.to_sym] = layout
                    end
                end
            end
        end
    end
end
