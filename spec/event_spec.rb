module Rainforest
  module Integrations
    describe Event do
      describe ".sample_event" do
        subject { described_class.sample_event }

        it "returns a correctly constructed sample event" do
          expect(subject.to_html).to include("<")
          expect(subject.to_html).to include(">")

          expect(subject.to_text).to be_a(String)
          expect(subject.failure?).to be(true)
        end
      end
    end
  end
end
