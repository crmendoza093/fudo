require 'rack/test'
require_relative '../../endpoints/auth_endpoint'

RSpec.describe AuthEndpoint do
  include Rack::Test::Methods

  let(:app) { AuthEndpoint }

  it 'devuelve un token con credenciales válidas' do
    header 'Content-Type', 'application/json'
    post '/auth', { username: 'user1', password: 'user123' }.to_json

    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to have_key('token')
  end

  it 'devuelve un error con credenciales inválidas' do
    header 'Content-Type', 'application/json'
    post '/auth', { username: 'user1', password: 'wrongpass' }.to_json

    expect(last_response.status).to eq(401)
    expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Credenciales invalidas' })
  end
end
