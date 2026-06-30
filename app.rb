require 'sinatra'
require 'json'

set :port, 8080
set :bind, '0.0.0.0'

# In-memory book storage
books = {}

# POST /books - Add a new book
post '/books' do
  content_type :json

  begin
    body = JSON.parse(request.body.read)
  rescue JSON::ParserError
    status 400
    return { error: 'Invalid JSON' }.to_json
  end

  title = body['title']
  author = body['author']
  isbn = body['isbn']

  if title.nil? || author.nil? || isbn.nil?
    status 400
    return { error: 'Missing required fields: title, author, isbn' }.to_json
  end

  if books.key?(isbn)
    status 409
    return { error: 'Book with this ISBN already exists' }.to_json
  end

  book = { title: title, author: author, isbn: isbn }
  books[isbn] = book

  status 201
  book.to_json
end

# GET /books/:isbn - Retrieve a book by ISBN
get '/books/:isbn' do
  content_type :json

  isbn = params['isbn']
  book = books[isbn]

  if book.nil?
    status 404
    return { error: 'Book not found' }.to_json
  end

  book.to_json
end

# GET /books - List all books
get '/books' do
  content_type :json
  books.values.to_json
end
