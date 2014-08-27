
describe Rainforest::Integrations::TextRenderer do
  include described_class

  let(:event) { sample_event }

  describe "#completion_text" do
    subject(:text) { completion_text(event) }

    it { should_not be_empty }

    it "should include the run id" do
      expect(text).to include("2")
    end

    it "should include a link to the run" do
      expect(text).to include(event.ui_link)
    end

    it "should include the run result" do
      expect(text).to include("no_result")
    end
  end

  describe "#error_text" do
    let(:event) { load_event_json("run_error") }
    subject(:text) { error_text(event) }

    it { should_not be_empty }

    it "should include the run id" do
      expect(text).to include("11153")
    end

    it "should include a link to the run" do
      expect(text).to include(event.ui_link)
    end

    it "should include the error reason" do
      expect(text).to include("You ran out of step variables")
    end
  end

  describe "#failure_text" do
    let(:event) { load_event_json("test_failure") }
    subject(:text) { failure_text(event) }

    it "should include the title of the failing test" do
      expect(text).to include("Switch to a pricing plan")
    end

    it "should include the name of the browser" do
      expect(text).to include("chrome")
    end
  end

  describe "#webhook_timeout_text" do
    let(:event) { load_event_json("webhook_timeout") }
    subject(:text) { webhook_timeout_text(event) }

    it { should_not be_empty }

    it "should include the run id" do
      expect(text).to include("6096")
    end

    it "should include a link to the run" do
      expect(text).to include(event.ui_link)
    end

  end

end

