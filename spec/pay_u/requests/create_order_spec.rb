RSpec.describe PayU::Requests::CreateOrder, :unit do
  let(:connection_builder) { spy(:connection_builder) }

  subject do
    described_class.new(connection_builder: connection_builder)
  end

  it 'creates new order if authorized'
  it 'raises 401 if unauthorized'
  it 'raises 422 unprocessable entity if invalid params passed'
end
