require 'swagger_helper'

RSpec.describe 'Api::V1::Tags', type: :request do
  path '/api/v1/tags' do
    get 'List tags' do
      tags 'Tags'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

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

    get 'Show a tag' do
      tags 'Tags'
      produces 'application/json'

      response '200', 'tag found' do
        let(:id) { create(:tag).id }
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
        let(:id) { create(:tag).id }
        let(:tag) { { tag: { name: 'Updated Tag' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:tag).id }
        let(:tag) { { tag: { name: '' } } }
        run_test!
      end
    end

    delete 'Delete a tag' do
      tags 'Tags'

      response '204', 'tag deleted' do
        let(:id) { create(:tag).id }
        run_test!
      end

      response '404', 'tag not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end 