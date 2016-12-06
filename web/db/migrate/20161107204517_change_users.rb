class ChangeUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :uid
      t.remove :password
    end
  end
end
