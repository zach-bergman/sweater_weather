require "rails_helper"

RSpec.describe Book do
  it "exists", :vcr do
    service = BookService.new
    facade = BookFacade.new
    book = facade.book_search("denver,co", 5)

    expect(book).to be_a(Book)
    expect(book.books).to be_an(Array)
  end
end