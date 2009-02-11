module SemiStatic
    class Index < Base
        include Convertable
        
        attr_accessor :posts, :context
        
        def initialize(site, path)
            super
            @metadata = [ :layout ]
        end
    end
end
