module PayU
  class Configuration
    attr_accessor :base_url, :auth, :merchant_pos_id, :notify_url

    def initialize
      @base_url = 'https://secure.payu.com'
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset
      @configuration = Configuration.new
    end
  end
end
