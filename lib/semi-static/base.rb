module SemiStatic
    class Base
        attr_reader :dir, :file, :name, :ext, :content, :metadata
        
        def initialize(path)
            @dir, @file = File.split(path)
            @ext = File.extname(file)
            @name = File.basename(file, ext)
            
            load
        end
        
        def load
            contents = File.read File.join(dir, file)
            if contents =~ /^(---\s*\n.*?)\n---\s*\n/m
                @content, @metadata = contents[($1.size + 5) .. -1], YAML.load($1)
            else
                @content, @metadata = contents, {}
            end
        end
        
        def method_missing(method, *args)
            return metadata[method.to_s]
        end
    end
end
