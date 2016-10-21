class CreateReviewRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :review_ratings do |t|
      t.references :review, foreign_key: true
      t.references :rating, foreign_key: true

      t.timestamps
    end
  end
end
