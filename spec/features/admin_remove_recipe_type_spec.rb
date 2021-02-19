require 'rails_helper'

feature 'Admin removes recipe type' do
  scenario 'successfully' do
    admin = create(:user, admin: true)
    recipe_type = create(:recipe_type)

    login_as admin
    visit root_path
    click_on recipe_type.name
    click_on 'delete'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Tipo de receita excluído com sucesso'
  end
end
