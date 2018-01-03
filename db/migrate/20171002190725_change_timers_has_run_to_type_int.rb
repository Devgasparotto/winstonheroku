class ChangeTimersHasRunToTypeInt < ActiveRecord::Migration[5.0]
  def up
    change_column :timers, :HasRun, 'integer USING CAST(column_name AS integer)'
  end

  def down
    change_column :timers, :HasRun, :boolean
  end
end
