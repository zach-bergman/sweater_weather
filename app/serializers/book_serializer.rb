class BookSerializer
  include JSONAPI::Serializer

  set_id { "null" }

  set_type :books

  # attributes :destination, :forecast, :total_books_found, :books

  attribute :destination do |object|
    object[:destination]
  end

  attribute :forecast do |object|
    {
      summary: object[:forecast].current_weather[:condition],
      temperature: "#{object[:forecast].current_weather[:temperature]} F"
    }
  end

  attribute :total_books_found do |object|
    object[:total_books_found]
  end

  attribute :books do |object|
    object[:books].map do |book|
      {
        isbn: book[:isbn],
        title: book[:title],
        publisher: book[:publisher]
      }
    end
  end
end