RSpec.describe PayU::Client, :unit do
  it 'finds an order by id' do
    id = '123wd34f3fsd'
    order = double(
      :order,
      order_id: id,
      order_created_at: '2019-12-28',
      notify_url: 'https://notify.me',
      customer_ip: '1.2.3.4',
      merchant_pos_id: 1234,
      description: 'Household appliances',
      currency_code: 'PLN',
      total_amount: 1234,
      status: 'Processing successful',
      products: [
        {
          name: 'Samsung TV'
        },
        {
          name: 'Iron'
        }
      ]
    )
    allow(PayU::Requests::GetOrder)
      .to receive(:call)
      .with(order_id: id)
      .and_return(order)

    result = described_class.find_order(id)

    expect(result.status).to eq('Processing successful')
    expect(result.products).not_to be_empty
    expect(result.order_id).to eq(id)
  end

  it 'creates an order with params' do
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

    allow(PayU::Requests::CreateOrder)
      .to receive(:call)
      .with(params: order_params)
      .and_return(response)

    result = described_class.create_order(order_params)

    expect(result.status).to eq(200)
    expect(result.reason_phrase).to eq('SUCCESSFULL')
    expect(result.body['status']['orderId']).to eq('67RDG4GV4Z')
  end

  it 'returns payment methods' do
    response = double(
      :response,
      body: {
        'cardTokens' => [],
        'pexTokens' => [],
        'payByLinks' => [
          { 'value' => 'dp',
            'brandImageUrl' => 'https://static.payu.com/images/mobile/logos/pbl_dp.png',
            'name' => 'Płacę później',
            'status' => 'ENABLED',
            'minAmount ' => 1000,
            'maxAmount' => 2000 }
        ],
        'status' => { 'statusCode' => 'SUCCESS' }
      },
      status: 200,
      reason_phrase: ''
    )

    allow(PayU::Requests::PaymentMethods)
      .to receive(:call)
      .and_return(response)

    result = described_class.payment_methods

    expect(result.body).to have_key('cardTokens')
    expect(result.body).to have_key('pexTokens')
    expect(result.body).to have_key('payByLinks')
    expect(result.body).to have_key('status')
    expect(result.status).to eq(200)
  end
end
