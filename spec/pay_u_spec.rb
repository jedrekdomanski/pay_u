RSpec.describe PayU do
  it 'has a version number' do
    expect(PayU::VERSION).not_to be nil
  end

  describe '#configure' do
    before :each do
      PayU.configure do |config|
        config.base_url = 'www.some_test_url.com'
        config.auth = {
          client_id: '12345',
          client_secret: 'secret_client'
        }
      end
    end

    it 'returns a URL string' do
      expect(PayU.configuration.base_url).to eq('www.some_test_url.com')
    end

    it 'configures auth data' do
      auth_builder = PayU::AuthConfigBuilder.call
      expect(auth_builder.client_id).to eq('12345')
      expect(auth_builder.client_secret).to eq('secret_client')
    end
  end

  describe '#reset' do
    before :each do
      PayU.configure do |config|
        config.base_url = 'https://secure.payu.sandbox.com'
      end
    end

    it 'resets configuration' do
      expect(PayU.configuration.base_url)
        .to eq('https://secure.payu.sandbox.com')

      PayU.reset

      config = PayU.configuration
      expect(config.base_url).to eq('https://secure.payu.com')
    end
  end
end
