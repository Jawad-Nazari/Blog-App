class CreateIndexOnConfirmationToken < ActiveRecord::Migration[7.0]
 def change
    add_column :users, :confirmation_token, :string
    add_index :users, :confirmation_token, unique: true, name: "index_users_on_confirmation_token"
  end

end
