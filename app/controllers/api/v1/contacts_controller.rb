module Api
  module V1
    class ContactsController < ApplicationController
      before_action :set_contact, only: %i[show update destroy]

      def index
        @contacts = Contact.all
        render json: @contacts
      end

      def show
        render json: @contact
      end

      def create
        @contact = Contact.new(contact_params)

        if @contact.save
          render json: @contact, status: :created
        else
          render json: @contact.errors, status: :unprocessable_entity
        end
      end

      def update
        if @contact.update(contact_params)
          render json: @contact
        else
          render json: @contact.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @contact.destroy
        head :no_content
      end

      private

      def set_contact
        @contact = Contact.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Contact not found' }, status: :not_found
      end

      def contact_params
        params.require(:contact).permit(:name, :email)
      end
    end
  end
end
