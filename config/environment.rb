# Load the Rails application.
require File.expand_path('../application', __FILE__)

CONFIG_PATH="#{Rails.root}/config/config.yml"
#APP_CONFIG = YAML.load_file(CONFIG_PATH)[Rails.env]
APP_CONFIG = YAML.load_file(CONFIG_PATH)

# Initialize the Rails application.
TwittwarApp::Application.initialize!

