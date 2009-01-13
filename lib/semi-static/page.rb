module SemiStatic
    class Page < Base
        include Convertable
        
        attr_reader :output_dir, :output_path, :name, :uri
        
        def initialize(path)
            super
            
            src_base = File.basename(source_path, source_ext)
            @output_dir, src_file = File.split(source_path)
            @name = File.join(output_dir, src_base)
            @output_path = "#{name}.html"
            if src_base == 'index'
                @uri = File.join(output_dir, '')
            else
                @uri = output_path
            end
        end
    end
end
