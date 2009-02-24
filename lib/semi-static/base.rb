module SemiStatic
    class Base
        attr_reader :site, :source_path, :source_ext, :source_content, :source_metadata
        attr_reader :full_source_path
        
        def initialize(site, path)
            @site = site
            @source_path = path
            @source_ext = File.extname(source_path)
            @full_source_path = File.expand_path(source_path)
            @metadata = []
            
            load
        end
        
        def source_mtime
            File.mtime(@full_source_path)
        end
        
        def load
            contents = File.read File.join(full_source_path)
            if contents =~ /^(---\s*\n.*?)\n---\s*\n/m
                @source_content, @source_metadata = contents[($1.size + 5) .. -1], YAML.load($1)
            else
                @source_content, @source_metadata = contents, {}
            end
            @source_metadata.symbolize_keys
        end
        
        def method_missing(method, *args)
            name = method.to_sym
            if @metadata.include?(name)
                return source_metadata[name]
            else
                super
            end
        end
    end
end
