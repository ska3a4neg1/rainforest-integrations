
describe Rainforest::Integrations::HtmlRenderer do
  include described_class

  let(:event) { sample_event }

  describe "#completion_html" do
    subject(:html) { completion_html(event) }

    it { should_not be_empty }

    it "should include the run id" do
      expect(html).to include("2")
    end

    it "should include a link to the run" do
      expect(html).to include(event.ui_link)
    end

    it "should include the run result" do
      expect(html).to include("no_result")
    end
  end

  describe "#error_html" do
    let(:event) { load_event_json("run_error") }
    subject(:html) { error_html(event) }

    it { should_not be_empty }

    it "should include the run id" do
      expect(html).to include("11153")
    end

    it "should include a link to the run" do
      expect(html).to include(event.ui_link)
    end

    it "should include the error reason" do
      expect(html).to include("You ran out of step variables")
    end
  end

  describe "#failure_html" do
    let(:event) { load_event_json("test_failure") }
    subject(:html) { failure_html(event) }

    it "should include the title of the failing test" do
      expect(html).to include("Switch to a pricing plan")
    end

    it "should include the name of the browser" do
      expect(html).to include("chrome")
    end
  end

  describe "#webhook_timeout_html" do
    let(:event) { load_event_json("webhook_timeout") }
    subject(:html) { webhook_timeout_html(event) }

    it { should_not be_empty }

    it "should include the run id" do
      expect(html).to include("6096")
    end

    it "should include a link to the run" do
      expect(html).to include(event.ui_link)
    end

  end

end

