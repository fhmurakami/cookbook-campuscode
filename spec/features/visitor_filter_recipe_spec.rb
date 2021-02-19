require 'rails_helper'

feature 'Visitor filters recipe' do
  scenario 'by recipe type and find the correct recipe' do
    user = create(:user)
    dessert = create(:recipe_type, name: 'Sobremesa')
    appetizer = create(:recipe_type, name: 'Aperitivo')

    cuisine = create(:cuisine)

    carrot_cake = create(:recipe, recipe_type: dessert,
                                  cuisine: cuisine,
                                  user: user)
    cheese_stick = create(:recipe, title: 'Palitos de queijo',
                                   recipe_type: appetizer,
                                   cuisine: cuisine,
                                   user: user)

    visit root_path
    click_on dessert.name

    expect(page).to have_css('h1', text: dessert.name)
    expect(page).to have_css('h1', text: carrot_cake.title)
    expect(page).to have_css('li', text: carrot_cake.recipe_type.name)

    expect(page).to_not have_css('h1', text: appetizer.name)
    expect(page).to_not have_css('h1', text: cheese_stick.title)
    expect(page).to_not have_css('li', text: cheese_stick.recipe_type.name)
  end

  scenario 'by recipe type and not find any recipe' do
    dessert = create(:recipe_type, name: 'Sobremesa')

    visit root_path
    click_on dessert.name

    expect(page).to have_css('h1', text: dessert.name)
    expect(page).to have_css('p', text: 'Não encontramos nenhuma '\
      'receita desse tipo')
  end
end
