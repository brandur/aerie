require "bundler/setup"
Bundler.require

$stdout.sync = true

require "./lib/aerie/config"

DB = Sequel.connect(Aerie::Config.database_url)
AWS::S3::Base.establish_connection!(
  access_key_id:     Aerie::Config.aws_access_key_id,
  secret_access_key: Aerie::Config.aws_secret_access_key)

require "./lib/aerie"
require "./api"

use Rack::SSL if Aerie::Config.force_ssl?
use Rack::Instruments
use Rack::Robots

run Sinatra::Application
