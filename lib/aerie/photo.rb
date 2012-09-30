module Aerie
  class Photo < Sequel::Model
    plugin :timestamps
    plugin :validation_helpers

    def initialize(*args)
      super
      self.key = UUIDTools::UUID.timestamp_create unless key
    end

    def file_extension
      File.extname(filename).downcase
    end

    def path_of(format)
      "#{key}/#{format}#{file_extension}"
    end

    def path_of_original
      path_of("original")
    end

    def serialized_as_v0
      {
        "key"      => key,
        "filename" => filename,
        "files"    => Hash[*formats.map { |format|
          [format, s3_url(path_of(format))]
        }.flatten],
      }
    end

    def validate
      super
      validates_presence [:key]
    end

    private

    def s3_url(filename)
      "https://s3.amazonaws.com/#{Config.aws_bucket}/#{filename}"
    end
  end
end
