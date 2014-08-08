module Rainforest
  module Integrations
    module Config
      describe Config do
        subject do
          Config.new do
            string :var1
            string :var2
          end
        end

        describe "valid?" do
          it "returns true if the all the fields are present" do
            config = {var1: 'a', var2: 'b'}
            expect(subject.valid?(config)).to be(true)
          end

          it "returns false if the config is missing a attribute" do
            config = {var1: 'a'}
            expect(subject.valid?(config)).to be(false)
          end
        end
      end
    end
  end
end

