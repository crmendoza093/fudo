require 'rack'
require 'webrick'
require_relative './config/router'
require_relative './static_files'

app = Rack::Builder.new do
  use Rack::Deflater

  use Rack::Static,
      urls: ["/AUTHORS", "/openapi.yaml"],
      root: "public",
      header_rules: [
        ["/AUTHORS", { 'Cache-Control' => 'max-age=86400' }],
        ["/openapi.yaml", { 'Cache-Control' => 'no-cache' }]
      ]

  run Router.build
end
