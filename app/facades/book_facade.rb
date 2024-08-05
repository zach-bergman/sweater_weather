class BookFacade
  def initialize
    @service = BookService.new
  end

  def book_search(location, quantity)
    books = @service.book_search(location, quantity)
    
    Book.new(books)
  end
end