RSpec.describe PayU::Requests::CreateOrder, :unit do
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

  it 'creates new order if valid params are passed' do
    order_params = {
      customerIp: '127.0.0.1',
      description: 'RTV market',
      currencyCode: 'PLN',
      totalAmount: '21000',
      buyer: {
        email: 'john.doe@example.com',
        phone: '654111654',
        firstName: 'John',
        lastName: 'Doe',
        language: 'pl'
      },
      products: [
        {
          name: 'Wireless Mouse for Laptop',
          unitPrice: '15000',
          quantity: '1'
        },
        {
          name: 'HDMI cable',
          unitPrice: '6000',
          quantity: '1'
        }
      ]
    }

    response = double(
      :response,
      status: 200,
      reason_phrase: 'SUCCESSFULL',
      body: {
        'status' => {
          'statusCode' => 'SUCCESS',
          'orderId' => '67RDG4GV4Z'
        }
      }
    )
    allow(authorize_request).to receive(:call).and_return(auth_response)
    allow(connection_builder).to receive(:call).and_return(connection)
    allow(connection)
      .to receive(:post)
      .with('https://secure.snd.payu.com/api/v2_1/orders')
      .and_return(response)

    result = subject.call(params: order_params)

    expect(result.status).to eq(200)
    expect(result.message).to eq('SUCCESSFULL')
    expect(result.body['status']['orderId']).to eq('67RDG4GV4Z')
  end

  it 'raises 400 Bad Request if invalid params passed' do
    order_params = {
      customerIp: '127.0.0.1',
      description: 'RTV market',
      currencyCode: 'PLN',
      totalAmount: '21000',
      buyer: {
        email: 'john.doe@example.com',
        phone: '654111654',
        firstName: 'John',
        lastName: 'Doe',
        language: 'pl'
      },
      products: []
    }

    response = double(
      :response,
      status: 400,
      reason_phrase: 'Bad Request',
      body: {
        'status' => {
          'statusCode' => 'ERROR_VALUE_MISSING',
          'severity' => 'ERROR',
          'code' => '8033',
          'codeLiteral' => 'MISSING_PRODUCTS',
          'statusDesc' => 'Missing required field'
        }
      }
    )
    allow(authorize_request).to receive(:call).and_return(auth_response)
    allow(connection_builder).to receive(:call).and_return(connection)
    allow(connection)
      .to receive(:post)
      .with('https://secure.snd.payu.com/api/v2_1/orders')
      .and_return(response)

    result = subject.call(params: order_params)

    expect(result.status).to eq(400)
    expect(result.message).to eq('Bad Request')
  end
end
