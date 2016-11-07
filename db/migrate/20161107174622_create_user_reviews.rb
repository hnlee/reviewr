class CreateUserReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :user_reviews do |t|
      t.references :user, foreign_key: true
      t.references :review, foreign_key: true

      t.timestamps
    end
  end
end
