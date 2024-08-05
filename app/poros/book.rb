class Book
  attr_reader :total_books_found, :books

  def initialize(data)
    @total_books_found = data[:numFound]
    @books = get_books(data)
  end

  def get_books(data)
    data[:docs].map do |book_data|
      {
        isbn: book_data[:isbn],
        title: book_data[:title],
        publisher: book_data[:publisher]
      }
    end
  end
end