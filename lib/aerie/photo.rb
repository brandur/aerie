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

    def path_of_original
      "#{key}/original#{file_extension}"
    end

    def validate
      super
      validates_presence [:key]
    end
  end
end
