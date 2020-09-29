# frozen_string_literal: true

RSpec.describe PayU::Requests::PaymentMethods, :unit do
  it 'returns payment methods' do
    token = double(:token)
    response = double(:response, token: token)

    response = VCR.use_cassette('requests/pay_methods') do
      expect(PayU::Requests::Authorize).to receive(:call)
        .and_return(response)

      described_class.call
    end

    expect(response.status).to eq(200)
    expect(response.body).not_to be_empty
  end
end
