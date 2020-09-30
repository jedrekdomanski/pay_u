# frozen_string_literal: true

module PayU
  module Requests
    class GetShopData < Service
      def initialize(
        connection_builder: ConnectionBuilder,
        authorize_request: Authorize
      )
        @connection_builder = connection_builder
        @authorize_request  = authorize_request
      end

      def call(shop_id:)
        connection = @connection_builder.call
        auth_response = @authorize_request.call
        shop_data_url = build_shop_data_url(shop_id)
        response = connection.get(shop_data_url) do |request|
          request.headers['Authorization'] = "Bearer #{auth_response.token}"
        end
        response.body
      end

      private

      def build_shop_data_url(shop_id)
        PayU.configuration.base_url \
          + Requests::SHOPS_URL \
          + "/#{shop_id}"
      end
    end
  end
end
