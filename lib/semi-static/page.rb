module SemiStatic
    class Page < Base
        include Convertable
        
        attr_reader :output_dir, :output_path, :name, :uri
        
        def initialize(path)
            super
            
            src_base = File.basename(source_path, source_ext)
            @output_dir, src_file = File.split(source_path)
            
            if output_dir == '.'
                prefix = ''
            else
                prefix = "#{output_dir}/"
            end
            @name = "/#{prefix}#{src_base}"
            @output_path = "#{prefix}#{src_base}.html"
            
            if src_base == 'index'
                @uri = "/#{output_dir}/"
            else
                @uri = "/#{output_path}"
            end
        end
    end
end
