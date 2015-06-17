require 'spec_helper'
require 'event_validator'

describe EventValidator do
  describe '#validate!' do
    let(:event_name) { 'run_completion' }
    let(:payload) do
      {
        run: {
          id: 3,
          status: 'failed'
        },
        failed_tests: []
      }
    end

    subject { EventValidator.new(event_name, payload).validate! }

    context 'with a valid event' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with an invalid event name' do
      let(:event_name) { 'dinosaur_attack' }

      it 'raises an InvalidPayloadError' do
        expect { subject }.to raise_error EventValidator::InvalidPayloadError
      end
    end

    context 'with a payload with the wrong keys' do
      let(:payload) do
        {
          wrong_key: {}
        }
      end

      it 'raises an InvalidPayloadError' do
        expect { subject }.to raise_error EventValidator::InvalidPayloadError
      end
    end
  end
end
