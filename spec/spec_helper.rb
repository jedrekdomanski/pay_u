require 'bundler/setup'
require 'pay_u'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    PayU.configure do |conf|
      conf.base_url = 'https://secure.snd.payu.com'
      conf.auth = {
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET']
      }
      conf.merchant_pos_id = ENV['POS_ID']
      conf.notify_url = 'http://localhost:3000'
    end
  end
end
