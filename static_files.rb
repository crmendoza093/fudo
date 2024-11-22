class StaticFiles
  def self.call(env)
    request = Rack::Request.new(env)
    case request.path
    when '/openapi.yaml'
      [200, { 'Content-Type' => 'text/yaml', 'Cache-Control' => 'no-cache' }, [File.read('public/openapi.yaml')]]
    when '/AUTHORS'
      [200, { 'Content-Type' => 'text/plain', 'Cache-Control' => 'public, max-age=86400' }, [File.read('public/AUTHORS')]]
    else
      [404, { 'Content-Type' => 'application/json' }, [JSON.dump({ error: 'Not Found' })]]
    end
  end
end
