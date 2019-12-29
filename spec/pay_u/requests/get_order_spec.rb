RSpec.describe PayU::Requests::GetOrder, :unit do
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

  it 'returns order info if order found' do
    response = double(
      :response,
      body: {
        'orders' => [
          {
            'orderId' => '67RDG4GV4Z191228GUEST000P01',
            'orderCreateDate' => '2019-12-28T23:28:40.129+01:00',
            'notifyUrl' => 'http://localhost:3000',
            'customerIp' => '127.0.0.1',
            'merchantPosId' => '370379',
            'description' => 'RTV market',
            'currencyCode' => 'PLN',
            'totalAmount' => '21000',
            'status' => 'NEW',
            'products' => [
              {
                'name' => 'Wireless Mouse for Laptop',
                'unitPrice' => '15000',
                'quantity' => '1'
              },
              {
                'name' => 'HDMI cable',
                'unitPrice' => '6000',
                'quantity' => '1'
              }
            ]
          }
        ],
        'status' => {
          'statusCode' => 'SUCCESS',
          'statusDesc' => 'Request processing successful'
        }
      },
      status: 404
    )
    allow(authorize_request)
      .to receive(:call).and_return(auth_response)
    allow(connection_builder).to receive(:call).and_return(connection)
    allow(connection)
      .to receive(:get)
      .with('https://secure.snd.payu.com/api/v2_1/orders/67RDG4GV4Z191228GUEST000P01')
      .and_return(response)
    allow(response)
      .to receive(:status)
      .and_return(200)

    result = subject.call(order_id: '67RDG4GV4Z191228GUEST000P01')

    expect(result.status).to eq('Request processing successful')
    expect(result.order_id).to eq('67RDG4GV4Z191228GUEST000P01')
  end
  it 'raises 404 if order not found' do
    response = double(
      :response,
      body: {
        'status' => {
          'statusCode' => 'DATA_NOT_FOUND',
          'severity' => 'INFO',
          'statusDesc' => 'Could not find data for given criteria.'
        }
      },
      status: 404
    )

    allow(authorize_request)
      .to receive(:call).and_return(auth_response)
    allow(connection_builder).to receive(:call).and_return(connection)
    allow(connection)
      .to receive(:get)
      .with('https://secure.snd.payu.com/api/v2_1/orders/non_existent_order_id')
      .and_return(response)
    allow(response)
      .to receive(:status)
      .and_return(404)

    result = subject.call(order_id: 'non_existent_order_id')

    expect(result.status).to eq('DATA_NOT_FOUND')
    expect(result.description).to eq('Could not find data for given criteria.')
  end
end
