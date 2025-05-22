# frozen_string_literal: true

class Product < ApplicationRecord # rubocop:disable Style/Documentation
  validates :gtin, presence: true, uniqueness: true
  validates :name, presence: true

  def self.from_param(param)
    by_gtin(param)&.first
  end

  def to_param
    gtin
  end

  scope :full_text_search, lambda { |terms|
    where(
      [
        FULL_TEXT_SEARCH_SQL,
        { terms: map_search_terms(terms) }
      ]
    )
  }

  scope :by_gtin, lambda { |gtin|
    where(gtin: padded_gtins(gtin))
  }

  FULL_TEXT_SEARCH_SQL = <<~SQL.squish
    to_tsvector('english', products.linked_data) @@ to_tsquery('english', :terms)
    OR to_tsvector('english', products.name) @@ to_tsquery('english', :terms)
    OR to_tsvector('english', products.brand_name) @@ to_tsquery('english', :terms)
  SQL

  private_constant :FULL_TEXT_SEARCH_SQL

  class << self
    def map_search_terms(terms)
      Array
        .wrap(terms)
        .map { |term| "#{sanitize_term(term)}:*" }
        .join(' & ')
    end

    def padded_gtins(gtin)
      return [gtin] if gtin.length == 14 && gtin[0] != '0'

      gtin_14 = gtin.rjust(14, '0') # rubocop:disable Naming/VariableNumber
      gtin_13 = gtin_14.slice(1, 13) # rubocop:disable Naming/VariableNumber

      [gtin_14, gtin_13, gtin]
    end

    def sanitize_term(term)
      term.gsub(/([^a-zA-Z0-9 -])/, '\\\\\\1')
    end
  end
end
