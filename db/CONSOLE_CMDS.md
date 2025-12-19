* ActiveRecord::Base.connection.tables
* ActiveRecord::Base.connection.columns(:locations).map { |c| [c.name, c.sql_type] }
* Location.columns.map { |c| "#{c.name}: #{c.sql_type}" }


* Hirb.enable
* Hirb::Helpers::AutoTable.render(Location.all)