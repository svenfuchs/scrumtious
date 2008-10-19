if ActiveRecord::Base.connection.tables.empty?
  File.read("#{RAILS_ROOT}/db/development_structure.sql").split(';').each do |sql|
    ActiveRecord::Base.connection.execute(sql) unless sql.blank?
  end
end

class Test::Unit::TestCase
  setup do
    ActiveRecord::Base.connection.tables.each do |table_name|
      next if table_name == 'schema_migrations'
      ActiveRecord::Base.connection.execute "DELETE FROM #{table_name}"
    end
  end
end

