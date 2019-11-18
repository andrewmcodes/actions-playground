require "test_helper"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[headless no-sandbox disable-dev-shm-usage enable-features=NetworkService,NetworkServiceInProcess]
    }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    url: "http://0.0.0.0:4444/wd/hub",
    desired_capabilities: capabilities
end

Capybara.default_driver = :headless_chrome
Capybara.javascript_driver = :headless_chrome

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  system("which chromedriver")
  driven_by :headless_chrome
end
