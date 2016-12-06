class ChangeReviews < ActiveRecord::Migration[5.0]
  def change
    remove_reference :reviews, :project
  end
end
