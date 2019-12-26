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
require 'pay_u/requests/create_order'
require 'pay_u/requests/get_order'
require 'ostruct'
require 'json'

module PayU
end

PayU.configure do |config|
  config.base_url = 'https://secure.snd.payu.com'
  config.auth = {
    client_id: ENV['CLIENT_ID'],
    client_secret: ENV['CLIENT_SECRET']
  }
  config.merchant_pos_id = ENV['POS_ID']
  config.notify_url = 'http://localhost:3000'
end
