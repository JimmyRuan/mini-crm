require 'swagger_helper'

RSpec.describe 'Api::V1::Contacts', type: :request do
  # Setup test data
  let!(:contacts) { create_list(:contact, 10) }
  let!(:tag) { create(:tag, name: 'VIP') }
  
  before do
    # Associate some contacts with the tag
    contacts.first(5).each do |contact|
      contact.tags << tag
    end
  end

  path '/api/v1/contacts' do
    get 'List contacts' do
      tags 'Contacts'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

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

    get 'Show a contact' do
      tags 'Contacts'
      produces 'application/json'

      response '200', 'contact found' do
        let(:id) { contacts.first.id }
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
        let(:id) { contacts.first.id }
        let(:contact) { { contact: { name: 'Updated Name' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { contacts.first.id }
        let(:contact) { { contact: { email: 'invalid' } } }
        run_test!
      end
    end

    delete 'Delete a contact' do
      tags 'Contacts'

      response '204', 'contact deleted' do
        let(:id) { contacts.first.id }
        run_test!
      end

      response '404', 'contact not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/contacts/search' do
    get 'Search contacts by tag' do
      tags 'Contacts'
      produces 'application/json'
      parameter name: :tag_name, in: :query, type: :string, required: true
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      response '200', 'contacts found' do
        let(:tag_name) { tag.name }
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
        run_test!
      end
    end
  end
end 