require "integrations/base"

module Integrations
  class Jira < Base
    def self.key
      'jira'
    end

    def send_event
      response = HTTParty.post(url,
        body: {
          fields: {
            project: { key: settings[:project_key] },
            summary: "Rainforest bug: #{'failed_tests'}",
            description: "Creating of an issue using project keys and issue type names using the REST API",
            issuetype: {
              name: "Bug"
            }
          }
        }.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        },
        basic_auth: {
          username: settings[:username],
          password: settings[:password]
        }
      )

      case response.code
      when 201
        # yay, that worked!
        true
      when 401
        raise Integrations::UserConfigurationError.new('Authentication failed. Wrong username and/or password. Keep in mind that your JIRA username is NOT your email address.')
      when 404
        raise Integrations::UserConfigurationError.new('This JIRA URL does exist.')
      else
        raise Integrations::MisconfiguredIntegrationError.new('Invalid request to the JIRA API.')
      end
    end

    private

    def url
      "#{jira_base_url}/rest/api/2/issue/"
    end

    def jira_base_url
      # MAKE SURE IT DOESN'T HAVE A TRAILING SLASH
      base_url = settings[:jira_base_url]
      base_url.last == "/" ? base_url.chop : base_url
    end
  end
end
