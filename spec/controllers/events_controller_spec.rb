require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:payload) do
    {
      event_name: 'something'
    }.to_json
  end

  before do
    @request.headers['Accept'] = 'application/json'
    @request.headers['Content-Type'] = 'application/json'
  end

  describe "POST create" do
    let(:key) { "fakefakefake" }
    before do
      stub_const('EventsController::SIGNING_KEY', key)
    end

    context "with a valid HMAC signature" do
      before do
        @request.headers['X-SIGNATURE'] = sign(payload, key)
      end

      it 'returns a 201' do
        post :create, payload
        expect(response.code).to eq '201'
        expect(json['status']).to eq 'ok'
      end
    end

    context 'without valid HMAC signature' do
      it 'returns a 401' do
        post :create, payload
        expect(response.code).to eq '401'
        expect(json['status']).to eq 'unauthorized'
      end
    end

    context 'with invalid HMAC signature' do
      before do
        @request.headers['X-SIGNATURE'] = 'wrong signature'
      end

      it 'returns a 401' do
        post :create, payload
        expect(response.code).to eq '401'
      end
    end
  end

  def sign(payload, key)
    digest = OpenSSL::Digest.new('sha256')
    OpenSSL::HMAC.hexdigest(digest, key, payload)
  end

  def json
    JSON.parse(response.body)
  end
end
