module Api
  module V1
    class TagsController < ApplicationController
      before_action :set_tag, only: %i[show update destroy]

      def index
        @tags = Tag.paginate(page: params[:page], per_page: params[:per_page] || 10)
        render json: {
          tags: ActiveModel::Serializer::CollectionSerializer.new(@tags, serializer: TagSerializer),
          total_pages: @tags.total_pages,
          current_page: @tags.current_page,
          total_entries: @tags.total_entries
        }
      end

      def show
        render json: @tag, serializer: TagSerializer
      end

      def create
        @tag = Tag.new(tag_params)

        if @tag.save
          render json: @tag, serializer: TagSerializer, status: :created
        else
          render json: @tag.errors, status: :unprocessable_entity
        end
      end

      def update
        if @tag.update(tag_params)
          render json: @tag, serializer: TagSerializer
        else
          render json: @tag.errors, status: :unprocessable_entity
        end
      end

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
