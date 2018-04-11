class AddStateToTasks < ActiveRecord::Migration[5.0]
  def change
    add_reference :tasks, :state, foreign_key: true
  end
end
