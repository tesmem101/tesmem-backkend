class ImageSerializer < ActiveModel::Serializer
  attributes :name, :description, :url, :height, :width, :default_url, :thumb_url

  def default_url
    object.image.image.url rescue '---'
  end

  def thumb_url
    object.image.image.thumb.url  rescue '---'
  end

end
