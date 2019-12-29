RSpec.describe PayU::Requests::CancelOrder, :unit do
  let(:connection_builder) { spy(:connection_builder) }
  let(:authorize_request) { spy(:authorize_request) }
  let(:connection) { double(:connection) }
  let(:auth_response) do
    double(
      :auth_response,
      status: 200,
      message: 'OK',
      token: '123sda12e'
    )
  end

  subject do
    described_class.new(
      connection_builder: connection_builder,
      authorize_request: authorize_request
    )
  end

  it 'cancels order' do
    order_id = '123asdasda123'

    response = double(
      :response,
      body: {
        'orderId' => '67RDG4GV4Z191228GUEST000P01',
        'status' => {
          'statusCode' => 'SUCCESS',
          'statusDesc' => 'Request processing successful'
        }
      },
      status: 200,
      reason_phrase: 'OK'
    )

    allow(authorize_request).to receive(:call).and_return(auth_response)
    allow(connection_builder).to receive(:call).and_return(connection)
    allow(connection)
      .to receive(:delete)
      .with("https://secure.snd.payu.com/api/v2_1/orders/#{order_id}")
      .and_return(response)

    result = subject.call(order_id: order_id)

    expect(result.status).to eq(200)
    expect(result.body['status']['statusDesc']).to eq('Request processing successful')
  end
end
