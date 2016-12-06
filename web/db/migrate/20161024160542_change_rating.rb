class ChangeRating < ActiveRecord::Migration[5.0]
  def change
    change_table :ratings do |t|
      t.remove :kind, :specific, :actionable
      t.boolean :helpful
    end
  end
end
