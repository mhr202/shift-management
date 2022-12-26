class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.string :shift_type, null: false
      t.date :day, null: false
      t.references :worker, foreign_key: true, index: true

      t.index %i[day worker_id], unique: true

      t.timestamps
    end
  end
end
