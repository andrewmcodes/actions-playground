require "test_helper"

if ENV["SELENIUM_REMOTE_URL"]
  Capybara.server_host = '0.0.0.0'
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {
        args: %w[
          headless disable-gpu no-sandbox
          --window-size=1400,1400 --enable-features=NetworkService,NetworkServiceInProcess
        ]
      }
    )

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 90

    Capybara::Selenium::Driver.new app,
      browser: :chrome,
      url: ENV["SELENIUM_REMOTE_URL"],
      desired_capabilities: capabilities,
      http_client: client
  end

  Capybara.default_driver = :headless_chrome
  Capybara.javascript_driver = :headless_chrome
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV["SELENIUM_REMOTE_URL"]
    driven_by :headless_chrome
  else
    driven_by :selenium, using: :headless_chrome
  end
end
