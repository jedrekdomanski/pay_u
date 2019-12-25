RSpec.describe PayU::ConnectionBuilder, :unit do
  let(:faraday) { spy(:faraday) }
  let(:connection) { spy(:connection) }

  subject { described_class.new(faraday: faraday) }

  it 'returns a Faraday connection' do
    allow(faraday).to receive(:new).and_yield(connection)

    connection = described_class.call

    expect(connection).to be_a(Faraday::Connection)
  end
end
