require 'rails_helper'

RSpec.describe 'Recipe Type API' do
  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Context-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end
  describe 'GET /api/v1/recipe_types' do
    it 'return all recipe_types successfully' do
      dessert = create(:recipe_type, name: 'Sobremesa')
      salad = create(:recipe_type, name: 'Salada')

      get '/api/v1/recipe_types'

      expect(response).to have_http_status :ok
      body_parse = JSON.parse(response.body)

      expect(body_parse[0]['name']).to eq dessert.name
      expect(body_parse[1]['name']).to eq salad.name
    end

    it 'fails if there is no recipe_types' do
      get '/api/v1/recipe_types/'

      expect(response).to have_http_status :not_found
      expect(response.body).to include I18n.t('errors.messages.'\
        'recipe_type_not_found')
    end
  end
end
