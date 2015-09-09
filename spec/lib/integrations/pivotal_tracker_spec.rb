require 'rails_helper'
require 'integrations'

describe Integrations::PivotalTracker do
  describe '#send_event' do
    let(:event_name) { "run_completion" }
    let(:payload) do
      {
        run: {
          id: 9,
          status: "failed",
          description: "rainforest run",
          time_to_finish: 750
        },
        frontend_url: "http://www.rainforestqa.com/",
        failed_tests: [
          {
            id: "20",
            name: "Always fails",
            url: "http://www.rainforestqa.com/"
          }
        ]
      }
    end
    let(:settings) do
      {
        project_id: 1141528,
        auth_token: "8537292c903ca580bcd10b800709a136",
      }
    end
    let(:expected_message) { "Your Rainforest Run <http://www.rainforestqa.com/ | Run #9: rainforest run> failed. Time to finish: 12 minutes 30 seconds" }
    let(:expected_url) { "https://www.pivotaltracker.com/services/v5/projects/#{settings[:project_id]}/stories" }
    let(:expected_description) do
      "Failed Tests:\n#{payload[:failed_tests][0][:name]}: #{payload[:failed_tests][0][:url]}\n"
    end
    let(:expected_params) do
      {
        body: {
          name: expected_message,
          description: expected_description,
          story_type: "bug",
          labels: [{ name: "rainforest" }]
        }.to_json,
        headers: {
          "X-TrackerToken" => "#{settings[:auth_token]}",
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }
      }
    end

    subject { described_class.new(event_name, payload, settings) }

    it "sends a correctly formatted request" do
      expect(HTTParty).to receive(:post).with(expected_url, expected_params).and_call_original
      VCR.use_cassette('generic_pivotal_tracker_notification') do
        expect{ subject.send_event }.to_not raise_error
      end
    end

    context "with wrong project ID" do
      before do
        settings[:project_id] = 1337
      end

      it "returns a user configuration error" do
        VCR.use_cassette('pivotal_tracker_wrong_id') do
          expect{ subject.send_event }.to raise_error Integrations::UserConfigurationError
        end
      end
    end

    context "with invalid authorization token" do
      before do
        settings[:auth_token] = "foobar"
      end

      it "returns a user configuration error" do
        VCR.use_cassette('pivotal_tracker_wrong_auth_token') do
          expect{ subject.send_event }.to raise_error Integrations::UserConfigurationError
        end
      end
    end
  end
end
