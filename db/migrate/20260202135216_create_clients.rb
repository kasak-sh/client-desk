class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.string :company
      t.text :notes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
