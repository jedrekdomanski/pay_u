# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware/parse_oj'

require 'pay_u/version'
require 'pay_u/configuration'
require 'pay_u/service'
require 'pay_u/builders/auth_builder'
require 'pay_u/builders/auth_config_builder'
require 'pay_u/builders/connection_builder'
require 'pay_u/errors'
require 'pay_u/response'
require 'pay_u/requests/authorize'
require 'pay_u/requests/payment_methods'
require 'pay_u/requests/create_order'
require 'pay_u/requests/get_order'
require 'pay_u/requests/update_order'
require 'pay_u/requests/cancel_order'
require 'pay_u/requests/get_shop_data'
require 'pay_u/client'
require 'ostruct'
require 'json'

module PayU
  module Requests
    PAYMENT_METHODS_URL = '/api/v2_1/paymethods'
    ORDERS_URL = '/api/v2_1/orders'
    SHOPS_URL = '/api/v2_1/shops'
  end
end
