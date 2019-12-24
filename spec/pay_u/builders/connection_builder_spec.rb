RSpec.describe PayU::ConnectionBuilder, :unit do
  let(:faraday) { spy(:faraday) }

  it 'returns a Faraday connection' do
    connection = described_class.call

    expect(connection).to be_a(Faraday::Connection)
  end
end
