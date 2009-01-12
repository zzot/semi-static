module SemiStatic
    class Site
        attr_reader :source_dir
        
        def initialize(source_dir)
            @source_dir = source_dir
        end
    end
end
