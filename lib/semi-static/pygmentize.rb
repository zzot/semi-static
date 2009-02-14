module SemiStatic
    module Pygmentize
        LEXER_FORMAT = /^[a-z]+$/i
        
        def pygmentize(code, lang)
            Pygmentize.pygmentize code, lang
        end
        
        def self.pygmentize(code, lang)
            unless lang =~ LEXER_FORMAT
                raise ArgumentError, "invalid lexer: #{lang}"
            end
            
            Tempfile.open('semistatic-pygmentize') do |temp|
                temp.write code
                temp.close
                
                cmd = "pygmentize -f html -l #{lang} #{temp.path}"
                IO.popen(cmd) do |proc|
                    return proc.read
                end
            end
        end
    end
end

module MaRuKu
    module Out::HTML
        def to_html_code
            source = self.raw_code
            lang = self.attributes[:lang] || 'text'
            html = SemiStatic::Pygmentize.pygmentize source, lang
            doc = Document.new html, :respect_whitespace => :all
            
            add_ws doc.root
        end
    end
end
