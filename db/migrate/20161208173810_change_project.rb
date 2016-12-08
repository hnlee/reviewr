class ChangeProject < ActiveRecord::Migration[5.0]
  def change
    change_table :projects do |t|
      t.string :link
    end
  end
end
