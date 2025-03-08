# frozen_string_literal: true

# Similar to the AddFullTextIndicesOnProducts migration that adds a full text index on the properties and
# other columns, this migration adds a full text index on the linked_data column.
#
# This is necessary because the linked_data column is a JSONB column, and we want to be able to perform full text
# searches on it.
class AddFullTextIndicesOnProductsLinkedData < ActiveRecord::Migration[8.0]
  COLUMNS = %w[linked_data].freeze

  def up
    COLUMNS.each do |column|
      execute(
        <<~SQL.squish
          CREATE INDEX products_#{column}_full_text_index ON products
          USING gin (( to_tsvector('english', #{column}) ));
        SQL
      )
    end
  end

  def down
    COLUMNS.each do |column|
      execute "drop index products_#{column}_full_text_index"
    end
  end
end
