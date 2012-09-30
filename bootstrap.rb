require "./lib/aerie/config"

DB = Sequel.connect(Aerie::Config.database_url)
DB.extension :pg_array
AWS::S3::Base.establish_connection!(
  access_key_id:     Aerie::Config.aws_access_key_id,
  secret_access_key: Aerie::Config.aws_secret_access_key)
