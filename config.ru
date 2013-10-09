require "rack/cors"

require File.expand_path("../api", __FILE__)
require File.expand_path("../app", __FILE__)

# use Rack::Cors do
#   allow do
#     origins '*'
#     resource '*', headers: :any, methods: [:get, :post, :patch, :put, :delete]
#   end
# end

run Rack::Cascade.new [Scegratoo::API, Scegratoo::App.new()]
