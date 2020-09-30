# frozen_string_literal: true

module PayU
  module Requests
    class OrderTransactions < Service
      def initialize(
        connection_builder: ConnectionBuilder,
        authorize_request: Authorize
      )
        @connection_builder = connection_builder
        @authorize_request  = authorize_request
      end

      def call(order_id:)
        connection = @connection_builder.call
        auth_response = @authorize_request.call
        order_transactions_url = build_order_transactions_url(order_id)
        response = connection.get(order_transactions_url) do |request|
          request.headers['Authorization'] = "Bearer #{auth_response.token}"
        end
        response
      end

      private

      def build_order_transactions_url(order_id)
        PayU.configuration.base_url \
          + Requests::ORDERS_URL \
          + "/#{order_id}/transactions"
      end
    end
  end
end
