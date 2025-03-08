# frozen_string_literal: true

# Convert products with book-related properties to JSON-LD
class ConvertBookPropertiesToJsonld < ActiveRecord::Migration[8.0]
  def up # rubocop:disable Metrics/MethodLength
    execute <<~SQL.squish
      update products
      set linked_data = jsonb_strip_nulls(
        jsonb_build_object(
          '@context', jsonb_build_object(
            'gs1', 'https://gs1.org/voc/',
            'schema', 'https://schema.org/'
          ),
          '@type', 'schema:Book',
          'gs1:productName', name,
          'gs1:gtin', gtin,
          'schema:author', properties->>'author',
          'schema:publisher', coalesce(properties->>'publisher', brand_name),
          'schema:numberOfPages', coalesce(nullif(properties->>'pages', ''), null)::Integer,
          'schema:bookFormat', case
            properties->>'format'
            when 'hardcover' then 'Hardcover'
            when 'paperback' then 'Paperback'
            when 'Paperback' then 'Paperback'
            when 'CD' then 'AudiobookFormat'
            else
              null
            end
        )
      )
      where (
        properties->'author' is not null#{' '}
        or properties->'pages' is not null#{' '}
        or properties->'publisher' is not null
        or properties->'format' is not null
      )
      and (
        properties->>'ingredients' is null or#{' '}
        properties->>'ingredients' = ''
      )
    SQL
  end

  def down # rubocop:disable Metrics/MethodLength
    execute <<~SQL.squish
      update products
      set linked_data = '{}'
      where (
        properties->'author' is not null#{' '}
        or properties->'pages' is not null#{' '}
        or properties->'publisher' is not null
        or properties->'format' is not null
      )
      and (
        properties->>'ingredients' is null or#{' '}
        properties->>'ingredients' = ''
      )
    SQL
  end
end
