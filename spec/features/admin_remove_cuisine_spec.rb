require 'rails_helper'

feature 'Admin removes cuisine' do
  scenario 'successfully' do
    admin = create(:user, admin: true)
    cuisine = create(:cuisine)

    login_as admin
    visit root_path
    click_on cuisine.name
    click_on 'delete'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Cozinha excluída com sucesso'
  end
end
