module Api
  module V1
    class ContactsController < ApplicationController
      before_action :set_contact, only: %i[show update destroy]

      # @swagger
      # @path /api/v1/contacts
      # @method GET
      # @summary List all contacts
      # @description Returns a paginated list of contacts
      # @tags Contacts
      # @parameter page [integer] Page number
      # @parameter per_page [integer] Number of items per page
      # @response 200 [object] Success response with contacts
      # @response 401 [object] Unauthorized
      def index
        @contacts = Contact.paginate(page: params[:page], per_page: params[:per_page] || 10)
        render_paginated_response(@contacts)
      end

      # @swagger
      # @path /api/v1/contacts/search
      # @method GET
      # @summary Search contacts by tag
      # @description Returns contacts that match the given tag
      # @tags Contacts
      # @parameter tag_name [string] Tag name to search by
      # @parameter page [integer] Page number
      # @parameter per_page [integer] Number of items per page
      # @response 200 [object] Success response with contacts
      # @response 400 [object] Tag parameter is required
      # @response 401 [object] Unauthorized
      def search
        tag_name = params[:tag_name]
        if tag_name.present?
          normalized_tag = tag_name.strip.downcase
          @contacts = Contact.with_tag(normalized_tag).paginate(page: params[:page], per_page: params[:per_page] || 10)
          render_paginated_response(@contacts)
        else
          render json: { error: 'Tag parameter is required' }, status: :bad_request
        end
      end

      # @swagger
      # @path /api/v1/contacts/{id}
      # @method GET
      # @summary Get a contact
      # @description Returns a single contact by ID
      # @tags Contacts
      # @parameter id [integer] Contact ID
      # @response 200 [object] Success response with contact
      # @response 404 [object] Contact not found
      # @response 401 [object] Unauthorized
      def show
        render json: @contact, serializer: ContactSerializer
      end

      # @swagger
      # @path /api/v1/contacts
      # @method POST
      # @summary Create a contact
      # @description Creates a new contact
      # @tags Contacts
      # @parameter contact [object] Contact object
      # @property contact.name [string] Contact name
      # @property contact.email [string] Contact email
      # @response 201 [object] Success response with created contact
      # @response 422 [object] Invalid contact data
      # @response 401 [object] Unauthorized
      def create
        @contact = Contact.new(contact_params)

        if @contact.save
          render json: @contact, serializer: ContactSerializer, status: :created
        else
          render json: @contact.errors, status: :unprocessable_entity
        end
      end

      # @swagger
      # @path /api/v1/contacts/{id}
      # @method PUT
      # @summary Update a contact
      # @description Updates an existing contact
      # @tags Contacts
      # @parameter id [integer] Contact ID
      # @parameter contact [object] Contact object
      # @property contact.name [string] Contact name
      # @property contact.email [string] Contact email
      # @response 200 [object] Success response with updated contact
      # @response 404 [object] Contact not found
      # @response 422 [object] Invalid contact data
      # @response 401 [object] Unauthorized
      def update
        if @contact.update(contact_params)
          render json: @contact, serializer: ContactSerializer
        else
          render json: @contact.errors, status: :unprocessable_entity
        end
      end

      # @swagger
      # @path /api/v1/contacts/{id}
      # @method DELETE
      # @summary Delete a contact
      # @description Deletes a contact by ID
      # @tags Contacts
      # @parameter id [integer] Contact ID
      # @response 204 [object] Contact deleted
      # @response 404 [object] Contact not found
      # @response 401 [object] Unauthorized
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

      def render_paginated_response(records)
        render json: {
          contacts: ActiveModel::Serializer::CollectionSerializer.new(records, serializer: ContactSerializer),
          total_pages: records.total_pages,
          current_page: records.current_page,
          total_entries: records.total_entries
        }
      end
    end
  end
end