module SemiStatic
    class Post < Base
        include Convertable
        
        attr_reader :name, :category, :tags
        
        def initialize(path)
            super
            @name = File.basename(source_path, source_ext)
            @category = source_metadata[:category].to_sym
            @tags = source_metadata[:tags].collect { |t| t.to_sym }
        end
    end
end
