module SemiStatic
    class Page < Base
        include Convertable
        
        attr_reader :output_dir, :output_path, :name, :uri
        
        def initialize(site, path)
            super
            @metadata = [ :title, :layout ]
            
            src_base = File.basename(source_path, source_ext)
            output_ext = File.extname(src_base)
            if output_ext.nil? || output_ext.empty?
                output_ext = '.html'
            else
                src_base = File.basename(src_base, output_ext)
            end
            @output_dir, src_file = File.split(source_path)
            
            if output_dir == '.'
                prefix = ''
            else
                prefix = "#{output_dir}/"
            end
            @name = "/#{prefix}#{src_base}"
            @output_path = "#{prefix}#{src_base}#{output_ext}"
            
            if src_base == 'index'
                @uri = "/#{output_dir}/"
            else
                @uri = "/#{output_path}"
            end
        end
    end
end
