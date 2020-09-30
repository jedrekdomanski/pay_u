# frozen_string_literal: true

RSpec.describe PayU::Requests::GetShopData, :unit do
  let(:connection_builder) { spy(:connection_builder) }
  let(:authorize_request) { spy(:authorize_request) }

  subject do
    described_class.new(
      connection_builder: connection_builder,
      authorize_request: authorize_request
    )
  end

  it 'returns shop data' do
    connection = double(:connection)
    auth_response = double(:auth_response)
    response = double(:response, body: [])
    shop_id = 'asd123'

    allow(connection_builder).to receive(:call).and_return(connection)
    allow(connection).to receive(:get)
      .with('https://secure.snd.payu.com/api/v2_1/shops/asd123')
      .and_return(response)
    allow(authorize_request).to receive(:call).and_return(auth_response)

    subject.call(shop_id: shop_id)
  end
end
