RSpec.describe PayU::Requests::PaymentMethods, :unit do
  it 'returns payment methods' do
    response = VCR.use_cassette('requests/pay_methods') do
      described_class.call
    end

    expect(response.status).to eq(200)
    expect(response.body).not_to be_empty
  end
end
