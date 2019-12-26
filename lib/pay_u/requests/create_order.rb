module PayU
  module Requests
    class CreateOrder < Service
      CREATE_ORDER_URL = '/api/v2_1/orders'.freeze

      def initialize(connection_builder: ConnectionBuilder)
        @connection_builder = connection_builder
      end

      def call(token:, params:)
        order_params = create_order_data(params)
        connection = @connection_builder.call

        connection.post(url) do |request|
          request.headers['Authorization'] = "Bearer #{token}"
          request.headers['Content-Type'] = 'application/json'
          request.body = order_params
        end
      end

      private

      def create_order_data(params)
        order_params = params.merge(
          merchantPosId: PayU.configuration.merchant_pos_id,
          notifyUrl: PayU.configuration.notify_url
        )

        JSON.generate(order_params)
      end

      def url
        PayU.configuration.base_url + CREATE_ORDER_URL
      end
    end
  end
end
