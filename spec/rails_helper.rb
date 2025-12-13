# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
ENV['BOOTSNAP_DISABLE'] = '1'
begin
  require 'action_mailer'
rescue LoadError
  # ignore if not available yet
end

# Provide a safe compatibility writer for older/newer ActionMailer APIs during test boot
if defined?(ActionMailer::Base) && !ActionMailer::Base.respond_to?(:preview_path=)
  class << ActionMailer::Base
    def preview_path=(_val)
      # prefer plural API if available
      if respond_to?(:preview_paths)
        self.preview_paths = Array(_val)
      end
    end
  end
end

require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
## Temporarily disabled: adding mailer preview paths during spec boot
## This was triggering a load-time error in some container/test boots
## (undefined method `preview_path=' for ActionMailer::Base). Re-enable
## after debugging boot/load-order issues.
# begin
#   if Rails.application.config.action_mailer.respond_to?(:preview_paths)
#     Rails.application.config.action_mailer.preview_paths << Rails.root.join("spec/mailers/previews")
#   elsif defined?(ActionMailer::Base) && ActionMailer::Base.respond_to?(:preview_paths)
#     ActionMailer::Base.preview_paths << Rails.root.join("spec/mailers/previews")
#   end
# rescue NoMethodError, NameError
#   # Guard against raising during spec bootstrap — leave previews unset.
# end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
