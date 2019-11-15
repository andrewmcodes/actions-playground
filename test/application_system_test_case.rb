require "test_helper"
# require "webdrivers/chromedriver"

if ENV["SELENIUM_REMOTE_URL"]
  Capybara.javascript_driver = :selenium
  Capybara.run_server = false
  `echo "-------"`
  args = ["--no-default-browser-check", "--start-maximized", "--no-sandbox", "--disable-dev-shm-usage"]
  caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => args})
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: ENV["SELENIUM_REMOTE_URL"],
      desired_capabilities: caps
    )
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome
end
