class CreateRepositoryChecks < ActiveRecord::Migration[8.1]
  def change
    create_table :repository_checks do |t|
      t.string :commit_id
      t.string :state
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
