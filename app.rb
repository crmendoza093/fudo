require 'rack'
require 'webrick'
require_relative './config/router'

router = Router.build

app = Rack::Builder.new do
  run router
end

Rack::Handler::WEBrick.run app, Port: 9292
