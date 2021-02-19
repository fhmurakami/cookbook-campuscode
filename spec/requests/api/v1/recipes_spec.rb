require 'rails_helper'

RSpec.describe 'Recipe API' do
  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Context-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end
  describe 'GET /api/v1/recipes/all' do
    it 'return all recipes successfully' do
      raspberry_pie = create(:recipe, title: 'Torta de framboesa')
      blackberry_jelly = create(:recipe, title: 'Geléia de amora')

      get '/api/v1/recipes/all'

      expect(response).to have_http_status :ok
      body_parse = JSON.parse(response.body)

      expect(body_parse[0]['title']).to eq raspberry_pie.title
      expect(body_parse[1]['title']).to eq blackberry_jelly.title
    end

    it 'fails if there is no recipes' do
      get '/api/v1/recipes/all'

      expect(response).to have_http_status :not_found
      expect(response.body).to include I18n.t('errors.messages.'\
        'recipe_not_found')
    end
  end

  describe 'GET /api/v1/recipes/:id' do
    it 'return just one recipe' do
      blackberry_jelly = create(:recipe, title: 'Geléia de amora')

      get "/api/v1/recipes/#{blackberry_jelly.id}"

      expect(response).to have_http_status :ok
      body_parse = JSON.parse(response.body)

      expect(body_parse['title']).to eq blackberry_jelly.title
    end

    it 'fails if recipe do no exits' do
      get '/api/v1/recipes/100'

      expect(response).to have_http_status :not_found
      expect(response.body).to include I18n.t('errors.messages.'\
        'recipe_not_found')
    end
  end

  describe 'POST /api/v1/recipes' do
    before do
      post '/api/v1/recipes', params: { recipe: recipe_params },
                              headers: headers
    end
    context 'when the request params are valid' do
      let(:recipe_type) { create(:recipe_type) }
      let(:cuisine) { create(:cuisine) }
      let(:recipe_params) do
        attributes_for(:recipe, cuisine_id: cuisine.id,
                                recipe_type_id: recipe_type.id)
      end

      it 'returns created status code 201 (created)' do
        expect(response).to have_http_status :created
      end

      it 'saves the recipe in the database' do
        expect(Recipe.find_by(title: recipe_params[:title])).not_to be_nil
      end

      it 'returns json data for the created recipe' do
        expect(json_body[:title]).to eq recipe_params[:title]
      end

      it 'assigns the created recipe to the current user' do
        expect(json_body[:user_id]).to eq user.id
      end
    end

    context 'when the request params are invalid' do
      let(:recipe_params) do
        attributes_for(:recipe, title: '',
                                cuisine_id: nil,
                                recipe_type_id: nil)
      end

      it 'returns status code 422 (unprocessable_entity)' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'does not saves the recipe in the database' do
        expect(Recipe.find_by(title: recipe_params[:title])).to be_nil
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key :errors
      end
    end
  end

  describe 'PUT /api/v1/recipes/:id' do
    let(:recipe) { create(:recipe, user: user) }

    before do
      put "/api/v1/recipes/#{recipe.id}", params: { recipe: recipe_params },
                                          headers: headers
    end

    context 'when the params are valid' do
      let(:recipe_params) { { title: 'Nova receita' } }

      it 'returns status code 200 (ok)' do
        expect(response).to have_http_status :ok
      end

      it 'returns json data for the updated recipe' do
        expect(json_body[:title]).to eq recipe_params[:title]
      end

      it 'updates the recipe in the database' do
        expect(Recipe.find_by(title: recipe_params[:title])).to_not be_nil
      end
    end

    context 'when the params are invalid' do
      let(:recipe_params) { { title: '' } }

      it 'returns status code 422 (unprocessable_entity)' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'does not update the recipe in the database' do
        expect(Recipe.find_by(title: recipe_params[:title])).to be_nil
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key :errors
      end
    end
  end

  describe 'DELETE /api/v1/recipes/:id' do
    let(:recipe) { create(:recipe, user: user) }

    before do
      delete "/api/v1/recipes/#{recipe.id}", params: {}, headers: headers
    end

    it 'returns status code 204 (no_content)' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the recipe from database' do
      # expect(Recipe.find_by(id: recipe.id)).to be_nil
      expect { Recipe.find(recipe.id) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
