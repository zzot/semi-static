module SemiStatic
    class Base
        attr_reader :base, :dir, :file, :name, :ext, :content, :data
        
        def initialize(base, path)
            @base = base
            @dir, @file = File.split(path)
            @ext = File.extname(file)
            @name = File.basename(file, ext)
            
            load
        end
        
        def load
            contents = File.read File.join(dir, file)
            @content, @data = contents, {}
        end
    end
end
