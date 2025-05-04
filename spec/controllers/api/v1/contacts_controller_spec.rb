require 'rails_helper'

RSpec.describe Api::V1::ContactsController do
  let(:valid_attributes) do
    {
      name: 'John Doe',
      email: 'john@example.com'
    }
  end

  let(:invalid_attributes) do
    {
      name: nil,
      email: 'invalid-email'
    }
  end

  let(:contact) { create(:contact) }

  describe 'GET #index' do
    before do
      create_list(:contact, 10)
    end

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns paginated contacts with correct serializer format' do
      get :index
      parsed_response = response.parsed_body
      expect(parsed_response['contacts'].first.keys).to match_array(%w[id name email created_at updated_at tags])
      expect(parsed_response['total_pages']).to eq(1)
      expect(parsed_response['current_page']).to eq(1)
      expect(parsed_response['total_entries']).to eq(10)
    end

    it 'respects per_page parameter' do
      get :index, params: { per_page: 5 }
      expect(response.parsed_body['contacts'].size).to eq(5)
      expect(response.parsed_body['total_pages']).to eq(2)
    end

    it 'respects page parameter' do
      get :index, params: { page: 2 }
      expect(response.parsed_body['current_page']).to eq(2)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: contact.id }
      expect(response).to be_successful
    end

    it 'returns the requested contact with correct serializer format' do
      get :show, params: { id: contact.id }
      parsed_response = response.parsed_body
      expect(parsed_response.keys).to match_array(%w[id name email created_at updated_at tags])
      expect(parsed_response['id']).to eq(contact.id)
    end

    it 'returns not found for non-existent contact' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Contact' do
        expect do
          post :create, params: { contact: valid_attributes }
        end.to change(Contact, :count).by(1)
      end

      it 'returns a created status with correct serializer format' do
        post :create, params: { contact: valid_attributes }
        expect(response).to have_http_status(:created)
        parsed_response = response.parsed_body
        expect(parsed_response.keys).to match_array(%w[id name email created_at updated_at tags])
      end
    end

    context 'with invalid params' do
      it 'does not create a new Contact' do
        expect do
          post :create, params: { contact: invalid_attributes }
        end.not_to change(Contact, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: { contact: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Jane Doe',
          email: 'jane@example.com'
        }
      end

      it 'updates the requested contact' do
        put :update, params: { id: contact.id, contact: new_attributes }
        contact.reload
        expect(contact.name).to eq('Jane Doe')
        expect(contact.email).to eq('jane@example.com')
      end

      it 'returns a success response with correct serializer format' do
        put :update, params: { id: contact.id, contact: valid_attributes }
        expect(response).to be_successful
        parsed_response = response.parsed_body
        expect(parsed_response.keys).to match_array(%w[id name email created_at updated_at tags])
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity status' do
        put :update, params: { id: contact.id, contact: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested contact' do
      contact_to_delete = create(:contact)
      expect do
        delete :destroy, params: { id: contact_to_delete.id }
      end.to change(Contact, :count).by(-1)
    end

    it 'returns no content status' do
      delete :destroy, params: { id: contact.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET #search' do
    let!(:tag) { create(:tag, name: 'important') }
    let!(:contacts) { create_list(:contact, 10) }
    
    before do
      contacts.each { |contact| contact.tags << tag }
    end

    it 'returns paginated contacts with the specified tag and correct serializer format' do
      get :search, params: { tag_name: 'important' }
      parsed_response = response.parsed_body
      expect(parsed_response['contacts'].first.keys).to match_array(%w[id name email created_at updated_at tags])
      expect(parsed_response['total_pages']).to eq(1)
      expect(parsed_response['current_page']).to eq(1)
      expect(parsed_response['total_entries']).to eq(10)
    end

    it 'respects per_page parameter in search' do
      get :search, params: { tag_name: 'important', per_page: 5 }
      expect(response.parsed_body['contacts'].size).to eq(5)
      expect(response.parsed_body['total_pages']).to eq(2)
    end

    it 'respects page parameter in search' do
      get :search, params: { tag_name: 'important', page: 2 }
      expect(response.parsed_body['current_page']).to eq(2)
    end

    it 'returns bad request when tag parameter is missing' do
      get :search
      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body['error']).to eq('Tag parameter is required')
    end
  end
end
