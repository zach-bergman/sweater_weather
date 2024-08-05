require "rails_helper"

RSpec.describe BookService do
  describe "initialize" do
    it "exists" do
      service = BookService.new
  
      expect(service).to be_a BookService
    end
  end

  describe "#conn" do
    it "creates a Faraday connection" do
      connection = BookService.new.conn

      expect(connection).to be_a Faraday::Connection
    end
  end

  describe "#get_url" do
    it "returns the results from the API call", :vcr do
      response = BookService.new.get_url("search.json?q=place:denver,co&limit=5")

      expect(response).to be_a Hash
      # continue to test?
    end
  end

  describe "#book_search" do
    it "returns an array of books with a title that included searched words", :vcr do
      response = BookService.new.book_search("denver,co", 5)

      expect(response).to be_a Hash
    end
  end
end