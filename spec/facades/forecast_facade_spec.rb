require "rails_helper"

RSpec.describe ForecastFacade do
  describe "initialize" do
    it "exists" do
      facade = ForecastFacade.new

      expect(facade).to be_a(ForecastFacade)
    end
  end

  describe "#get_forecast" do
    it "returns a Forecast object", :vcr do
      facade = ForecastFacade.new
      forecast = facade.get_forecast("denver,co")

      expect(forecast).to be_a(Forecast)
    end
  end
end