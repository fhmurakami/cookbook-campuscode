FactoryBot.define do
  factory :recipe do
    title { 'Bolo de cenoura' }
    difficulty { 'Médio' }
    cook_time { 60 }
    ingredients { 'Farinha, açúcar, cenoura' }
    cook_method do
      'Cozinhe a cenoura, corte em pedaços pequenos, '\
      'misture com o restante dos ingredientes'
    end
    recipe_type
    cuisine
    user
  end
end
