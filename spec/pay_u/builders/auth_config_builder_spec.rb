RSpec.describe PayU::AuthConfigBuilder, :unit do
  before do
    PayU.configure do |config|
      config.auth = {
        client_id: '12345',
        client_secret: 'secret_client'
      }
    end
  end

  it 'builds auth data object from app config' do
    data = described_class.call

    expect(data.client_id).to eq('12345')
    expect(data.client_secret).to eq('secret_client')
  end
end
