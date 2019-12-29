module PayU
  module Requests
    class GetOrder < Service
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

        response = connection.get(url) do |request|
          request.headers['Authorization'] = "Bearer #{auth_response.token}"
        end

        build_response(response)
      end

      private

      def build_url(order_id)
        PayU.configuration.base_url \
          + Requests::ORDERS_URL \
          + "/#{order_id}"
      end

      def build_response(response)
        case response.status
        when 200 then build_order_found(response)
        when 404 then build_order_not_found(response)
        end
      end

      def build_order_found(response)
        Response::OrderFound.new(response: response)
      end

      def build_order_not_found(response)
        data = response.body['status']

        Response::OrderNotFound.new(response: response)
      end
    end
  end
end
