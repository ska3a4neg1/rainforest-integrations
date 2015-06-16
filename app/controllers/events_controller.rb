require 'integrations'

class EventsController < ApplicationController
  SIGNING_KEY = ENV.fetch('INTEGRATIONS_SIGNING_KEY').freeze

  before_action :verify_signature

  def create
    begin
      body = MultiJson.load(request.body.read, symbolize_keys: true)
      Integrations.send_event(body)
      render json: { status: 'ok' }, status: :created
    end
  end

  private

  def verify_signature
    body_string = request.body.read
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.hexdigest(digest, SIGNING_KEY, body_string)

    unless request.headers['X-SIGNATURE'] == hmac
      render json: { status: 'unauthorized' }, status: :unauthorized
    end
  end
end
