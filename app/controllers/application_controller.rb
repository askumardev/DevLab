class ApplicationController < ActionController::Base
  #skip_before_action :verify_authenticity_token if Rails.env.test?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # Disable the browser check in the test environment so request specs run without requiring a UA string.
  #allow_browser versions: :modern unless Rails.env.test?

  skip_before_action :verify_authenticity_token if Rails.env.test?

  # Only allow modern browsers, disable in test
  #allow_browser versions: :modern unless Rails.env.test? #if respond_to?(:allow_browser)
end
