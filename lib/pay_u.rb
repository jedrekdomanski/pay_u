require 'faraday'
require 'faraday_middleware/parse_oj'

require 'pay_u/version'
require 'pay_u/configuration'
require 'pay_u/service'
require 'pay_u/builders/auth_builder'
require 'pay_u/builders/auth_config_builder'
require 'pay_u/builders/connection_builder'
require 'pay_u/requests/authorize'
require 'pay_u/requests/payment_methods'
require 'ostruct'

module PayU
end

PayU.configure do |config|
  config.base_url = 'https://secure.snd.payu.com'
  config.auth = {
    client_id: ENV['CLIENT_ID'],
    client_secret: ENV['CLIENT_SECRET']
  }
end