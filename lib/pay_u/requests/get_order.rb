module PayU
  module Requests
    class GetOrder < Service
      ORDERS_URL = '/api/v2_1/orders'.freeze

      def initialize(connection_builder: ConnectionBuilder)
        @connection_builder = connection_builder
      end

      def call(token:, order_id:)
        connection = @connection_builder.call

        url = build_url + "/#{order_id}"
        connection.get(url) do |request|
          request.headers['Authorization'] = "Bearer #{token}"
        end
      end

      private

      def build_url
        PayU.configuration.base_url + ORDERS_URL
      end
    end
  end
end
