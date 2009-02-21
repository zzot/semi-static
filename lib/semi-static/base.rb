module SemiStatic
    class Base
        attr_reader :site, :source_path, :source_ext, :source_content, :source_metadata
        
        def initialize(site, path)
            @site = site
            @source_path = path
            @source_ext = File.extname(source_path)
            @metadata = []
            
            load
        end
        
        def load
            contents = File.read File.join(source_path)
            if contents =~ /^(---\s*\n.*?)\n---\s*\n/m
                @source_content, @source_metadata = contents[($1.size + 5) .. -1], YAML.load($1)
            else
                @source_content, @source_metadata = contents, {}
            end
            @source_metadata.symbolize_keys
        end
        
        def time(context)
            raise ArgumentError, "block required" unless block_given?
            before = Time.now
            value = yield
            after = Time.now
            
            unless site.stats.nil?
                time = (after - before)
                site.stats["#{self.class.name.split('::').last}"] << time
                # site.stats[context] << time
            end
            
            return value
        end
        
        def method_missing(method, *args)
            name = method.to_sym
            if @metadata.include?(name)
                return source_metadata[name]
            else
                super
            end
        end
    end
end
