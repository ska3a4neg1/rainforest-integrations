module Rainforest
  describe Integrations do
    describe ".send_event" do
      it "sends an event to a specific integration" do
        expect_any_instance_of(Integrations::Hipchat).to receive(:on_event) do |receiver, event|
          expect(event).to be_an(described_class::Event)
        end
        described_class.send_event :hipchat, event: {
          text_message: "",
          html_message: "",
          # TODO add more things here
        }, config: {}

      end
    end
  end
end
