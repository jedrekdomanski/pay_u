module PayU
  module Requests
    class PaymentMethods < Service
      PAYMENT_METHODS_URL = '/api/v2_1/paymethods'.freeze

      def initialize(connection_builder: ConnectionBuilder)
        @connection_builder = connection_builder
      end

      def call(token:)
        faraday = @connection_builder.call

        response = faraday.get(paymethods_url) do |request|
          request.headers['Authorization'] = "Bearer #{token}"
        end
        response
      end

      private

      def paymethods_url
        PayU.configuration.base_url + PAYMENT_METHODS_URL
      end
    end
  end
end
