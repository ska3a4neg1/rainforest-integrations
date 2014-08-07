module Rainforest
  describe Integrations do
    describe ".send_event" do
      it "sends an event to a specific integration" do
        expect_any_instance_of(Integrations::Hipchat).to receive(:on_event) do |receiver, event|
          expect(event).to be_an(described_class::Event)
        end
        described_class.send_event :hipchat, event: {
          text: "Some text",
          html: "Some html",
          is_failure: false,
        }, config: {}

      end
    end
  end
end
