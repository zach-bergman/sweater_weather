class Api::V1::BookSearchController < ApplicationController
  def index
    books_from_search = BookFacade.new.book_search(params[:location], params[:quantity])
    render json: BookSerializer.new(books_from_search)
  end
end