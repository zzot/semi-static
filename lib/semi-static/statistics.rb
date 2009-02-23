module SemiStatic
    class Statistics
        def initialize
            @data = Hash.new { |hash,key| hash[key] = Hash.new }
        end
        
        def record(category, item)
            raise ArgumentError unless block_given?
            before = Time.now
            result = yield
            @data[category][item] = Time.now - before
            return result
        end
        
        def display
            details = {}
            @data.each do |category,items|
                next if category == :site
                sum = 0; items.values.each { |time| sum += time }
                list = items.sort { |l,r| l.last <=> r.last }
                
                if list.length > 1
                    printf "%10s c:%-3d sum:%9.6f min:%.6f max:%.6f avg:%.6f\n",
                           category, items.length, sum, list.first.last,
                           list.last.last, sum / items.length
                    details[category] = list.collect { |pair| { pair.first => pair.last } }
                else
                    printf "%10s c:%-3d sum:%9.6f\n", category, items.length, sum
                end
            end
            
            unless details.empty?
                puts
                puts details.to_yaml
            end
        end
    end
end
