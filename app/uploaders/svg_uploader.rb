class SvgUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    # process resize_to_fit: [100, 100]
    process :resize_to_fill => [100, 100]  
  end


  def extension_whitelist
    [:svg]
  end


end
