require 'json'
require 'securerandom'

class AuthEndpoint
  USERS = JSON.parse(File.read('data/users.json'))
  SESSIONS = {}

  def self.call(env)
    request = Rack::Request.new(env)
    payload = JSON.parse(request.body.read) rescue {}
    username = payload['username']
    password = payload['password']

    if USERS[username] == password
      token = SecureRandom.hex(16)
      SESSIONS[token] = { username: username, created_at: Time.now }
      response = { message: 'Autenticacion exitosa', token: token }
      [200, { 'Content-Type' => 'application/json' }, [JSON.dump(response)]]
    else
      [401, { 'Content-Type' => 'application/json' }, [JSON.dump({ error: 'Credenciales invalidas' })]]
    end
  end

  
  def extract_token(auth_header)
    return nil unless auth_header&.start_with?('Bearer ')

    auth_header.split(' ').last
  end

  def authorize!(header)
    auth_token = extract_token(header)
    return [200, { 'Content-Type' => 'application/json' }, ['']] if authenticated?(auth_token)
    
    [401, { 'Content-Type' => 'application/json' }, [JSON.dump({ error: 'No autorizado' })]]
  end

  def authenticated?(token)
    SESSIONS.key?(token)
  end
end
