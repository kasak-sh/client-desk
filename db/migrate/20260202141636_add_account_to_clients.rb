class AddAccountToClients < ActiveRecord::Migration[7.2]
  def change
    add_reference :clients, :account, null: false, foreign_key: true
  end
end
