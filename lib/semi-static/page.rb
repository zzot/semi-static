module SemiStatic
    class Page < Base
        include Convertable
        
        attr_reader :uri
        
        def initialize(base, path)
            super
            @uri = File.join(dir, "#{name}.html")
        end
    end
end
