Unsplash.configure do |config|
    config.application_access_key = ENV["UNSPLASH_ACCESS_KEY"]
    config.application_secret = ENV["UNSPLAH_SECRET_KEY"]
    config.application_redirect_uri = ENV["UNSPLAH_REDIRECT_URI"]
    config.utm_source = ENV["UNSPLASH_UTM_SOURCE"]
end