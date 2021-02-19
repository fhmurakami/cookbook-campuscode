require 'rails_helper'

RSpec.describe 'Users API' do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /api/v1/users/:id' do
    before do
      get "/api/v1/users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exits' do
      it 'returns the user' do
        expect(json_body[:id]).to eq user_id
      end

      it 'returns status code 200 (ok)' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when user does not exist' do
      let(:user_id) { 1000 }

      it 'returns status code 404 (not_found)' do
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'POST /api/v1/users' do
    before do
      post '/api/v1/users', params: { user: user_params }.to_json,
                            headers: headers
    end
    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns status code 201 (created)' do
        expect(response).to have_http_status :created
      end

      it 'returns json data for the created user' do
        expect(json_body[:email]).to eq user_params[:email]
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: '') }

      it 'returns status code 422 (unprocessable_entity)' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key :errors
      end
    end
  end

  describe 'PUT /api/v1/users/:id' do
    before do
      put "/api/v1/users/#{user_id}", params: { user: user_params }.to_json,
                                      headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { { email: 'new@email.com' } }

      it 'returns status code 200 (ok)' do
        expect(response).to have_http_status :ok
      end

      it 'returns the json data for the updated user' do
        expect(json_body[:email]).to eq user_params[:email]
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { { email: '' } }

      it 'returns status code 422 (unprocessable_entity)' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key :errors
      end
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    before do
      delete "/api/v1/users/#{user_id}", headers: headers
    end

    it 'returns status code 204 (no_content)' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the user from database' do
      expect(User.find_by(id: user_id)).to be_nil
    end
  end
end
