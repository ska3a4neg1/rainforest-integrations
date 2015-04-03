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
        subject.on_event sample_job_failure_event
      end

      context 'when the API token is blank' do
        let(:config) do
          {
            pivotal_api_token: '',
            pivotal_project_id: '123456'
          }
        end

        it 'does nothing' do
          expect { subject.on_event sample_event }.to_not raise_error
        end
      end

      context 'when the project id is blank' do
        let(:config) do
          {
            pivotal_api_token: 'My Token',
            pivotal_project_id: ''
          }
        end

        it 'does nothing' do
          expect { subject.on_event sample_event }.to_not raise_error
        end
      end
    end
  end
end
