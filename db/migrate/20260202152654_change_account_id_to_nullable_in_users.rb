class ChangeAccountIdToNullableInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :account_id, true
  end
end
