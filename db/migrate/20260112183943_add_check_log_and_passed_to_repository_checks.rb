class AddCheckLogAndPassedToRepositoryChecks < ActiveRecord::Migration[8.1]
  def change
    add_column :repository_checks, :check_log, :string
    add_column :repository_checks, :passed, :boolean
  end
end
