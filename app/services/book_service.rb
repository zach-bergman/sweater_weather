class BookService
  def conn
    Faraday.new(url: "https://openlibrary.org/")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def book_search(location, quantity)
    get_url("search.json?q=place:#{location}&limit=#{quantity}")
  end
end