# frozen_string_literal: true

# Rrecreate the full-text search indices on the products table for the properties and linked_data columns,
# explictly casting the JSONB columns to text.
class RecreateFullTextIndicesOnProductsJsonbFields < ActiveRecord::Migration[8.0]
  COLUMNS = %w[properties linked_data].freeze

  def up
    COLUMNS.each do |column|
      execute(
        <<~SQL.squish
          CREATE INDEX products_#{column}_full_text_index ON products
          USING gin (( to_tsvector('english', #{column}::text) ));
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
