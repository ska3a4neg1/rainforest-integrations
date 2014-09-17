module Rainforest
  module Integrations
    describe Hipchat do
      let(:config) do
        {
          hipchat_room: "My Room",
          hipchat_token: "My Token",
        }
      end

      subject { described_class.new config }

      it "posts to the Hipchat API" do
        stub_request(:post, described_class::URL)
        subject.on_event sample_event
      end

      it "posts job failures to the Hipchat API" do
        stub_request(:post, described_class::URL)
        subject.on_event sample_job_failure_event
      end

      context "with an error response" do
        let(:response_body) { '{"error":{"code":401,"type":"Unauthorized","message":"Auth token invalid. Please see: https:\/\/www.hipchat.com\/docs\/api\/auth"}}' }

        it "raises a ConfigurationError" do
          stub_request(:post, described_class::URL).
            to_return(body: response_body, status: 401)

          expect {
            subject.on_event sample_job_failure_event
          }.to raise_error(Rainforest::Integrations::ConfigurationError)
        end

      end
    end
  end
end
