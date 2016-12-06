class CreateProjectReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :project_reviews do |t|
      t.references :project, foreign_key: true
      t.references :review, foreign_key: true

      t.timestamps
    end
  end
end
