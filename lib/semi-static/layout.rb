module SemiStatic
    class Layout < Base
        include Convertable
        
        attr_reader :name
        
        def initialize(path)
            super
            @name = File.basename(source_path, source_ext)
        end
    end
end
