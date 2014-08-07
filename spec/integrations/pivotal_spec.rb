module Rainforest
  module Integrations
    describe Pivotal do
      let(:config) do
        {
          pivotal_api_token: "My Token",
          pivotal_project_id: "123456",
        }
      end

      subject { described_class.new config }

      it "posts to the Pivotal API" do
        stub_request(:post, subject.url)
        subject.on_event Event.sample_event
      end
    end
  end
end

