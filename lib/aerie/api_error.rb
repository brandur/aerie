module Aerie

  class ApiError < RuntimeError
    # naming this code would have a special effect for Sinatra
    attr_accessor :status
    def initialize(status, message="")
      super(message)
      @status = status
    end
  end

  class BadRequest < ApiError
    def initialize(message="Bad request")
      super(400, message)
    end
  end

  class NotFound < ApiError
    def initialize
      super(404, "Not found")
    end
  end

  class Unauthorized < ApiError
    def initialize
      super(401, "Unauthorized")
    end
  end

end
