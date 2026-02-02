class AddSlugToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :slug, :string

    # Generate slugs for existing accounts
    reversible do |dir|
      dir.up do
        Account.reset_column_information
        Account.find_each do |account|
          slug = account.name.parameterize
          # Ensure uniqueness
          counter = 1
          base_slug = slug
          while Account.exists?(slug: slug)
            slug = "#{base_slug}-#{counter}"
            counter += 1
          end
          account.update_column(:slug, slug)
        end
      end
    end

    change_column_null :accounts, :slug, false
    add_index :accounts, :slug, unique: true
  end
end
