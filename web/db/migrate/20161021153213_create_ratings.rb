class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.boolean :kind
      t.boolean :specific
      t.boolean :actionable

      t.timestamps
    end
  end
end
