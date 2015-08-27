require 'raven'

Raven.configure do |config|
  config.dsn = ENV.fetch('INTEGRATION_SENTRY_DNS')
  config.tags = { environment: Rails.env }
  config.environments = %w[ production staging qa ]
end
