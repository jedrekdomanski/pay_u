module PayU
  class AuthConfigBuilder < Service
    def call
      OpenStruct.new(
        client_id: PayU.configuration.auth[:client_id],
        client_secret: PayU.configuration.auth[:client_secret]
      )
    end
  end
end