# Rails Copper API

A mini CRM (Customer Relationship Management) API built with Ruby on Rails.

## Features

- **Contact Management**
  - Create, read, update, and delete contacts
  - Search contacts by name or tag
  - Pagination support for contact listings
  - JSON serialization with Active Model Serializers

- **Tag Management**
  - Create and manage tags
  - Associate tags with contacts
  - Pagination support for tag listings

- **API Documentation**
  - Swagger/OpenAPI documentation
  - Interactive API documentation UI

- **Error Handling**
  - Custom JSON error handler middleware
  - Standardized error responses

- **Testing**
  - Comprehensive RSpec test suite
  - Factory Bot for test data
  - Request specs for API endpoints
  - Model specs with validations
  - Serializer specs

## System Dependencies

- Ruby (version specified in .ruby-version)
- PostgreSQL
- Docker and Docker Compose (for containerized development)

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up the database:
   ```bash
   rails db:create db:migrate
   ```
4. Run the test suite:
   ```bash
   rspec
   ```

## Development

The application is containerized using Docker. The project includes a Makefile with various commands to simplify development tasks:

### Docker Commands
```bash
make up              # Start services in foreground
make up-detached     # Start services in background
make down           # Stop services
make rebuild        # Rebuild all services
make web            # Access web service
make db             # Access database service
make logs           # View all service logs
make nuke           # Stop all services and remove containers, networks, and volumes
```

### Development Commands
```bash
make test           # Run all tests
make test-coverage  # Run tests with coverage report
make test-focus     # Run specific test (TEST=path/to/test)
make lint           # Run Rubocop linting
make lint-fix       # Run Rubocop with auto-fix
make db-migrate     # Run database migrations
make db-rollback    # Rollback last migration
make db-reset       # Reset database (drop, create, migrate, seed)
make db-seed        # Run database seeds
make console        # Start Rails console
make routes         # List all routes
make clean          # Clean temporary files and logs
make swagger-docs   # Generate Swagger documentation
```

## API Documentation

Access the Swagger UI at `/api-docs` when running the application in development mode.

## Testing

Run the test suite:
```bash
make test
```

For test coverage:
```bash
make test-coverage
```

## Code Quality

- Rubocop for Ruby code linting
- Standardized code style
- Automated linting checks
- Run linting with `make lint` or `make lint-fix`

## Database Schema

- Contacts: Store contact information
- Tags: Manage contact tags
- ContactTags: Join table for contact-tag associations


