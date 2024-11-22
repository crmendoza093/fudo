require 'hanami/router'
require_relative '../endpoints/auth_endpoint'
require_relative '../endpoints/products_endpoint'
require_relative '../static_files'

class Router
  def self.build
    Hanami::Router.new do
      get '/openapi.yaml', to: ->(env) { StaticFiles.call(env) }
      get '/AUTHORS', to: ->(env) { StaticFiles.call(env) }

      scope '/api' do
        post '/auth', to: ->(env) { AuthEndpoint.call(env) }
        scope '/products' do
          get '/', to: ->(env) { ProductsEndpoint.call(env) }
          post '/', to: ->(env) { ProductsEndpoint.call(env) }
        end
      end
    end
  end
end

