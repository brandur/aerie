module Aerie
  module Config
    extend self

    def api_key
      env!("API_KEY")
    end

    def aws_bucket
      env!("AWS_BUCKET")
    end

    def aws_access_key_id
      env!("AWS_ACCESS_KEY_ID")
    end

    def aws_secret_access_key
      env!("AWS_SECRET_ACCESS_KEY")
    end

    def database_url
      env!("DATABASE_URL")
    end

    def force_ssl?
      %w(1 true yes).include?(env("FORCE_SSL"))
    end

    private

    def env(k)
      ENV[k] if ENV[k] && ENV[k] != ""
    end

    def env!(k)
      env(k) || raise("missing_environment=#{k}")
    end
  end
end
