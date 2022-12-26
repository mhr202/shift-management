class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :workers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: true
      t.string :email, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
