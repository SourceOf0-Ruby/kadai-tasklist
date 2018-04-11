class AddIsEffectiveToStates < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :is_effective, :boolean
  end
end
