class ChangeRatings < ActiveRecord::Migration[5.0]
  def change
    change_table :ratings do |t|
      t.string :explanation
    end
  end
end
