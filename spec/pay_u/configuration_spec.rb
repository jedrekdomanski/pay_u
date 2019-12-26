RSpec.describe PayU::Configuration do
  describe '#base_url' do
    it 'defaults to https://secure.payu.com' do
      expect(described_class.new.base_url).to eq('https://secure.payu.com')
    end

    it 'can set value' do
      config = described_class.new
      config.base_url = 'http://some/other/url.com'
      expect(config.base_url).to eq('http://some/other/url.com')
    end
  end

  describe '#auth' do
    it 'can set auth data' do
      config = described_class.new
      config.auth = {
        client_id: '123asd',
        client_secret: 'very_secret'
      }

      expect(config.auth).not_to be_empty
      expect(config.auth[:client_id]).to eq('123asd')
      expect(config.auth[:client_secret]).to eq('very_secret')
    end
  end

  describe '#merchant_pos_id' do
    it 'can be set' do
      config = described_class.new
      config.merchant_pos_id = '1234'

      expect(config.merchant_pos_id).to eq('1234')
    end
  end

  describe '#notify_url' do
    it 'can be set' do
      config = described_class.new
      config.merchant_pos_id = 'http://test/com'

      expect(config.merchant_pos_id).to eq('http://test/com')
    end
  end
end
