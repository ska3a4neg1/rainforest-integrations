module Rainforest
  module Integrations
    describe Event do

      it "should handle the sample payload" do
        event = Event.new(sample_event_payload)
        expect(event.name).to eq(sample_event_payload["name"])
      end

    end
  end
end
