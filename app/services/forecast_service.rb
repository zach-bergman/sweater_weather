class ForecastService
  def conn
    Faraday.new(url: "http://api.weatherapi.com/") do |faraday|
      faraday.params["key"] = Rails.application.credentials.forecast[:key]
    end
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_forecast(coordinates)
    get_url("v1/forecast.json?q=#{coordinates}&days=5")
  end
end