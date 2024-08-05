require "rails_helper"

RSpec.describe "OpenLibrary API" do
  describe "GET /api/v1/book-search?location=denver,co&quantity=5" do
    it "responds with the serialized Book json for a given location", :vcr do
      get "/api/v1/book-search?location=denver,co&quantity=5"

      expect(response).to be_successful
      binding.pry

      response_with_books = JSON.parse(response.body, symbolize_names: true)
    end
  end
end
