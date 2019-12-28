module PayU
  module Requests
    class Authorize < Service
      AuthResponse = Struct.new(:status, :message, :body, :token)
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

        response = connection.post(auth_url, auth_data)

        handle_response(response)
      end

      private

      def auth_url
        PayU.configuration.base_url + AUTHORIZE_URL
      end

      def handle_response(response)
        message = "Unauthorized. #{response.body['error_description']}"
        raise Errors::Unauthorized, message if response.status == 401

        AuthResponse.new(
          response.status,
          response.reason_phrase,
          response.body,
          response.body['access_token']
        )
      end
    end
  end
end
