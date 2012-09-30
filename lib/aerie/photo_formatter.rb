module Aerie
  class PhotoFormatter
    def initialize(photo, opts={ force: false })
      @photo = photo
      @opts  = opts
	end

	def run
      create_format "square-75" do |image|
        image.resize_to_fill(75, 75)
      end
	end

	private

	def create_format(format)
      if !@photo.formats || !@photo.formats.include?(format) || @opts[:force]
        new_image = yield(image)
        AWS::S3::S3Object.store(@photo.path_of(format), new_image.to_blob,
          Aerie::Config.aws_bucket, access: :public_read)
        @photo.formats ||= []
        @photo.formats << format
        @photo.save
        Slides.log :store_photo, format: format, path: @photo.path_of(format)
      else
        Slides.log :store_photo, format: format, skipped: true
      end
	end

    def image
      @image ||= Magick::Image.from_blob(original.value).first
    end

	def original
      @original ||=
        AWS::S3::S3Object.find(@photo.path_of_original, Config.aws_bucket)
	end
  end
end
