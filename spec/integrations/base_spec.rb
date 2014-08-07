module Rainforest
  module Integrations
    describe Base do
      let(:subject) do
        Class.new(described_class) do
          config do
            string :var1
            string :var2
          end

          def on_event(event)
          end
        end.new(arguments)
      end

      describe "#config" do
        let(:arguments) { {var1: 'a', var2: 'b'} }

        it "exposes the config" do
          expect(subject.config.var1).to eq('a')
          expect(subject.config.var2).to eq('b')
        end
      end
    end
  end
end
