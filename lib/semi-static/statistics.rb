module SemiStatic
    ##
    # Used to track statistics while generating the Site.
    class Statistics
        ##
        # Initialize a new Statistics object.
        def initialize
            self.reset
        end
        
        ##
        # Clears all recorded data.
        def reset
            @data = Hash.new { |hash,key| hash[key] = Hash.new }
        end
        
        ##
        # Record the time it takes for the block to execute.
        #
        # +category+: The category of the action.
        # +item+:     The name of the action.
        def record(category, item)
            raise ArgumentError unless block_given?
            before = Time.now
            result = yield
            @data[category][item] = Time.now - before
            return result
        end
        
        ##
        # Display the collected data to the user.
        def display
            # details = {}
            @data.each do |category,items|
                next if category == :site
                sum = 0; items.values.each { |time| sum += time }
                list = items.sort { |l,r| l.last <=> r.last }
                
                if list.length > 1
                    printf "%10s c:%-3d sum:%9.6f min:%.6f max:%.6f avg:%.6f\n",
                           category, items.length, sum, list.first.last,
                           list.last.last, sum / items.length
                    # details[category] = list.reverse.first(5).collect { |pair| { pair.first => pair.last } }
                else
                    printf "%10s c:%-3d sum:%9.6f\n", category, items.length, sum
                end
            end
            puts '---'
            @data[:site].each { |cat,time| printf "%15s %9.6f\n", cat.to_s.capitalize, time }
            
            # unless details.empty?
            #     puts '---'
            #     puts
            #     puts details.to_yaml
            # end
        end
    end
end
