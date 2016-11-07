class CreateProjectInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :project_invites do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
