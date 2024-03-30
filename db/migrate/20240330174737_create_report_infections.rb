class CreateReportInfections < ActiveRecord::Migration[5.2]
  def change
    create_table :report_infections do |t|
      t.integer :user_id
      t.integer :whistleblower_id

      t.timestamps
    end
  end
end
