CarrierWave.configure do |cfg|
  if Rails.env.production?
    cfg.fog_provider = 'fog/aws'
    cfg.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_ACCESS_ID'],
      :aws_secret_access_key  => ENV['S3_ACCESS_KEY'],
      :region => ENV['S3_REGION']
    }
    cfg.cache_dir = "#{Rails.root}/tmp/uploads"
    cfg.fog_directory  = ENV['S3_BUCKET']
    cfg.storage = :fog
    cfg.fog_public     = true
    # cfg.asset_host = ENV['S3_CDN_URL']
    cfg.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  else
    cfg.storage = :file
    # config.enable_processing = Rails.env.development?
  end

  # def quality(percentage)
  #   manipulate! do |img|
  #     img.quality(percentage.to_s)
  #     img = yield(img) if block_given?
  #     img
  #   end
  # end
end

