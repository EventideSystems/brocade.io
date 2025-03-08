# frozen_string_literal: true

# Add linked data to products, as a replacement for the properties column
class AddLinkedDataToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :linked_data, :jsonb, default: {}
    add_index :products, :linked_data, using: :gin
  end
end
