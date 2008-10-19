ActionController::Integration::Session.class_eval do
  def http_auth!
    @http_auth ||= begin
      filename = File.expand_path(File.dirname(__FILE__)) + "/../http_auth.yml"
      auth = YAML.load_file(filename).to_a.first * ':'
      {:authorization => "Basic " + Base64::encode64(auth)}
    end
  end
  
  def no_http_auth!
    @http_auth = nil
  end
  
  def process_with_http_auth(method, path, parameters = nil, headers = nil)
    headers ||= {}
    headers.update @http_auth || {} if @http_auth
    process_without_http_auth(method, path, parameters, headers)
  end
  alias_method_chain :process, :http_auth
end