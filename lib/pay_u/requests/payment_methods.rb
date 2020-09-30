module PayU
  module Requests
    class PaymentMethods < Service
      def initialize(
        connection_builder: ConnectionBuilder,
        authorize_request: Authorize
      )
        @connection_builder = connection_builder
        @authorize_request  = authorize_request
      end

      def call
        faraday = @connection_builder.call
        auth_response = @authorize_request.call

        response = faraday.get(paymethods_url) do |request|
          request.headers['Authorization'] = "Bearer #{auth_response.token}"
        end
        response.body
      end

      private

      def paymethods_url
        PayU.configuration.base_url + Requests::PAYMENT_METHODS_URL
      end
    end
  end
end
