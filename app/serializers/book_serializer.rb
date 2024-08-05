class BookSerializer
  include JSONAPI::Serializer

  set_id { "null" }

  set_type :books

  attributes :total_books_found, :books

  attribute :forecast do |object|
    binding.pry
    {
      summary: object[:forecast][:summary],
      temperature: object[:forecast][:temperature]
    }
  end

  # attribute :books do |object|
  #   object[:books].map do |book|
  #     {
  #       isbn: book[:isbn],
  #       title: book[:title],
  #       publisher: book[:publisher]
  #     }
  #   end
  # end
end