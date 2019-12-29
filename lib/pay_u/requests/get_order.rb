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
        order = response.body['orders'].first

        Response::OrderFound.new(
          order_id: order['orderId'],
          order_created_date: order['orderCreateDate'],
          notify_url: order['notifyUrl'],
          customer_ip: order['customerIp'],
          merchant_pos_id: order['merchantPosId'],
          description: order['description'],
          currency_code: order['currencyCode'],
          total_amount: order['totalAmount'],
          status: response.body['status']['statusDesc'],
          products: order['products']
        )
      end

      def build_order_not_found(response)
        data = response.body['status']

        Response::OrderNotFound.new(
          status: data['statusCode'],
          severity: data['severity'],
          description: data['statusDesc']
        )
      end
    end
  end
end
