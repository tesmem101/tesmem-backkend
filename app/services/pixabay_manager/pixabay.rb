module PixabayManager
    class Pixabay

        def initialize(params)
            @options = params
        end

        def self.photos(params={})
            new(params).photos
        end

        def photos
            base_URL = "https://pixabay.com/api?key=#{ENV["PIXABAY_ACCESS_KEY"]}"
            query_string = ""
            @options.each do |key, value|
                query_string.concat "&#{key}=#{value}" 
            end
            complete_URL = base_URL + query_string
            JSON.parse(RestClient.get complete_URL)
        end

    end 
end