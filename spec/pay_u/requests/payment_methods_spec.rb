# frozen_string_literal: true

RSpec.describe PayU::Requests::PaymentMethods, :unit do
  let(:connection_builder) { spy(:connection_builder) }
  let(:authorize_request) { spy(:authorize_request) }

  subject do
    described_class.new(
      connection_builder: connection_builder,
      authorize_request: authorize_request
    )
  end

  it 'returns payment methods' do
    connection = double(:connection)
    auth_response = double(:auth_response)
    response = double(:response, body: [])

    allow(connection_builder).to receive(:call).and_return(connection)
    allow(connection).to receive(:get)
      .with('https://secure.snd.payu.com/api/v2_1/paymethods')
      .and_return(response)
    allow(authorize_request).to receive(:call).and_return(auth_response)

    subject.call
  end
end
