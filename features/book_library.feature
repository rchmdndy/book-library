Feature: Book Library
  As a user
  I want to store and retrieve books
  So that I can manage my book collection

  Scenario: Storing a book in the library
    Given a book "The Lord of the Rings" by "J.R.R. Tolkien" with ISBN "0395974682"
    When I store the book in the library
    Then I can retrieve the book by ISBN "0395974682"

  Scenario: Retrieving a book by ISBN
    Given a book "The Hobbit" by "J.R.R. Tolkien" with ISBN "054792822X"
    And the book is stored in the library
    When I request the book with ISBN "054792822X"
    Then I receive the book with title "The Hobbit" and author "J.R.R. Tolkien"

  Scenario: Listing all books
    Given a book "The Lord of the Rings" by "J.R.R. Tolkien" with ISBN "0395974682"
    And a book "The Hobbit" by "J.R.R. Tolkien" with ISBN "054792822X"
    And the books are stored in the library
    When I request all books
    Then I receive a list with 2 books

  Scenario: Book not found
    When I request the book with ISBN "9999999999"
    Then I receive a 404 error
