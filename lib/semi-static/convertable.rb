module SemiStatic
    module Convertable
        def _render(content, site, options={})
            for name, value in options
                eval "#{name.to_s} = options[name]"
            end
            
            case self.source_ext
            when '.haml'
                Haml::Engine.new(self.source_content).render(binding)
            else
                raise ArgumentError, "Unsupported format: #{self.file}"
            end
        end
        
        def render(content, site, options={})
            content = _render(content, site, options)
            unless self.layout.nil?
                content = site.layouts[layout.to_sym].render(content, site, options)
            end
            return content
        end
        
        def content_type_attrs
            { 'http-equiv' => 'Content-type', :content => 'text/html; charset=utf-8' }
        end
        
        def body_attrs
            {}
        end
    end
end
