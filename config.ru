require "bundler/setup"
Bundler.require

$stdout.sync = true

require "./bootstrap"

# this is kind of annoying, so only require it on the web server
require "sequel/instruments"

require "./lib/aerie"
require "./api"

use Rack::SSL if Aerie::Config.force_ssl?
use Rack::Instruments
use Rack::Robots

run Sinatra::Application
