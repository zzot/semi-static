module SemiStatic
    class Base
        attr_reader :base, :dir, :file, :name, :ext
        
        def initialize(base, path)
            @base = base
            @dir, @file = File.split(path)
            @ext = File.extname(file)
            @name = File.basename(file, ext)
        end
    end
end
