class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # Disable the browser check in the test environment so request specs run without requiring a UA string.
  allow_browser versions: :modern unless Rails.env.test?
end
