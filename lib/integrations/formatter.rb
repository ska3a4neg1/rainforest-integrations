module Integrations
  module Formatter
    def message_text
      message = self.send(event_name.dup.concat("_message").to_sym)
      "Your Rainforest Run (#{run_href}) #{message}"
    end

    def run_href
      "Run ##{run[:id]}#{run_description} - #{payload[:frontend_url]}"
    end

    def test_href
      failed_test = payload[:failed_test]
      "Test ##{failed_test[:id]}: #{failed_test[:title]} - #{failed_test[:frontend_url]} (#{failed_test[:browser]})"
    end

    def run_description
      run[:description] ? ": #{run[:description]}" : ""
    end

    def run_completion_message
      "#{run[:state]}. #{time_to_finish}"
    end

    def run_error_message
      if run[:error_reason].nil? || run[:error_reason].empty?
        run[:error_reason] = "unspecified reason (please contact help@rainforestqa.com if you'd like help debugging this)"
      end

      "errored: #{run[:error_reason]}."
    end

    def run_webhook_timeout_message
      "has timed out due to your webhook failing. If you need a hand debugging it, please let us know via email at help@rainforestqa.com."
    end

    def run_test_failure_message
      "has a failed at test! #{test_href}"
    end

    def time_to_finish
      "Time to finish: #{humanize_secs(run[:time_to_finish])}"
    end

    def humanize_secs(seconds)
      secs = seconds.to_i
      [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map do |count, name|
        if secs > 0
          secs, n = secs.divmod(count)
          "#{n.to_i} #{name}"
        end
      end.compact.reverse.join(' ')
    end
  end
end
