require 'integrations'
require 'event_validator'

class EventsController < ApplicationController
  SIGNING_KEY = ENV.fetch('INTEGRATIONS_SIGNING_KEY').freeze

  before_action :verify_signature

  def create
    begin
      body = MultiJson.load(request.body.read, symbolize_keys: true)
      unless %i(event_name integrations payload).all? { |key| body.key? key }
        return invalid_request
      end

      Integrations.send_event(body)
      render json: { status: 'ok' }, status: :created
    rescue MultiJson::ParseError
      invalid_request
    rescue Integrations::UnsupportedIntegrationError => e
      invalid_request e.message
    rescue Integrations::MisconfiguredIntegrationError => e
      invalid_request e.message
    rescue EventValidator::InvalidPayloadError => e
      invalid_request e.message
    end
  end

  private

  def invalid_request(message = 'invalid request')
    render json: { error: message }, status: 400
  end

  def verify_signature
    body_string = request.body.read
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.hexdigest(digest, SIGNING_KEY, body_string)

    unless request.headers['X-SIGNATURE'] == hmac
      render json: { status: 'unauthorized' }, status: :unauthorized
    end
  end
end
