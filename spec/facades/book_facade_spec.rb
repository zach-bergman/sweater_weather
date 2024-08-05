require "rails_helper"

RSpec.describe BookFacade do
  describe "initialize" do
    it "exists" do
      facade = BookFacade.new

      expect(facade).to be_a(BookFacade)
    end
  end

  describe "#book_search" do
    it "returns a Book object", :vcr do
      facade = BookFacade.new
      books = facade.book_search("denver,co", 5)

      books.each do |book|
        expect(book).to be_a(Book)
      end
    end
  end
end