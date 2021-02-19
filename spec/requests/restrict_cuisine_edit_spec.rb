require 'rails_helper'

RSpec.describe 'Restrict cuisine edit and delete to admin' do
  it 'should allow edit to admin only' do
    user = create(:user, admin: false)
    cuisine = create(:cuisine)

    login_as user
    patch cuisine_path(cuisine),
          params: { cuisine: { name: 'Espanhola' } }

    expect(cuisine.name).to_not eq 'Espanhola'
  end

  it 'should allow delete cuisine to admin only' do
    user = create(:user, admin: false)
    cuisine = create(:cuisine)

    login_as user
    delete cuisine_path(cuisine)

    expect(Cuisine.any?).to be true
    expect(Cuisine.last).to eq cuisine
  end

  it 'should redirect to root path if a not admin user try to edit' do
    user = create(:user, admin: false)
    cuisine = create(:cuisine)

    login_as user
    patch cuisine_path(cuisine),
          params: { cuisine: { name: 'Alemã' } }

    expect(cuisine.name).to_not eq 'Alemã'
    expect(response).to redirect_to root_path
    expect(request.flash[:alert]).to include I18n.t('errors.messages.'\
      'permission_denied')
  end

  it 'should redirect to root path if a not admin user try to delete' do
    user = create(:user, admin: false)
    cuisine = create(:cuisine)

    login_as user
    delete cuisine_path(cuisine)

    expect(Cuisine.any?).to be true
    expect(Cuisine.last).to eq cuisine
    expect(response).to redirect_to root_path
    expect(request.flash[:alert]).to include I18n.t('errors.messages.'\
      'permission_denied')
  end
end
