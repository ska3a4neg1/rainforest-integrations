module Rainforest
  module Integrations
    describe Base do
      let(:concrete_class) do
        Class.new(described_class) do
          config do
            string :var1
            string :var2
          end

          receive_events 'test_failure'

          def on_event(event)
          end
        end
      end

      subject { concrete_class.new(arguments) }

      let(:defaults) do
        Class.new(described_class) do
        end
      end

      let(:arguments) { {var1: 'a', var2: 'b'} }

      describe "#config" do
        it "exposes the config" do
          expect(subject.config.var1).to eq('a')
          expect(subject.config.var2).to eq('b')
        end
      end

      describe ".receive_events" do
        it "defined the supports_event? method" do
          expect(subject.supports_event?('test_failure')).to be true
          expect(subject.supports_event?('run_failure')).to be false
        end
      end

      describe "#supports_event?" do
        subject { defaults.new }

        it "returns true for any valid event by default" do
          expect(subject.supports_event?('test_failure')).to be true
        end

        it "raises and ArgumentError for unknown event" do
          expect do
            subject.supports_event?('not-exists')
          end.to raise_error(ArgumentError)
        end
      end

      describe ".supported_events" do
        it "returns all events by defauls" do
          expect(defaults.supported_events).to eq(Event::TYPES)
        end

        it "only return list of filtered events when filtered" do
          expect(concrete_class.supported_events).to eq(['test_failure'])
        end
      end
    end
  end
end
