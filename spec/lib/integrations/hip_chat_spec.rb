require 'rails_helper'
require 'integrations'

describe Integrations::HipChat do
  describe '#send_event' do
    let(:event_name) { "run_completion" }
    let(:payload) do
      {
        run: {
          id: 9,
          state: "failed",
          description: "rainforest run",
          time_to_finish: 750
        },
        frontend_url: "http://www.rainforestqa.com/",
        failed_tests: {
          name: "Always fails"
        }
      }
    end
    let(:settings) do
      {
        room_id: "Rainforestqa",
        room_token: "SFLaaWu13VxCd7ew4FqNnNJeCcoAZ8MF4kofX3GZ",
        notify: true
      }
    end
    let(:expected_message) { "Your Rainforest Run (<a href=\"http://www.rainforestqa.com/\">Run #9: rainforest run</a>) failed. Time to finish: 12 minutes 30 seconds" }
    let(:expected_url) { "https://api.hipchat.com/v2/room/#{settings[:room_id]}/notification" }
    let(:expected_params) do
      {
        body: {
          color: "red",
          message: expected_message,
          notify: true,
          message_format: "html"
        }.to_json,
        headers: {
          "Authorization" => "Bearer #{settings[:room_token]}",
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }
      }
    end

    subject { described_class.new(event_name, payload, settings) }

    it "sends a correctly formatted request" do
      expect(HTTParty).to receive(:post).with(expected_url, expected_params).and_call_original
      VCR.use_cassette('generic_hip_chat_notification') do
        expect(subject.send_event).to be_truthy
      end
    end

    context "with room ID" do
      before do
        settings[:room_id] = "Rainforestqafakeroom"
      end

      it "returns a user configuration error" do
        VCR.use_cassette('hip_chat_wrong_room_id') do
          expect{ subject.send_event }.to raise_error Integrations::UserConfigurationError
        end
      end
    end

    context "with invalid authorization token" do
      before do
        settings[:auth_token] = "foobar"
      end

      it "returns a user configuration error" do
        VCR.use_cassette('hip_chat_wrong_auth_token') do
          expect{ subject.send_event }.to raise_error Integrations::UserConfigurationError
        end
      end
    end
  end
end
