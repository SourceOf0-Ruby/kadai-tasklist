class RenameContentToTasks < ActiveRecord::Migration[5.0]
  def change
    rename_column :tasks, :content, :title
  end
end
