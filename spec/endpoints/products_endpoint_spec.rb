require 'rack/test'
require 'json'
require_relative '../../endpoints/products_endpoint'
require_relative '../../endpoints/auth_endpoint'

RSpec.describe ProductsEndpoint do
  include Rack::Test::Methods

  let(:app) { ProductsEndpoint }
  let(:valid_token) { SecureRandom.hex(16) }
  let(:invalid_token) { 'invalid_token' }

  before do
    allow_any_instance_of(AuthEndpoint).to receive(:authorize!).and_return(
      [200, {}, []]
    )
    allow_any_instance_of(AuthEndpoint).to receive(:authorize!).with(invalid_token).and_return(
      [401, { 'Content-Type' => 'application/json' }, [JSON.dump({ error: 'No autorizado' })]]
    )
  end

  describe 'GET /products' do
    context 'cuando el usuario está autenticado' do
      it 'devuelve la lista de productos' do
        header 'Authorization', valid_token
        get '/products'

        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to be_an(Array)
        expect(JSON.parse(last_response.body).size).to eq(10)
      end
    end

    context 'cuando el usuario no está autenticado' do
      it 'devuelve un error 401' do
        header 'Authorization', invalid_token
        get '/products'

        expect(last_response.status).to eq(401)
        expect(JSON.parse(last_response.body)).to eq({ 'error' => 'No autorizado' })
      end
    end
  end

  describe 'POST /products' do
    context 'cuando el usuario está autenticado' do
      it 'crea un producto válido' do
        header 'Authorization', valid_token
        header 'Content-Type', 'application/json'
        post '/products', { name: '100 anios de soledad' }.to_json

        expect(last_response.status).to eq(202)
        expect(JSON.parse(last_response.body)).to eq({ 'message' => 'Creacion del producto en progreso...' })

        sleep 6
        expect(ProductsEndpoint::PRODUCTS.last[:name]).to eq('100 anios de soledad')
      end

      it 'devuelve un error si el nombre del producto está vacío' do
        header 'Authorization', valid_token
        header 'Content-Type', 'application/json'
        post '/products', { name: '' }.to_json

        expect(last_response.status).to eq(422)
        expect(JSON.parse(last_response.body)).to eq({ 'error' => 'El nombre del producto es requerido' })
      end
    end

    context 'cuando el usuario no está autenticado' do
      it 'devuelve un error 401' do
        header 'Authorization', invalid_token
        post '/products', { name: '100 anios de soledad' }.to_json

        expect(last_response.status).to eq(401)
        expect(JSON.parse(last_response.body)).to eq({ 'error' => 'No autorizado' })
      end
    end
  end

  describe 'rutas no válidas' do
    it 'devuelve un error 404 para métodos no soportados' do
      delete '/products'
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)).to eq({ 'error' => 'No existe' })
    end
  end
end
