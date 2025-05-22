# frozen_string_literal: true

# Remove full-text indices on JSONB fields in the products table.
class RemoveFullTextIndicesOnProductsJsonbFields < ActiveRecord::Migration[8.0]
  COLUMNS = %w[properties linked_data].freeze

  def up
    COLUMNS.each do |column|
      execute "drop index products_#{column}_full_text_index"
    end
  end

  def down
    COLUMNS.each do |column|
      execute(
        <<~SQL.squish
          CREATE INDEX products_#{column}_full_text_index ON products
          USING gin (( to_tsvector('english', #{column}) ));
        SQL
      )
    end
  end
end
