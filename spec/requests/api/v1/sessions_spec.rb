require 'rails_helper'

RSpec.describe 'Sessions API' do
  let(:user) { create(:user) }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'POST /api/v1/sessions' do
    before do
      post '/api/v1/sessions', params: { session: credentials }.to_json,
                               headers: headers
    end

    context 'when the credentials are correct' do
      let(:credentials) { { email: user.email, password: '123456' } }

      it 'returns status code 200 (ok)' do
        expect(response).to have_http_status :ok
      end

      it 'returns the json data for the user with auth token' do
        user.reload
        expect(json_body[:auth_token]).to eq user.auth_token
      end
    end

    context 'when the credentials are incorrect' do
      let(:credentials) { { email: user.email, password: 'invalid password' } }

      it 'returns status code 401 (unauthorized)' do
        expect(response).to have_http_status :unauthorized
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key :errors
      end
    end
  end

  describe 'DELETE /api/v1/sessions/:id' do
    let(:auth_token) { user.auth_token }

    before do
      delete "/api/v1/sessions/#{auth_token}", params: {}, headers: headers
    end

    it 'returns status code 204 (no_content)' do
      expect(response).to have_http_status(:no_content)
    end

    it 'changes the user auth token' do
      expect(User.find_by(auth_token: auth_token)).to be_nil
    end
  end
end
