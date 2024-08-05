require "rails_helper"

RSpec.describe Book do
  it "exists", :vcr do
    service = BookService.new
    facade = BookFacade.new
    books = facade.book_search("denver,co", 5)
    
    expect(books).to be_an(Array)
    books.each do |book|
      expect(book).to be_a(Book)
    end
  end

  # describe "get_books" do
  #   it "returns an array of books", :vcr do

  #   end
  # end
end