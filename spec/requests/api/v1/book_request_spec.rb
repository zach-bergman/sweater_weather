require "rails_helper"

RSpec.describe "OpenLibrary API" do
  describe "GET /api/v1/book-search?location=denver,co&quantity=5" do
    it "responds with the serialized Book json for a given location", :vcr do
      get "/api/v1/book-search?location=denver,co&quantity=5"

      expect(response).to be_successful
      
      response_with_books = JSON.parse(response.body, symbolize_names: true)
      binding.pry

      expect(response_with_books).to be_a(Hash)

      expect(response_with_books).to have_key(:data)  
      expect(response_with_books[:data]).to be_a(Hash)

      expect(response_with_books[:data]).to have_key(:id)
      expect(response_with_books[:data][:id]).to eq("null")
      expect(response_with_books[:data]).to have_key(:type)
      expect(response_with_books[:data][:type]).to eq("books")
      expect(response_with_books[:data]).to have_key(:attributes)
      expect(response_with_books[:data][:attributes]).to be_a(Hash)
      expect(response_with_books[:data][:attributes]).to have_key(:destination)
      expect(response_with_books[:data][:attributes][:destination]).to eq("denver,co")
      expect(response_with_books[:data][:attributes]).to have_key(:forecast)
      expect(response_with_books[:data][:attributes][:forecast]).to be_a(Hash)
      expect(response_with_books[:data][:attributes][:forecast]).to have_key(:summary)
      expect(response_with_books[:data][:attributes][:forecast][:summary]).to be_a(String)
      expect(response_with_books[:data][:attributes][:forecast]).to have_key(:temperature)
      expect(response_with_books[:data][:attributes][:forecast][:temperature]).to be_a(String)
      expect(response_with_books[:data][:attributes]).to have_key(:total_books_found)
      expect(response_with_books[:data][:attributes][:total_books_found]).to be_a(Integer)
      expect(response_with_books[:data][:attributes]).to have_key(:books) 
      expect(response_with_books[:data][:attributes][:books]).to be_an(Array)

      response_with_books[:data][:attributes][:books].each do |book|
        expect(book).to be_a(Hash)
        expect(book).to have_key(:isbn)
        # expect(book[:isbn]).to be_an(Array)
        expect(book).to have_key(:title)
        expect(book[:title]).to be_a(String)
        expect(book).to have_key(:publisher)
        expect(book[:publisher]).to be_an(Array)
      end

      expect(response_with_books[:data][:attributes][:books].count).to eq(4)
    end
  end
end
