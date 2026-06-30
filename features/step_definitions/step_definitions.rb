require 'httparty'
require 'json'
require 'rspec/expectations'

BOOK_LIBRARY_URL = ENV['BOOK_LIBRARY_URL'] || 'http://localhost:8765'

Given('a book {string} by {string} with ISBN {string}') do |title, author, isbn|
  @books ||= []
  @books << { title: title, author: author, isbn: isbn }
  @book = { title: title, author: author, isbn: isbn }
end

When('I store the book in the library') do
  @response = HTTParty.post(
    "#{BOOK_LIBRARY_URL}/books",
    body: @book.to_json,
    headers: { 'Content-Type' => 'application/json' }
  )
end

Then('I can retrieve the book by ISBN {string}') do |isbn|
  response = HTTParty.get("#{BOOK_LIBRARY_URL}/books/#{isbn}")
  expect(response.code).to eq(200)
  expect(response.parsed_response['isbn']).to eq(isbn)
end

Given('the book is stored in the library') do
  HTTParty.post(
    "#{BOOK_LIBRARY_URL}/books",
    body: @book.to_json,
    headers: { 'Content-Type' => 'application/json' }
  )
end

When('I request the book with ISBN {string}') do |isbn|
  @response = HTTParty.get("#{BOOK_LIBRARY_URL}/books/#{isbn}")
end

Then('I receive the book with title {string} and author {string}') do |title, author|
  expect(@response.code).to eq(200)
  expect(@response.parsed_response['title']).to eq(title)
  expect(@response.parsed_response['author']).to eq(author)
end

Given('the books are stored in the library') do
  @books.each do |book|
    HTTParty.post(
      "#{BOOK_LIBRARY_URL}/books",
      body: book.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end

When('I request all books') do
  @response = HTTParty.get("#{BOOK_LIBRARY_URL}/books")
end

Then('I receive a list with {int} books') do |count|
  expect(@response.code).to eq(200)
  expect(@response.parsed_response.length).to eq(count)
end

Then('I receive a {int} error') do |status_code|
  expect(@response.code).to eq(status_code)
end
