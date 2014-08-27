require "active_support/core_ext/string"

describe Rainforest::Integrations::Slack do

  let(:config) do
    {slack_url: "http://example.com/slack"}
  end

  let(:event) { load_event_json("test_failure") }

  subject(:integration) { described_class.new config }

  it "posts to the Slack API" do
    stub_request(:post, subject.url)
    subject.on_event event
  end

  describe "payload" do
    subject(:payload) { integration.render_event(event) }

    describe "pretext field" do
      subject(:pretext) { payload[:pretext] }

      it { should include "Errors were reported" }

      it "should include the failing test title" do
        expect(pretext).to include "Switch to a pricing plan"
      end

      it "should include a link to the ui" do
        expect(pretext).to include event.ui_link
      end
    end

    describe "fields" do
      subject(:fields) { payload[:fields] }

      it "should have an item for each failed step" do
        expect(fields.size).to eq(1)
      end

      describe "title" do
        subject(:title) { fields.first[:title] }

        it "should include the result of the step" do
          expect(title).to include "failed"
        end

        it "should include the title of the step" do
          expect(title).to include "Locate a pricing plan"
        end

        it "should include the response of the step" do
          expect(title).to include "Did you get a"
        end
      end

      describe "feedback" do
        subject(:value) { fields.first[:value] }

        it "should include the feedback" do
          expect(value).to include "Getting error message"
        end

        it "should include the user agent" do
          expect(value).to include "Mozilla"
        end

        it "should include a screenshot" do
          expect(value).to include "Screenshot: https://s3.amazonaws.com/store.rainforestapp.com/"
        end
      end
    end
  end

end

