require "active_support/core_ext/string/strip"

module Rainforest::Integrations
  module TextRenderer

    def render_text(event)
      case event.name
      when "of_run_completion"                then completion_text(event)
      when "of_run_error"                     then error_text(event)
      when "of_test_failure"                  then failure_text(event)
      when "of_run_timeout_because_of_webook" then webhook_timeout_text(event)
      end
    end

    def completion_text(event)
      run = event.run
      <<-TEXT.strip_heredoc
        Your Rainforest run [#{run["id"]}](#{event.ui_link}#{run_description(event.run)}) #{run["result"]}.
      TEXT
    end

    def error_text(event)
      run = event.run
      <<-TEXT.strip_heredoc
        Your Rainforest run [#{run["id"]}](#{event.ui_link}#{run_description(event.run)}) just errored: '#{run["error_reason"]}'
      TEXT
    end

    def failure_text(event)
      run = event.run
      browser_result = event.browser_result
      <<-TEXT.strip_heredoc
        Your test '#{browser_result["failing_test"]["title"]}' just failed in #{browser_result["name"]}.
      TEXT
    end

    def webhook_timeout_text(event)
      run = event.run
      <<-TEXT.strip_heredoc
        Your Rainforest run [#{run["id"]}](#{event.ui_link}#{run_description(event.run)}) timed out due to your webhook failing. If you need a hand debugging it, please let us know via email at team@rainforestqa.com
      TEXT
    end

    def run_description(run)
      unless run["description"].nil? or run["description"].empty?
        %{ (run["description"])}
      end
    end
  end
end
