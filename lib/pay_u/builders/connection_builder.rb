module PayU
  class ConnectionBuilder < Service
    def initialize(faraday: Faraday)
      @faraday = faraday
    end

    def call
      @faraday.new do |con|
        con.response :oj, content_type: /\bjson$/
        con.adapter Faraday.default_adapter
      end
    rescue @connection::TimeoutError
      message =
        'There was a timeout getting payment methods info'
      raise PayU::Errors::TimeoutError, message
    end
  end
end
