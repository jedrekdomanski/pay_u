# frozen_string_literal: true

module PayU
  module Requests
    class UpdateOrder < Service
      def initialize(
        connection_builder: ConnectionBuilder,
        authorize_request: Authorize
      )
        @connection_builder = connection_builder
        @authorize_request  = authorize_request
      end

      def call(params:)
        auth_response = @authorize_request.call
        connection = @connection_builder.call

        url = build_url(params[:orderId])

        connection.put(url) do |request|
          request.headers['Content-Type'] = 'application/json'
          request.headers['Authorization'] = "Bearer #{auth_response.token}"
          request.body = params.to_json
        end
      end

      private

      def build_url(order_id)
        PayU.configuration.base_url \
          + Requests::ORDERS_URL \
          + "/#{order_id}/status"
      end
    end
  end
end
