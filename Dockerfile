FROM ruby:2.7

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app

EXPOSE 4567

CMD ["ruby", "app.rb"]
