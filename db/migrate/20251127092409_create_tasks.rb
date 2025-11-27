class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title ,null:false
      t.string :description ,null:true
      t.timestamps
    end
  end
end
