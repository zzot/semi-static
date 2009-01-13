module SemiStatic
    module Convertable
        def render(content, site, options={})
            for name, value in options
                eval "#{name.to_s} = options[name]"
            end
            
            case self.ext
            when '.haml'
                Haml::Engine.new(self.content).render(binding)
            else
                raise ArgumentError, "Unsupported format: #{self.file}"
            end
        end
        
        def content_type_attrs
            { 'http-equiv' => 'Content-type', :content => 'text/html; charset=utf-8' }
        end
        
        def body_attrs
            {}
        end
    end
end
