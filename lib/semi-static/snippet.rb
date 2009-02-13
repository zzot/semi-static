module SemiStatic
    class Snippet < Base
        include Convertable
        
        attr_reader :name
        
        def initialize(site, path)
            super
            @name = File.basename(source_path, source_ext)
        end
    end
end
