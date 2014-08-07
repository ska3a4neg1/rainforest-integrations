module Rainforest
  describe Integrations do
    describe ".send_event" do
      let(:event) do
        {
          type: "test_failure",
          text: "Some text",
          html: "Some html",
          is_failure: false,
        }
      end

      it "sends an event to a specific integration" do
        expect_any_instance_of(Integrations::Hipchat).to receive(:on_event) do |receiver, event|
          expect(event).to be_an(described_class::Event)
        end
        described_class.send_event :hipchat, event: event, config: {}
      end

      context "an integration that only supports some event" do
        let(:integration) do
          Class.new(described_class::Base) do
            receive_events 'test_failure'
          end.new({})
        end

        it "only calls #on_event if the integrations cares about it" do
          expect(integration).to receive(:on_event).once
          described_class.send_event integration, event: event, config: {}
          described_class.send_event integration, event: event.merge(type: 'run_failure'), config: {}
        end
      end
    end
  end
end
