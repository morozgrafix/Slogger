require 'rubygems'
require 'sinatra'
require 'oauth2'
require 'json'
require 'net/https'
require 'foursquare2'

set :port, 4567

CLIENT_ID = "PTNZUGEJIXNTKUI3Y5GKBZZ2LYLVWPQGWZNY3AEBNJDNCXBQ"
CLIENT_SECRET = "TD1TOWTD4UQTQNXTSWUNMF0UPC4QVHVBWKO1WYGRSA3FND2R"
CALLBACK_PATH = '/oauth/callback'

def client
OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET,
{:site => 'https://foursquare.com/',
:token_url => "/oauth2/access_token",
:authorize_url => "/oauth2/authenticate?response_type=code",
:parse_json => true,
:ssl => {:ca_path => '/etc/ssl/certs' }
})
end

def redirect_uri()
uri = URI.parse(request.url)
uri.path = CALLBACK_PATH
uri.query = nil
uri.to_s
end

get CALLBACK_PATH do
puts redirect_uri
if params[:code] != nil
token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri).token
client = Foursquare2::Client.new(:oauth_token => token, :api_version => '20150101')
email = client.user('self')['contact'].email.to_s
return "Authenticated user: #{email}"
else
'Missing response from foursquare'
end
end

get '/' do
redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri)
end

command = 'open http://localhost:4567'
output = `#{command}`