class ChangeTimersHasRunToTypeInt < ActiveRecord::Migration[5.0]
  def up
    change_column :timers, :HasRun, :int
  end

  def down
    change_column :timers, :HasRun, :boolean
  end
end
