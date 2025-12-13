# config/initializers/allow_browser.rb

begin
  require "allow_browser"

  if Rails.env.test?
  # No-op in tests
else
  AllowBrowser.configure do |config|
    config.versions = :modern
    config.enabled = true
  end
end
rescue LoadError
  # If the gem is not installed, skip browser checks entirely
  Rails.logger.warn "allow_browser gem not found, skipping browser version check"
end
