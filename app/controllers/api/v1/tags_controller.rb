module Api
  module V1
    class TagsController < ApplicationController
      before_action :set_tag, only: %i[show update destroy]

      # @swagger
      # @path /api/v1/tags
      # @method GET
      # @summary List all tags
      # @description Returns a paginated list of tags
      # @tags Tags
      # @parameter page [integer] Page number
      # @parameter per_page [integer] Number of items per page
      # @response 200 [object] Success response with tags
      # @response 401 [object] Unauthorized
      def index
        @tags = Tag.paginate(page: params[:page], per_page: params[:per_page] || 10)
        render json: {
          tags: ActiveModel::Serializer::CollectionSerializer.new(@tags, serializer: TagSerializer),
          total_pages: @tags.total_pages,
          current_page: @tags.current_page,
          total_entries: @tags.total_entries
        }
      end

      # @swagger
      # @path /api/v1/contacts/search
      # @method GET
      # @summary Search contacts by tag
      # @description Returns contacts associated with a specific tag
      # @tags Tags
      # @parameter tag [string] Tag name to search by
      # @parameter page [integer] Page number
      # @parameter per_page [integer] Number of items per page
      # @response 200 [object] Success response with contacts
      # @response 400 [object] Tag parameter missing
      # @response 401 [object] Unauthorized
      def search
        if params[:tag].blank?
          render json: { error: 'Tag parameter is required' }, status: :bad_request
          return
        end

        tag = Tag.find_by(name: params[:tag])
        if tag.nil?
          @contacts = Contact.none
        else
          @contacts = tag.contacts.paginate(page: params[:page], per_page: params[:per_page] || 10)
        end

        render json: {
          contacts: ActiveModel::Serializer::CollectionSerializer.new(@contacts, serializer: ContactSerializer),
          total_pages: @contacts.total_pages,
          current_page: @contacts.current_page,
          total_entries: @contacts.total_entries
        }
      end

      # @swagger
      # @path /api/v1/tags/{id}
      # @method GET
      # @summary Get a tag
      # @description Returns a single tag by ID
      # @tags Tags
      # @parameter id [integer] Tag ID
      # @response 200 [object] Success response with tag
      # @response 404 [object] Tag not found
      # @response 401 [object] Unauthorized
      def show
        render json: @tag, serializer: TagSerializer
      end

      # @swagger
      # @path /api/v1/tags
      # @method POST
      # @summary Create a tag
      # @description Creates a new tag
      # @tags Tags
      # @parameter tag [object] Tag object
      # @property tag.name [string] Tag name
      # @response 201 [object] Success response with created tag
      # @response 422 [object] Invalid tag data
      # @response 401 [object] Unauthorized
      def create
        @tag = Tag.new(tag_params)

        if @tag.save
          render json: @tag, serializer: TagSerializer, status: :created
        else
          render json: @tag.errors, status: :unprocessable_entity
        end
      end

      # @swagger
      # @path /api/v1/tags/{id}
      # @method PUT
      # @summary Update a tag
      # @description Updates an existing tag
      # @tags Tags
      # @parameter id [integer] Tag ID
      # @parameter tag [object] Tag object
      # @property tag.name [string] Tag name
      # @response 200 [object] Success response with updated tag
      # @response 404 [object] Tag not found
      # @response 422 [object] Invalid tag data
      # @response 401 [object] Unauthorized
      def update
        if @tag.update(tag_params)
          render json: @tag, serializer: TagSerializer
        else
          render json: @tag.errors, status: :unprocessable_entity
        end
      end

      # @swagger
      # @path /api/v1/tags/{id}
      # @method DELETE
      # @summary Delete a tag
      # @description Deletes a tag by ID
      # @tags Tags
      # @parameter id [integer] Tag ID
      # @response 204 [object] Tag deleted
      # @response 404 [object] Tag not found
      # @response 401 [object] Unauthorized
      def destroy
        @tag.destroy
        head :no_content
      end

      private

      def set_tag
        @tag = Tag.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Tag not found' }, status: :not_found
      end

      def tag_params
        params.require(:tag).permit(:name)
      end
    end
  end
end
