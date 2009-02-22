module SemiStatic
    class Stylesheet < Base
        attr_reader :name, :options, :output_dir, :output_path
        
        def initialize(site, name, options={})
            path = "#{name}.sass"
            path = "#{name}.css" unless File.file?(path)
            super(site, path)
            
            @name, @options = name, options
            @output_dir = 'css'
            @output_path = "#{output_dir}/#{name}.css"
            
            @content = case source_ext
            when '.sass'
                Sass::Engine.new(source_content, :filename => source_path).render
            when '.css'
                source_content
            else
                raise ArgumentError, "Unsupported format: #{self.source_path}"
            end
        end
        
        def render
            @content
        end
    end
end
