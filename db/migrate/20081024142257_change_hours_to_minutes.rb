class ChangeHoursToMinutes < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute %(
      UPDATE tickets SET estimated = estimated * 60, actual = actual * 60
    )
    ActiveRecord::Base.connection.execute %(
      UPDATE scheduled_days SET hours = hours * 60
    )
    change_column :tickets, :estimated, :integer
    change_column :tickets, :actual, :integer
    rename_column :scheduled_days, :hours, :minutes
  end

  def self.down
    change_column :tickets, :estimated, :float
    change_column :tickets, :actual, :float
    rename_column :scheduled_days, :minutes, :hours
    
    ActiveRecord::Base.connection.execute %(
      UPDATE tickets SET estimated = estimated / 60, actual = actual / 60
    )
    ActiveRecord::Base.connection.execute %(
      UPDATE scheduled_days SET hours = hours / 60
    )
  end
end
