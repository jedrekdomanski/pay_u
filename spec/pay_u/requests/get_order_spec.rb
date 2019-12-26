RSpec.describe PayU::Requests::GetOrder, :unit do
  let(:connection_builder) { spy(:connection_builder) }

  subject do
    described_class.new(connection_builder: connection_builder)
  end

  it 'fetches order info if authorized'
  it 'raises 401 if unauthorized'
end
