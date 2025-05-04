# Dockerfile
# Use the official lightweight Ruby image.
# https://hub.docker.com/_/ruby
FROM ruby:3.2.1

# Set environment variables
ENV RAILS_ENV=development
ENV BUNDLE_PATH=/gems

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set an application directory
WORKDIR /app

# Copy the Gemfile and install the gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY . .

# Precompile assets for production
RUN bundle exec rails assets:precompile

# Expose the Rails server port
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
