module PayU
  class AuthBuilder < Service
    def initialize(config_builder: AuthConfigBuilder)
      @config_builder = config_builder
    end

    def call
      auth_data = @config_builder.call

      'grant_type=client_credentials' \
      + "&client_id=#{auth_data.client_id}" \
      + "&client_secret=#{auth_data.client_secret}"
    end
  end
end
