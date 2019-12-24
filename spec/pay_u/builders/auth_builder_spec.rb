RSpec.describe PayU::AuthBuilder, :unit do
  let(:config_builder) { spy(:auth_config_builder, {}) }
  let(:auth_data) do
    double(:auth_data, client_id: '123123', client_secret: 'secret')
  end

  subject :builder do
    described_class.new(config_builder: config_builder)
  end

  it 'builds auth url string from app config' do
    allow(config_builder).to receive(:call).and_return(auth_data)

    string = builder.call

    expect(string).to eq(
      'grant_type=client_credentials' \
      "&client_id=#{auth_data.client_id}" \
      "&client_secret=#{auth_data.client_secret}"
    )
  end
end
