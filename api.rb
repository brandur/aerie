require "securerandom"

configure do
  set :dump_errors,     false  # don't dump errors to stderr
  set :show_exceptions, false  # don't allow sinatra's crappy error pages
end

error do
  e = env['sinatra.error']
  log(:error, type: e.class.name, message: e.message,
    backtrace: e.backtrace)
  respond({ message: e.message },
    :status => e.respond_to?(:status) ? e.status : 500)
end

helpers do
  def auth
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
  end

  def auth_credentials
    auth.provided? && auth.basic? ? auth.credentials : nil
  end

  def authorized!
    raise Aerie::Unauthorized.new unless auth_credentials
  end

  def log(action, attrs={})
    Slides.log(action, attrs.merge!(id: request.env["REQUEST_ID"]))
  end

  def respond(json, options={ :status => 200 })
    [options[:status], { "Content-Type" => "application/json" },
      MultiJson.encode(json, :pretty => true)]
  end
end

post "/photos" do
  unless params[:photo] && params[:photo][:tempfile]
    raise Aerie::BadRequest.new("Need parameter: photo")
  end
  DB.transaction do
    photo = Aerie::Photo.create description: params[:description],
      filename: params[:photo][:filename], formats: ["original"]
    AWS::S3::S3Object.store(photo.path_of_original,
      params[:photo][:tempfile].read, Aerie::Config.aws_bucket,
      access: :public_read)
    log :store_photo, path: photo.path_of_original, format: "original"
    respond(photo.serialized_as_v0, status: 201)
  end
end
