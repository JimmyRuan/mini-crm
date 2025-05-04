require 'rails_helper'

RSpec.describe RailsCopperApi::JsonErrorHandler do
  let(:app) { double('app') }
  let(:env) { {} }
  let(:middleware) { described_class.new(app) }

  describe '#call' do
    context 'when request is successful' do
      it 'passes through the response' do
        response = [200, {}, ['success']]
        allow(app).to receive(:call).with(env).and_return(response)

        result = middleware.call(env)

        expect(result).to eq(response)
      end
    end

    context 'when an error occurs' do
      let(:error_response) { JSON.parse(middleware.call(env)[2].first) }

      context 'in development environment' do
        before do
          allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
        end

        it 'handles ActiveRecord::RecordNotFound' do
          error = ActiveRecord::RecordNotFound.new('Record not found')
          allow(app).to receive(:call).with(env).and_raise(error)

          result = middleware.call(env)

          expect(result[0]).to eq(404)
          expect(result[1]['Content-Type']).to eq('application/json')
          expect(error_response['error']).to eq('ActiveRecord::RecordNotFound')
          expect(error_response['message']).to eq('Record not found')
          expect(error_response['backtrace']).to be_present
        end

        it 'handles ActionController::ParameterMissing' do
          error = ActionController::ParameterMissing.new('param')
          allow(app).to receive(:call).with(env).and_raise(error)

          result = middleware.call(env)

          expect(result[0]).to eq(400)
          expect(error_response['error']).to eq('ActionController::ParameterMissing')
          expect(error_response['message']).to eq('param is missing or the value is empty: param')
        end

        it 'handles ActionController::InvalidAuthenticityToken' do
          error = ActionController::InvalidAuthenticityToken.new
          allow(app).to receive(:call).with(env).and_raise(error)

          result = middleware.call(env)

          expect(result[0]).to eq(422)
          expect(error_response['error']).to eq('ActionController::InvalidAuthenticityToken')
        end

        it 'handles generic errors' do
          error = StandardError.new('Something went wrong')
          allow(app).to receive(:call).with(env).and_raise(error)

          result = middleware.call(env)

          expect(result[0]).to eq(500)
          expect(error_response['error']).to eq('StandardError')
          expect(error_response['message']).to eq('Something went wrong')
        end
      end

      context 'in production environment' do
        before do
          allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
        end

        it 'handles ActiveRecord::RecordNotFound' do
          error = ActiveRecord::RecordNotFound.new('Record not found')
          allow(app).to receive(:call).with(env).and_raise(error)

          result = middleware.call(env)

          expect(result[0]).to eq(404)
          expect(error_response['error']).to eq('ActiveRecord::RecordNotFound')
          expect(error_response['message']).to eq('Record not found')
          expect(error_response).not_to have_key('backtrace')
        end

        it 'handles generic errors with sanitized response' do
          error = StandardError.new('Something went wrong')
          allow(app).to receive(:call).with(env).and_raise(error)

          result = middleware.call(env)

          expect(result[0]).to eq(500)
          expect(error_response['error']).to eq('Internal Server Error')
          expect(error_response['message']).to eq('Something went wrong. Please try again later.')
          expect(error_response).not_to have_key('backtrace')
        end
      end
    end
  end
end 