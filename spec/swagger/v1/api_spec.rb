require 'swagger_helper'

RSpec.describe 'API V1', type: :request do
  path '/api/v1/contacts' do
    parameter name: 'page', in: :query, type: :integer, description: 'Page number', required: false
    parameter name: 'per_page', in: :query, type: :integer, description: 'Number of items per page', required: false

    before do
      create_list(:contact, 3)
    end

    get 'List contacts' do
      tags 'Contacts'
      produces 'application/json'

      response '200', 'contacts found' do
        schema type: :object,
          properties: {
            contacts: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  email: { type: :string },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time }
                }
              }
            },
            total_pages: { type: :integer },
            current_page: { type: :integer },
            total_entries: { type: :integer }
          }

        run_test!
      end
    end

    post 'Create a contact' do
      tags 'Contacts'
      consumes 'application/json'
      parameter name: :contact, in: :body, schema: {
        type: :object,
        properties: {
          contact: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string }
            },
            required: %w[name email]
          }
        }
      }

      response '201', 'contact created' do
        let(:contact) { { contact: { name: 'John Doe', email: 'john@example.com' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:contact) { { contact: { name: '' } } }
        run_test!
      end
    end
  end

  path '/api/v1/contacts/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    before do
      @contact = create(:contact)
    end

    get 'Show a contact' do
      tags 'Contacts'
      produces 'application/json'

      response '200', 'contact found' do
        let(:id) { @contact.id }
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            email: { type: :string },
            created_at: { type: :string, format: :date_time },
            updated_at: { type: :string, format: :date_time }
          }

        run_test!
      end

      response '404', 'contact not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Update a contact' do
      tags 'Contacts'
      consumes 'application/json'
      parameter name: :contact, in: :body, schema: {
        type: :object,
        properties: {
          contact: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string }
            }
          }
        }
      }

      response '200', 'contact updated' do
        let(:id) { @contact.id }
        let(:contact) { { contact: { name: 'Updated Name' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { @contact.id }
        let(:contact) { { contact: { email: 'invalid' } } }
        run_test!
      end
    end

    delete 'Delete a contact' do
      tags 'Contacts'

      response '204', 'contact deleted' do
        let(:id) { @contact.id }
        run_test!
      end

      response '404', 'contact not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/contacts/search' do
    parameter name: 'tag_name', in: :query, type: :string, description: 'Tag name to search by', required: true
    parameter name: 'page', in: :query, type: :integer, description: 'Page number', required: false
    parameter name: 'per_page', in: :query, type: :integer, description: 'Number of items per page', required: false

    before do
      @tag = create(:tag, name: 'searchable')
      @contact = create(:contact)
      @contact.tags << @tag
    end

    get 'Search contacts by tag' do
      tags 'Contacts'
      produces 'application/json'

      response '200', 'contacts found' do
        let(:tag_name) { @tag.name }
        let(:params) { { tag_name: tag_name } }
        schema type: :object,
          properties: {
            contacts: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  email: { type: :string },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time }
                }
              }
            },
            total_pages: { type: :integer },
            current_page: { type: :integer },
            total_entries: { type: :integer }
          }

        run_test!
      end

      response '400', 'tag parameter missing' do
        let(:tag_name) { '' }
        let(:params) { { tag_name: tag_name } }
        run_test!
      end
    end
  end

  path '/api/v1/tags' do
    parameter name: 'page', in: :query, type: :integer, description: 'Page number', required: false
    parameter name: 'per_page', in: :query, type: :integer, description: 'Number of items per page', required: false

    before do
      create_list(:tag, 3)
    end

    get 'List tags' do
      tags 'Tags'
      produces 'application/json'

      response '200', 'tags found' do
        schema type: :object,
          properties: {
            tags: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time }
                }
              }
            },
            total_pages: { type: :integer },
            current_page: { type: :integer },
            total_entries: { type: :integer }
          }

        run_test!
      end
    end

    post 'Create a tag' do
      tags 'Tags'
      consumes 'application/json'
      parameter name: :tag, in: :body, schema: {
        type: :object,
        properties: {
          tag: {
            type: :object,
            properties: {
              name: { type: :string }
            },
            required: %w[name]
          }
        }
      }

      response '201', 'tag created' do
        let(:tag) { { tag: { name: 'Important' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:tag) { { tag: { name: '' } } }
        run_test!
      end
    end
  end

  path '/api/v1/tags/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    before do
      @tag = create(:tag)
    end

    get 'Show a tag' do
      tags 'Tags'
      produces 'application/json'

      response '200', 'tag found' do
        let(:id) { @tag.id }
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            created_at: { type: :string, format: :date_time },
            updated_at: { type: :string, format: :date_time }
          }

        run_test!
      end

      response '404', 'tag not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Update a tag' do
      tags 'Tags'
      consumes 'application/json'
      parameter name: :tag, in: :body, schema: {
        type: :object,
        properties: {
          tag: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          }
        }
      }

      response '200', 'tag updated' do
        let(:id) { @tag.id }
        let(:tag) { { tag: { name: 'Updated Tag' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { @tag.id }
        let(:tag) { { tag: { name: '' } } }
        run_test!
      end
    end

    delete 'Delete a tag' do
      tags 'Tags'

      response '204', 'tag deleted' do
        let(:id) { @tag.id }
        run_test!
      end

      response '404', 'tag not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end 