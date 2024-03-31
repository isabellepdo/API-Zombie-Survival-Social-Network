class AddDefaultDataInTableItems < ActiveRecord::Migration[5.2]
  def up
    # Default data entered to start using the application
    Item.create(name: 'Água', points_for_barter: 4)
    Item.create(name: 'Comida', points_for_barter: 3)
    Item.create(name: 'Remédio	', points_for_barter: 2)
    Item.create(name: 'Munição', points_for_barter: 1)
  end
end
