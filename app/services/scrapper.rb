require 'webdrivers/chromedriver'
require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'

class Scrapper < ApplicationService
  def call
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end

    Capybara.register_driver :headless_chrome do |app|
      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        capabilities:  [Selenium::WebDriver::Chrome::Options.new(
          args: %w[headless enable-features=NetworkService,NetworkServiceInProcess disable-gpu no-sandbox window-size=1024,768],
        )]
    end

    Capybara.default_driver = :headless_chrome
    Capybara.javascript_driver = :headless_chrome

    Capybara.configure do |config|
      config.default_max_wait_time = 10 # seconds
      config.default_driver = :headless_chrome
    end

    # Visit
    browser = Capybara.current_session
    driver = browser.driver.browser

    browser.visit 'https://frichti.co/c/paques--group'

    puts "start scrapping"
    # fetch_recipe_urls# .map do |url|
      # puts url
      # scrap_recipe(url)
    # end
    sleep(30)

    puts browser.html
  end

  def fetch_recipe_urls
    puts "ici"
    url = "https://frichti.co/c/plats-frichti-group#plats"
    html = URI.open(url).read
    doc = Nokogiri::HTML(html)

    puts doc.search("a")

    doc.search("a").map do |recipe|
      uri = URI.parse(recipe.attributes["href"].value)
      uri.scheme = "https"
      uri.host = "frichti.co/"
      uri.query = nil
      uri.to_s
    end
  end

  def scrap_recipe(url)
    doc = Nokogiri::HTML(URI.open(url).read)

    recipe_type = doc.search('.sc-ddfdc42b-1 hIVtIn p').text
    recipe_title = doc.search('.sc-ddfdc42b-1 hIVtIn h1').text
    recipe_ingredient = doc.search('.sc-86b8c208-0 p').text

    {
      recipe_title: recipe_title,
      recipe_type: recipe_type,
      recipe_ingredient: recipe_ingredient
    }
  end
end
