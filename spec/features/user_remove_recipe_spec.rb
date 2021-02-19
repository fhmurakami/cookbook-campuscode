require 'rails_helper'

feature 'User removes recipe' do
  scenario 'successfully' do
    user = create(:user)
    recipe = create(:recipe, user: user)

    login_as user
    visit root_path
    click_on recipe.title
    click_on 'Excluir'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Receita excluída com sucesso'
    expect(page).to_not have_css('h1', text: recipe.title)
  end
end
