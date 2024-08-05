class Api::V1::BookSearchController < ApplicationController
  def index
    books_from_search = BookFacade.new.book_search(params[:location], params[:quantity])
    forecast = ForecastFacade.new.get_forecast(params[:location])

    data = {
      destination: params[:location],
      forecast: forecast,
      total_books_found: books_from_search.total_books_found,
      books: books_from_search.books
    }

    render json: BookSerializer.new(data)
  end
end