class CreateRecipeSets < ActiveRecord::Migration[5.2]
  def change
    create_table :recipe_sets do |t|
      t.references :recipe, foreign_key: true
      t.references :recipe_list, foreign_key: true

      t.timestamps
    end
  end
end
