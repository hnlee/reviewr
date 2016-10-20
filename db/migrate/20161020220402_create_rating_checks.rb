class CreateRatingChecks < ActiveRecord::Migration[5.0]
  def change
    create_table :rating_checks do |t|
      t.string :category
      t.boolean :value
      t.references :rating, foreign_key: true
    end
  end
end
