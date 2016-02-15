class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :room
      t.text :task

      t.timestamps null: false
    end
  end
end
