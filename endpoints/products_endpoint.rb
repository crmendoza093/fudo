require 'json'
require 'faker'
require 'byebug'

class ProductsEndpoint
  PRODUCTS = []

  def self.call(env)
    request = Rack::Request.new(env)

    auth_response = connected?(request)
    return auth_response unless auth_response[0] == 200

    case request.request_method
    when 'GET'
      list_products
    when 'POST'
      create_product(request)
    else
      not_found
    end
  end

  private

  def self.list_products
    [200, { 'Content-Type' => 'application/json' }, [JSON.dump(PRODUCTS)]]
  end

  def self.create_product(request)
    payload = JSON.parse(request.body.read) rescue {}
    product_name = payload['name']

    if product_name.nil? || product_name.strip.empty?
      return [422, { 'Content-Type' => 'application/json' }, [JSON.dump({ error: 'El nombre del producto es requerido' })]]
    end

    Thread.new do
      sleep 5
      new_product = { id: Faker::Internet.uuid, name: product_name }
      PRODUCTS << new_product
    end

    [202, { 'Content-Type' => 'application/json' }, [JSON.dump({ message: 'Creacion del producto en progreso...' })]]
  end

  def self.not_found
    [404, { 'Content-Type' => 'application/json' }, [JSON.dump({ error: 'No existe' })]]
  end

  def self.load_fake_data
    10.times do |i|
      PRODUCTS << { id: Faker::Internet.uuid, name: Faker::Book.title }
    end
  end

  def self.connected?(request)
    auth_token = request.get_header('HTTP_AUTHORIZATION')
    AuthEndpoint.new.authorize!(auth_token)
  end
end

ProductsEndpoint.load_fake_data
