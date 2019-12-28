RSpec.describe PayU::Requests::Authorize, :unit do
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

  it 'returns authentication hash if status is ok' do
    auth_hash = {
      'access_token' => 'token',
      'token_type' => 'bearer',
      'expires_in' => 1234,
      'grant_type' => 'client_credentials'
    }

    response = double(:response, body: auth_hash)

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
    allow(response).to receive(:status).and_return(200)
    allow(response).to receive(:reason_phrase).and_return('OK')

    subject.call
    expect(auth_hash['access_token']).not_to be_empty
    expect(response.status).to eq(200)
  end

  it 'raises Unauthorized if response status is 401' do
    auth_hash = {
      'error' => 'invalid_client',
      'error_description' => "Can't find oauthClient with clientId = 12321"
    }

    response = double(:response, body: auth_hash)

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
    allow(response).to receive(:status).and_return(401)
    allow(response)
      .to receive(:reason_phrase)
      .and_return("Unauthorized, Can't find oauthClient with clientId = 12321")

    expect { subject.call }.to raise_error(PayU::Errors::Unauthorized)
  end
end
