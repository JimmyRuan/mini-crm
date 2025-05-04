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
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all contacts' do
      create_list(:contact, 3)
      get :index
      expect(response.parsed_body.size).to eq(3)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: contact.id }
      expect(response).to be_successful
    end

    it 'returns the requested contact' do
      get :show, params: { id: contact.id }
      parsed_response = response.parsed_body
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

      it 'returns a created status' do
        post :create, params: { contact: valid_attributes }
        expect(response).to have_http_status(:created)
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

      it 'returns a success response' do
        put :update, params: { id: contact.id, contact: valid_attributes }
        expect(response).to be_successful
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
end
