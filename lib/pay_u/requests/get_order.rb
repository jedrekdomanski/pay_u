module PayU
  module Requests
    class GetOrder < Service
      def initialize(connection_builder: ConnectionBuilder)
        @connection_builder = connection_builder
      end

      def call(token:, order_id:)
        connection = @connection_builder.call

        url = build_url(order_id)
        connection.get(url) do |request|
          request.headers['Authorization'] = "Bearer #{token}"
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
