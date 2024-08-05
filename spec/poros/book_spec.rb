require "rails_helper"

RSpec.describe Book do
  it "exists", :vcr do
    books = BookService.new.book_search("denver,co", 5)
    get_book = books[:docs].first
    book = Book.new(get_book)

    expect(book).to be_a(Book)
  end
end