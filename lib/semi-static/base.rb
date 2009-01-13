module SemiStatic
    class Base
        attr_reader :source_path, :source_ext, :source_content, :source_metadata
        
        def initialize(path)
            @source_path = path
            @source_ext = File.extname(source_path)
            
            load
        end
        
        def load
            contents = File.read File.join(source_path)
            if contents =~ /^(---\s*\n.*?)\n---\s*\n/m
                @source_content, @source_metadata = contents[($1.size + 5) .. -1], YAML.load($1)
            else
                @source_content, @source_metadata = contents, {}
            end
        end
        
        def method_missing(method, *args)
            return source_metadata[method.to_s]
        end
    end
end
