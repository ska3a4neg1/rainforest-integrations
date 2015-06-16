class EventsController < ApplicationController
  SIGNING_KEY = ENV.fetch('INTEGRATIONS_SIGNING_KEY').freeze

  before_action :verify_signature

  def create
    render json: { response: 'Ok' }, status: :created
  end

  private

  def verify_signature
    body_string = request.body.read
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.hexdigest(digest, SIGNING_KEY, body_string)

    unless request.headers['X-SIGNATURE'] == hmac
      render json: { response: 'Unauthorized' }, status: :unauthorized
    end
  end
end
