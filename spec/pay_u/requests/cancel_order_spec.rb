RSpec.describe PayU::Requests::CancelOrder, :unit do
  let(:connection_builder) { spy(:connection_builder) }

  subject do
    described_class.new(connection_builder: connection_builder)
  end

  it 'cancels order if authorized'
  it 'raises 401 if unauthorized'
end
