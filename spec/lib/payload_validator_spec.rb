require 'rails_helper'
require 'payload_validator'

describe PayloadValidator do
  describe '#validate!' do
    let(:event_name) { 'run_completion' }
    let(:payload) do
      {
        run: {
          id: 3,
          status: 'failed'
        },
        frontend_url: "http://www.rainforestqa.com/",
        failed_tests: []
      }
    end
    let(:integrations) { [] }

    subject { PayloadValidator.new(event_name, integrations, payload).validate! }

    context 'with a valid event' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with an invalid event name' do
      let(:event_name) { 'dinosaur_attack' }

      it 'raises an InvalidPayloadError' do
        expect { subject }.to raise_error PayloadValidator::InvalidPayloadError
      end
    end

    context 'with a payload with the wrong keys' do
      let(:payload) do
        {
          wrong_key: {}
        }
      end

      it 'raises an InvalidPayloadError' do
        expect { subject }.to raise_error PayloadValidator::InvalidPayloadError
      end
    end
  end
end
