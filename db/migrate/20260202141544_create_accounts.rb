class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :status, null: false, default: 'active'

      t.timestamps
    end
  end
end
