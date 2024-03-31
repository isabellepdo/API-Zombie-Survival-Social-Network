class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :points_for_barter

      t.timestamps
    end
  end
end
