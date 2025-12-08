class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 30, index: { unique: true }
      t.text :description, null: true # text型にはlimitが効かないためmodel側でバリデーション
      t.timestamps
    end
  end
end
