RSpec.describe PayU::Requests::PaymentMethods, :unit do
  let(:connection_builder) { spy(:connection_builder) }
  let(:connection) { double(:connection) }
  subject do
    described_class.new(connection_builder: connection_builder)
  end

  it 'returns payment methods if authenticated'

  it 'returns 401 status code if unathorized'
end