RSpec.describe PayU::Requests::PaymentMethods, :unit do
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
  let(:response) do
    double(:response,
      body: {
        'cardTokens' => [],
        'pexTokens' => [],
        'payByLinks' => [
          { 'value' => 'dp',
            'brandImageUrl' => 'https://static.payu.com/images/mobile/logos/pbl_dp.png',
            'name' => 'Płacę później',
            'status' => 'ENABLED',
            'minAmount ' => 1000,
            'maxAmount' => 2000
          },
          { 'value' => 'ai',
            'brandImageUrl' => 'https://static.payu.com/images/mobile/logos/pbl_ai.png',
            'name' => 'Raty PayU',
            'status' => 'ENABLED',
            'minAmount' => 1000,
            'maxAmount' => 2000
          },
          { 'value' => 'ap',
            'brandImageUrl' => 'https://static.payu.com/images/mobile/logos/pbl_ap.png',
            'name' => 'Google Pay',
            'status' => 'ENABLED',
            'minAmount' => 50,
            'maxAmount' => 9999
          },
          { 'value' => 'blik',
            'brandImageUrl' => 'https://static.payu.com/images/mobile/logos/pbl_blik.png',
            'name' => 'BLIK',
            'status' => 'ENABLED',
            'minAmount' => 100,
            'maxAmount' => 9999
          },
          { 'value' => 'p',
            'brandImageUrl' => 'https://static.payu.com/images/mobile/logos/pbl_p.png',
            'name' => 'Płacę z iPKO',
            'status' => 'ENABLED',
            'minAmount' => 50,
            'maxAmount' => 9999
          },
          { 'value' => 'm',
            'brandImageUrl' => 'https://static.payu.com/images/mobile/logos/pbl_m.png',
            'name' => 'mTransfer',
            'status' => 'ENABLED',
            'minAmount' => 50,
            'maxAmount' => 9999
          },
          { 'value' => 'o',
            'brandImageUrl' => 'https://static.payu.com/images/mobile/logos/pbl_o.png',
            'name' => 'Płacę z Bankiem Pekao S.A.',
            'status' => 'ENABLED',
            'minAmount' => 50,
            'maxAmount' => 9999
          },
          { 'value' => 'c',
            'brandImageUrl' => 'https://static.payu.com/images/mobile/logos/pbl_c.png',
            'name' => 'Płatność online kartą płatniczą',
            'status' => 'ENABLED',
            'minAmount' => 1,
            'maxAmount' => 1000
          }
        ],
        'status' => { 'statusCode' => 'SUCCESS' }
      },
      status: 200,
      reason_phrase: ''
    )
  end
  subject do
    described_class.new(
      connection_builder: connection_builder,
      authorize_request: authorize_request
    )
  end

  it 'returns payment methods' do
    allow(authorize_request).to receive(:call).and_return(auth_response)
    allow(connection_builder).to receive(:call).and_return(connection)
    allow(connection)
      .to receive(:get)
      .with('https://secure.snd.payu.com/api/v2_1/paymethods')
      .and_return(response)

    result = subject.call

    expect(result.status).to eq(200)
    expect(result.body).not_to be_empty
  end
end
