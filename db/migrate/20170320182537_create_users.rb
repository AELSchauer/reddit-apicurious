class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :token
      t.string :provider

      t.timestamps null: false
    end
  end
end
