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

      context 'when there is a 403 error' do
        let(:error_response) do
          {
            'code' => 'unauthorized_operation',
            'kind' => 'error',
            'error' => 'Authorization failure.',
            'general_problem' => 'You did it wrong',
            'possible_fix' => 'Fix it!'
          }
        end

        before do
          stub_request(:post, subject.url)
            .to_return(status: 403,
                       body: error_response.to_json)
        end

        it 'raises a ConfigurationError' do
          expect { subject.on_event sample_job_failure_event }
            .to raise_error ConfigurationError
        end
      end

      context 'when there is a 5xx error' do
        before do
          stub_request(:post, subject.url)
            .to_return(status: 500,
                       body: 'Something is horribly wrong')
        end

        it 'raises the an HttpException' do
          expect { subject.on_event sample_job_failure_event }
            .to raise_error Http::Exceptions::HttpException
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
