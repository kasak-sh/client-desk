class AddSlugToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :slug, :string

    # Generate slugs for existing accounts using raw SQL (avoids model loading issues)
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE accounts
          SET slug = LOWER(REPLACE(REPLACE(name, ' ', '-'), '''', ''))
          WHERE slug IS NULL
        SQL
      end
    end

    change_column_null :accounts, :slug, false
    add_index :accounts, :slug, unique: true
  end
end
