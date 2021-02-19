require 'rails_helper'

RSpec.describe 'Cuisine API' do
  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Context-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end
  describe 'GET /api/v1/cuisines' do
    it 'return all cuisines successfully' do
      brazilian = create(:cuisine, name: 'Brasileira')
      italian = create(:cuisine, name: 'Italiana')

      get '/api/v1/cuisines'

      expect(response).to have_http_status :ok
      body_parse = JSON.parse(response.body)

      expect(body_parse[0]['name']).to eq brazilian.name
      expect(body_parse[1]['name']).to eq italian.name
    end

    it 'fails if there is no cuisines' do
      get '/api/v1/cuisines/'

      expect(response).to have_http_status :not_found
      expect(response.body).to include I18n.t('errors.messages.'\
        'cuisine_not_found')
    end
  end
end
