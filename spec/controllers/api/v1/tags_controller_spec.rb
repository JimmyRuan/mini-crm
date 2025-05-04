require 'rails_helper'

RSpec.describe Api::V1::TagsController do
  let(:valid_attributes) { { name: 'Test Tag' } }
  let(:invalid_attributes) { { name: '' } }
  let(:tag) { create(:tag) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all tags' do
      create(:tag)
      create(:tag)
      get :index
      expect(response.parsed_body.size).to eq(2)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: tag.id }
      expect(response).to be_successful
    end

    it 'returns the requested tag' do
      get :show, params: { id: tag.id }
      expect(response.parsed_body['id']).to eq(tag.id)
    end

    it 'returns 404 when tag not found' do
      get :show, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Tag' do
        expect do
          post :create, params: { tag: valid_attributes }
        end.to change(Tag, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: { tag: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Tag' do
        expect do
          post :create, params: { tag: invalid_attributes }
        end.not_to change(Tag, :count)
      end

      it 'returns an unprocessable_entity response' do
        post :create, params: { tag: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Updated Tag' } }

      it 'updates the requested tag' do
        put :update, params: { id: tag.id, tag: new_attributes }
        tag.reload
        expect(tag.name).to eq('Updated Tag')
      end

      it 'returns a success response' do
        put :update, params: { id: tag.id, tag: valid_attributes }
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        put :update, params: { id: tag.id, tag: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it 'returns 404 when tag not found' do
      put :update, params: { id: 0, tag: valid_attributes }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested tag' do
      tag_to_delete = create(:tag)
      expect do
        delete :destroy, params: { id: tag_to_delete.id }
      end.to change(Tag, :count).by(-1)
    end

    it 'returns a no_content response' do
      delete :destroy, params: { id: tag.id }
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 when tag not found' do
      delete :destroy, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
    end
  end
end
