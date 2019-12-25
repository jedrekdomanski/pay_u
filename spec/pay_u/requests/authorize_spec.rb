RSpec.describe PayU::Requests::Authorize, :unit do
  let(:auth_hash) do
    {
      'access_token' => 'token',
      'token_type' => 'bearer',
      'expires_in' => 1234,
      'grant_type' => 'client_credentials'
    }
  end
  let(:response) { double(:response, body: auth_hash) }
  let(:connection) { double(:connection) }
  let(:connection_builder) { spy(:connection_builder) }
  let(:auth_builder) { spy(:auth_builder) }
  let(:base_url) do
    'https://secure.payu.sandbox.com'
  end
  let(:auth_url) { '/pl/standard/user/oauth/authorize' }
  let(:url) { base_url + auth_url }
  let(:auth_string) do
    'grant_type=client_credentials&client_id=123&client_secret=123'
  end

  subject do
    described_class.new(
      connection_builder: connection_builder,
      auth_builder: auth_builder
    )
  end

  it 'returns authentication hash' do
    allow(auth_builder).to receive(:call).and_return(auth_string)
    allow(PayU)
      .to receive_message_chain('configuration.base_url')
      .and_return(base_url)
    allow(base_url).to receive(:+).with(auth_url).and_return(url)
    allow(connection_builder).to receive(:call).and_return(connection)
    allow(connection)
      .to receive(:post)
      .with(url, auth_string)
      .and_return(response)
    allow(response).to receive(:body).and_return(auth_hash)

    subject.call
    expect(auth_hash['access_token']).not_to be_empty
  end
end
