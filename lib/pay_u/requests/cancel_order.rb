module PayU
  module Requests
    class CancelOrder < Service
      def initialize(
        connection_builder: ConnectionBuilder,
        authorize_request: Authorize
      )
        @connection_builder = connection_builder
        @authorize_request  = authorize_request
      end

      def call(order_id:)
        auth_response = @authorize_request.call
        connection = @connection_builder.call

        url = build_url(order_id)
        connection.delete(url) do |request|
          request.headers['Authorization'] = "Bearer #{auth_response.token}"
        end
      end

      private

      def build_url(order_id)
        PayU.configuration.base_url \
          + Requests::ORDERS_URL \
          + "/#{order_id}"
      end
    end
  end
end
