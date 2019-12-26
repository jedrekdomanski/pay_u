module PayU
  module Requests
    class Authorize < Service
      AUTHORIZE_URL = '/pl/standard/user/oauth/authorize'.freeze

      def initialize(
        connection_builder: ConnectionBuilder,
        auth_builder: AuthBuilder
      )
        @connection_builder = connection_builder
        @auth_builder = auth_builder
      end

      def call
        auth_data = @auth_builder.call

        connection = @connection_builder.call
        connection.post(auth_url, auth_data)
      end

      private

      def auth_url
        PayU.configuration.base_url + AUTHORIZE_URL
      end
    end
  end
end
