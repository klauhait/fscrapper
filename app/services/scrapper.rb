class Scrapper
  require "open-uri"
  require "nokogiri"

  def initialize
  end

  def fetch_recipe_urls
    url = "https://frichti.co/c/plats-frichti-group#plats"
    html = URI.open(url).read
    doc = Nokogiri::HTML(html)
    recepies = doc.search("a").each do |recipe|
      uri = URI.parse(recipe.attributes["href"].value)
      uri.scheme = "https"
      uri.host = "frichti.co/"
      uri.query = nil
      uri.to_s
    end
  end

  def scrap_recipe(url)
    doc = Nokogiri::HTML(URI.open.read)

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
