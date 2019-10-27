class CreateDataPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :data_points do |t|
      t.float :point, null: false

      t.timestamps
    end
  end
end
