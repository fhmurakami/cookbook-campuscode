user = User.create(name: 'Teste', email: 'teste@email.com', password: '123456', city: 'São Paulo', admin: false)
admin = User.create(name: 'Admin', email: 'admin@email.com', password: '123456', city: 'São Paulo', admin: true)
RecipeType.create(name: 'Sobremesa')
RecipeType.create(name: 'Entrada')
Cuisine.create(name: 'Portuguesa')
brazilian_cuisine = Cuisine.create(name: 'Brasileira')
italian_cuisine = Cuisine.create(name: 'Italiana')
recipe_type = RecipeType.create(name: 'Prato Principal')
Recipe.create(title: 'Feijoada', recipe_type: recipe_type,
              cuisine: brazilian_cuisine,
              difficulty: 'Médio', cook_time: 120,
              ingredients: 'Feijão e carnes.',
              cook_method: 'Misturar o feijão com as carnes.',
              featured: true, user: user)

Recipe.create(title: 'Macarronada', recipe_type: recipe_type,
              cuisine: italian_cuisine,
              difficulty: 'Fácil', cook_time: 30,
              ingredients: 'Macarrão e molho de tomate',
              cook_method: 'Cozinhar o macarrão e misturar com o molho.',
              featured: false, user: user)
