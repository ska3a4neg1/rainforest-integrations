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

  describe "send to Slack" do
    context "notify of run_completion" do
      let(:event_name) { "run_completion" }
      let(:payload) { {:id => 0} }
      let(:settings) { {:url => "https://hooks.slack.com/services/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"} }

      it 'sends a message to Slack' do
        VCR.use_cassette('run_completion_notify_slack') do
          Integrations::Slack.new(event_name, payload, settings).send_event
        end
      end
    end

    context "notify of run_error" do
      let(:event_name) { "run_error" }
      let(:payload) { {:id => 0} }
      let(:settings) { {:url => "https://hooks.slack.com/services/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"} }

      it 'sends a message to Slack' do
        VCR.use_cassette('run_error_notify_slack') do
          Integrations::Slack.new(event_name, payload, settings).send_event
        end
      end
    end

    context "notify of run_webhook_timeout" do
      let(:event_name) { "run_webhook_timeout" }
      let(:payload) { {:id => 0} }
      let(:settings) { {:url => "https://hooks.slack.com/services/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"} }

      it 'sends a message to Slack' do
        VCR.use_cassette('run_webhook_timeout_notify_slack') do
          Integrations::Slack.new(event_name, payload, settings).send_event
        end
      end
    end

    context "notify of run_test_failure" do
      let(:event_name) { "run_test_failure" }
      let(:payload) { {:id => 0} }
      let(:settings) { {:url => "https://hooks.slack.com/services/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"} }

      it 'sends a message to Slack' do
        VCR.use_cassette('run_test_failure_notify_slack') do
          Integrations::Slack.new(event_name, payload, settings).send_event
        end
      end
    end

  end

  describe '#message_color' do
    subject { Integrations::Slack.new(event_name, payload, settings).message_color }

    let(:settings) { { url: 'https://slack.com/bogus_integration' } }
    let(:payload) do
      {
        run: {
          id: 3,
          status: 'passed'
        }
      }
    end

    context 'run_completion' do
      let(:event_name) { 'run_completion' }

      context 'when the run is failed' do
        let(:payload) do
          {
            run: {
              id: 3,
              status: 'failed'
            }
          }
        end

        it { is_expected.to eq 'danger' }
      end

      context 'when the run is NOT failed' do
        it { is_expected.to eq 'good' }
      end
    end

    context 'run_error' do
      let(:event_name) { 'run_error' }

      it { is_expected.to eq 'danger' }
    end

    context 'run_webhook_timeout' do
      let(:event_name) { 'run_webhook_timeout' }

      it { is_expected.to eq 'danger' }
    end

    context 'run_test_failure' do
      let(:event_name) { 'run_test_failure' }

      it { is_expected.to eq 'danger' }
    end
  end
end
