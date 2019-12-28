module PayU
  module Requests
    class CreateOrder < Service
      CreateOrderResponse = Struct.new(:status, :message, :body)

      def initialize(
        connection_builder: ConnectionBuilder,
        authorize_request: Authorize
      )
        @connection_builder = connection_builder
        @authorize_request  = authorize_request
      end

      def call(params:)
        auth_response = @authorize_request.call

        order_params = create_order_data(params)
        connection = @connection_builder.call

        response = connection.post(url) do |request|
          request.headers['Authorization'] = "Bearer #{auth_response.token}"
          request.headers['Content-Type'] = 'application/json'
          request.body = order_params
        end

        build_response(response)
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
        PayU.configuration.base_url + Requests::ORDERS_URL
      end

      def build_response(response)
        CreateOrderResponse.new(
          response.status,
          response.reason_phrase,
          response.body
        )
      end
    end
  end
end
