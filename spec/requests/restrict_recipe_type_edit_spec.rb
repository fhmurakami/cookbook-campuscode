require 'rails_helper'

RSpec.describe 'Restrict recipe_type edit and delete to admin' do
  it 'should allow edit to admin only' do
    user = create(:user, admin: false)
    recipe_type = create(:recipe_type)

    login_as user
    patch recipe_type_path(recipe_type),
          params: { recipe_type: { name: 'Entrada' } }

    expect(recipe_type.name).to_not eq 'Entrada'
  end

  it 'should allow delete recipe type to admin only' do
    user = create(:user, admin: false)
    recipe_type = create(:recipe_type)

    login_as user
    delete recipe_type_path(recipe_type)

    expect(RecipeType.any?).to be true
    expect(RecipeType.last).to eq recipe_type
  end

  it 'should redirect to root path if a not admin user try to edit' do
    user = create(:user, admin: false)
    recipe_type = create(:recipe_type)

    login_as user
    patch recipe_type_path(recipe_type),
          params: { recipe_type: { name: 'Entrada' } }

    expect(recipe_type.name).to_not eq 'Entrada'
    expect(response).to redirect_to root_path
    expect(request.flash[:alert]).to include I18n.t('errors.messages.'\
      'permission_denied')
  end

  it 'should redirect to root path if a not admin user try to delete' do
    user = create(:user, admin: false)
    recipe_type = create(:recipe_type)

    login_as user
    delete recipe_type_path(recipe_type)

    expect(RecipeType.any?).to be true
    expect(RecipeType.last).to eq recipe_type
    expect(response).to redirect_to root_path
    expect(request.flash[:alert]).to include I18n.t('errors.messages.'\
      'permission_denied')
  end
end
