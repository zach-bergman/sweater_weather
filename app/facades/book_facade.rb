class BookFacade
  def initialize
    @service = BookService.new
  end

  def book_search(location, quantity)
    books = @service.book_search(location, quantity)
    # binding.pry
    Book.new(books)

    # books[:docs].map do |book_data|
    #   Book.new(book_data)
    # end
  end
end