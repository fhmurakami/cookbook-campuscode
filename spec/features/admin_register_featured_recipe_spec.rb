require 'rails_helper'

feature 'Admin register recipe as featured' do
  scenario 'successfully' do
    admin = create(:user, admin: true)
    recipe = create(:recipe)

    login_as admin
    visit root_path
    click_on recipe.title
    click_on 'featured'

    expect(current_path).to eq recipe_path(recipe)
    expect(page).to have_css('i.fas.fa-star')
  end

  scenario 'must be redirect to root path if user is not admin' do
    user = create(:user, admin: false)
    recipe = create(:recipe)

    login_as user
    visit recipe_featured_path(recipe)

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('errors.messages.permission_denied')
  end
end
