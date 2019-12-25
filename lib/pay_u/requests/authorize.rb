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
        auth_data = build_auth_string
        response = connection.post(auth_url, auth_data)
        response.body
      rescue Faraday::TimeoutError
        message =
          'There was a timeout authorizing the client'
        raise PayU::Errors::TimeoutError, message
      end

      private

      def auth_url
        PayU.configuration.base_url + AUTHORIZE_URL
      end

      def build_auth_string
        @auth_builder.call
      end

      def connection
        @connection_builder.call
      end
    end
  end
end
