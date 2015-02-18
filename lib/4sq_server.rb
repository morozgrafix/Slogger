#!/usr/bin/env ruby
require 'oauth2'
require 'foursquare2'
require 'launchy'

CLIENT_ID = "PTNZUGEJIXNTKUI3Y5GKBZZ2LYLVWPQGWZNY3AEBNJDNCXBQ"
CLIENT_SECRET = "TD1TOWTD4UQTQNXTSWUNMF0UPC4QVHVBWKO1WYGRSA3FND2R"
$user_token=nil

if $user_token.nil?
  puts "No foursquare user token, go auth us and get one, sucker!"
  o_client = OAuth2::Client.new(
    CLIENT_ID, 
    CLIENT_SECRET, 
    {:site => 'https://foursquare.com/', :authorize_url => 'oauth2/authenticate'}
  )
  auth_url = o_client.auth_code.authorize_url(
    :redirect_uri => 'http://localhost/oauth/callback', 
    :response_type => 'token'
  )
  Launchy.open(auth_url)
  print 'Okay, now gimmee ur token: '
  $user_token = gets.chomp
end
fs_client = Foursquare2::Client.new(:oauth_token => $user_token, :api_version => '20150101')
puts fs_client.user('self')