class Api::V1::BookSearchController < ApplicationController
  def index
    # cookies[:location] = params[:location]
    books_from_search = BookFacade.new.book_search(params[:location], params[:quantity])
    forecast = ForecastFacade.new.get_forecast(params[:location])


    # Prepare data for serialization
    data = {
      destination: params[:location],
      forecast: {
        summary: forecast.current_weather[:condition],
        temperature: forecast.current_weather[:temperature]
      },
      # total_books_found: books_from_search.total_books_found,
      books: books_from_search.books.map do |book|
        {
          isbn: book[:isbn],
          title: book[:title],
          publisher: book[:publisher]
        }
      end
    }

    serialized_data = BookSerializer.new(data)

    render json: BookSerializer.new(serialized_data)
  end
end