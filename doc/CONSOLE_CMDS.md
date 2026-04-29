# Rails Console Commands Reference

## Database & Schema Inspection

| Command | Description |
|---------|-------------|
| `ActiveRecord::Base.connection.tables` | List all table names in the database |
| `ActiveRecord::Base.connection.columns(:locations).map { \|c\| [c.name, c.sql_type] }` | Get all columns and their SQL types for a specific table |
| `Model.attribute_names` | Get all attribute names for a model |
| `Model.column_names` | Get all column names for a model |
| `Model.columns_hash` | Get a hash of all columns with metadata |

## Display & Visualization

| Command | Description |
|---------|-------------|
| `Hirb.enable` | Enable table-formatted output for console queries |
| `Hirb::Helpers::AutoTable.render(Location.all)` | Render Active Record results as a formatted table |

## Basic Query Methods

| Command | Description |
|---------|-------------|
| `Model.all` | Fetch all records from a table |
| `Model.first` | Get the first record |
| `Model.last` | Get the last record |
| `Model.find(id)` | Find a record by primary key (raises error if not found) |
| `Model.find_by(attribute: value)` | Find first record matching condition (returns nil if not found) |
| `Model.exists?(id)` | Check if a record with given ID exists (returns true/false) |
| `Model.none` | Return an empty relation (useful for conditionals) |
| `Location.columns.map { \|c\| "#{c.name}: #{c.sql_type}" }` | Display columns and types for a model in formatted output |

## Filtering & Querying

| Command | Description |
|---------|-------------|
| `Model.where(attribute: value)` | Find records matching a condition |
| `Model.where("created_at > ?", 1.week.ago)` | Query with raw SQL conditions and parameters |
| `Model.where(id: [1, 2, 3])` | Find records with IDs in an array |
| `Model.where.not(attribute: value)` | Find records NOT matching a condition |
| `Model.where("age > ?", 21)` | Query with comparison operators |
| `Model.where("name LIKE ?", "%Smith%")` | Query with pattern matching (LIKE) |
| `Model.where(association: { attribute: value })` | Query through associations |
| `Model.or(Model.where(active: true))` | Combine multiple where conditions with OR logic |

## Sorting & Limiting

| Command | Description |
|---------|-------------|
| `Model.order(:created_at)` | Sort records ascending by column |
| `Model.order(created_at: :desc)` | Sort records descending by column |
| `Model.reorder(created_at: :desc)` | Replace existing order with new order |
| `Model.limit(10)` | Limit results to first N records |
| `Model.offset(20)` | Skip first N records (useful for pagination) |

## Selection & Aggregation

| Command | Description |
|---------|-------------|
| `Model.select(:id, :name)` | Select specific columns (returns relation) |
| `Model.pluck(:id, :name)` | Extract specific columns as array (faster than select) |
| `Model.distinct.pluck(:category)` | Get unique values for a column |
| `Model.group(:category).count` | Group records and count by category |
| `Model.count` | Get total number of records |

## Find or Create

| Command | Description |
|---------|-------------|
| `Model.find_or_create_by(attribute: value)` | Find record or create if not exists |
| `Model.find_or_initialize_by(attribute: value)` | Find record or build unsaved instance |

## Create & Update

| Command | Description |
|---------|-------------|
| `Model.create(attribute: value)` | Create and save new record (returns record) |
| `Model.create!(attribute: value)` | Create and save, raise error if invalid |
| `Model.new(attribute: value)` | Create unsaved instance in memory |
| `record.save` | Save record to database (returns true/false) |
| `record.save!` | Save record, raise error if invalid |
| `record.update(attribute: value)` | Update and save record in one call |
| `record.update!(attribute: value)` | Update and save, raise error if invalid |
| `record.assign_attributes(attribute: value)` | Assign attributes without saving |

## Delete & Destroy

| Command | Description |
|---------|-------------|
| `record.destroy` | Delete record and run callbacks (safe delete) |
| `record.destroy!` | Destroy record, raise error if transaction fails |
| `record.delete` | Delete record without running callbacks (faster) |
| `Model.destroy_all` | Delete all records with callbacks |
| `Model.delete_all` | Delete all records without callbacks (fast) |
| `Model.update_all(published: true)` | Update all records with same values (no callbacks) |
| `Model.where(published: false).update_all(published: true)` | Update matching records in bulk |

## Atomic Updates

| Command | Description |
|---------|-------------|
| `record.toggle!(:published)` | Toggle boolean field and save |
| `record.increment!(:counter)` | Increment numeric field by 1 and save |
| `record.decrement!(:counter)` | Decrement numeric field by 1 and save |

## Batch Processing

| Command | Description |
|---------|-------------|
| `Model.find_each(batch_size: 100) { \|record\| ... }` | Process records in batches to avoid memory overload |
| `Model.find_in_batches(batch_size: 100) { \|batch\| ... }` | Process array batches (useful for bulk operations) |

## Associations & Joins

| Command | Description |
|---------|-------------|
| `Model.includes(:association)` | Eager load associations (prevents N+1 queries) |
| `Model.joins(:association)` | SQL INNER JOIN with association table |
| `Model.left_joins(:association)` | SQL LEFT OUTER JOIN with association table |
| `Model.eager_load(:association)` | Force eager load (loads in separate query) |
| `Model.preload(:association)` | Preload associations in separate query |
| `Model.references(:association)` | Include association in references (for joins/includes) |

## Advanced Queries

| Command | Description |
|---------|-------------|
| `Model.from("users, projects")` | Query from custom table names |
| `Model.select("users.id, projects.name")` | Select specific columns with custom SQL |
| `Model.pluck(:attribute)` | Extract single column as array |
| `Model.find_by_sql("SELECT * FROM ...")` | Execute raw SQL query |
| `Model.unscope(:order)` | Remove previously applied scopes (like order) |

## Validation & Inspection

| Command | Description |
|---------|-------------|
| `Model.validators` | Get all validators defined on model |
| `record.valid?` | Check if record passes validation (returns true/false) |
| `record.invalid?` | Check if record fails validation (returns true/false) |
| `record.errors.full_messages` | Get array of validation error messages |

## Record & Cache Management

| Command | Description |
|---------|-------------|
| `record.reload` | Refresh record data from database |
| `record.touch` | Update record's timestamp (useful for cache busting) |
| `Model.connection.schema_cache.clear!` | Clear schema cache (fixes column errors) |
| `Model.reset_column_information` | Reset cached column information for model |

## Transactions

| Command | Description |
|---------|-------------|
| `Model.transaction do # transactional work end` | Wrap operations in database transaction (rollback on error) |
| `Model.connection.execute("SQL HERE")` | Execute raw SQL command |

## Nested & Association Helpers

| Command | Description |
|---------|-------------|
| `article.comments` | Access associated records (has_many) |
| `article.comments.build(body: "Nice post")` | Create unsaved associated record |
| `article.comments.create(body: "Nice post")` | Create and save associated record |
| `article.comments.create!(body: "Nice post")` | Create and save, raise error if invalid |
| `article.comments.where(author: "Jane")` | Filter associated records |
| `article.comments.order(created_at: :desc)` | Sort associated records |
| `article.comments.count` | Count associated records |

## Console Utilities

| Command | Description |
|---------|-------------|
| `bin/rails console` | Start Rails console in current environment |
| `bin/rails dbconsole` | Open SQL database console (psql, mysql, etc.) |
| `reload!` | Reload code changes in console (doesn't reload gems) |
| `show-model Model` | Display model structure (requires Pry debugger) |
| `show-routes` | Display all routes (requires Pry debugger) |
| `show-source Model` | Display model source code (requires Pry debugger) |