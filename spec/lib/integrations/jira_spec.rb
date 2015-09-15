require 'rails_helper'
require 'integrations'

describe Integrations::Jira do
  subject { described_class.new(event_name, payload, settings) }

  let(:event_name) { 'run_failure' }
  let(:payload) do
    {
      run: {
        id: 3,
        status: 'failed'
      }
    }
  end
  let(:settings) do
    {
      username: 'admin',
      password: 'something',
      jira_base_url: 'http://example.com',
      project_key: 'ABC'
    }
  end

  describe '#send_event' do
    let(:send_event) { subject.send_event }

    context 'when everything works' do
      let(:settings) do
        {
          username: 'admin',
          password: 'eizEcahrGBQAfT9BBhgoLvYikbpxZZ2LjvJVojevfpRWBBbFgj',
          jira_base_url: 'https://rainforest-integration-testing.atlassian.net',
          project_key: 'MVBP'
        }
      end

      it 'creates an issue' do
        VCR.use_cassette('jira/create-an-issue') do
          expect(send_event).to eq true
        end
      end
    end

    context 'when there is an authentication error' do
      it 'raises a Integrations::UserConfigurationError' do
        settings[:jira_base_url] = 'https://rainforest-integration-testing.atlassian.net'

        VCR.use_cassette('jira/authentication-error') do
          expect { send_event }.to raise_error(Integrations::UserConfigurationError, 'Authentication failed. Wrong username and/or password. Keep in mind that your JIRA username is NOT your email address.')
        end
      end
    end

    context 'when there the JIRA base URL is wrong' do
      it 'raises a Integrations::UserConfigurationError' do
        VCR.use_cassette('jira/wrong-base-url') do
          expect { send_event }.to raise_error(Integrations::UserConfigurationError, 'This JIRA URL does exist.')
        end
      end
    end

    context 'for any other error' do
      it 'raises Integrations::MisconfiguredIntegrationError' do
        mock_response = double('mock response')
        allow(mock_response).to receive(:code).and_return(500)
        allow(HTTParty).to receive(:post).and_return(mock_response)
        expect { send_event }.to raise_error(Integrations::MisconfiguredIntegrationError, 'Invalid request to the JIRA API.')
      end
    end
  end

  describe '#jira_base_url' do
    subject { described_class.new(event_name, payload, settings).send(:jira_base_url) }

    before do
      settings[:jira_base_url] = jira_base_url_setting
    end

    context 'when URL has a trailing slash' do
      let(:jira_base_url_setting) { 'http://localhost/' }

      it 'removes it' do
        expect(subject).to eq 'http://localhost'
      end
    end

    context 'when URL does NOT have a trailing slash' do
      let(:jira_base_url_setting) { 'http://localhost' }

      it 'does nothing' do
        expect(subject).to eq 'http://localhost'
      end
    end
  end
end
