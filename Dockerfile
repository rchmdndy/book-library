FROM ruby:3.2

WORKDIR /app

COPY Gemfile ./
RUN bundle install

COPY app.rb ./
COPY features/ ./features/

EXPOSE 8080

CMD ["ruby", "app.rb"]
