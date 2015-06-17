require 'spec_helper'
require 'integrations'

describe Integrations::Slack do
  describe '#initialize' do
    let(:event_name) { 'run_failure' }
    let(:payload) do
      {
        run: {
          id: 3,
          status: 'failed'
        }
      }
    end
    let(:settings) { { url: 'https://slack.com/bogus_integration' } }

    subject { described_class.new(event_name, payload, settings) }

    context 'without a valid integration url' do
      let(:settings) { {} }

      it 'raises a MisconfiguredIntegrationError' do
        expect { subject }.to raise_error Integrations::MisconfiguredIntegrationError
      end
    end
  end
end
