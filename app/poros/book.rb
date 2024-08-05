class Book
  def initialize(data)
    @isbn = (data[:isbn])
    @title = data[:title]
    @publisher = data[:publisher]
  end
end