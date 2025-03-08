# frozen_string_literal: true

# Convert remaining product properties to JSON-LD format
class ConvertProductPropertiesToJsonld < ActiveRecord::Migration[8.0]
  def up # rubocop:disable Metrics/MethodLength
    execute <<~SQL.squish
      update products
      set linked_data = jsonb_strip_nulls(
        jsonb_build_object(
            '@context', jsonb_build_object(
              'gs1', 'https://gs1.org/voc/'
            ),
            '@type', 'gs1:Product',
            'gs1:productName', name,
            'gs1:gtin', gtin,
            'gs1:brand',
              case when brand_name is not null and brand_name <> '' then
                jsonb_build_object(
                  '@type', 'gs1:Organization',
                  'gs1:name', brand_name
                )
              else
                null
              end,
            'gs1:netContent',
            case
            when properties->>'volume_ml' is not null and properties->>'volume_ml' <> '' then
              jsonb_build_object(
                'gs1:value', properties->>'volume_ml',
                'gs1:unitCode', 'MLT'
              )
            else
              case#{' '}
              when properties->>'volume_fluid_ounce' is not null and properties->>'volume_fluid_ounce' <> '' then
                jsonb_build_object(
                  'gs1:value', (properties->>'volume_fluid_ounce')::numeric,
                  'gs1:unitCode', 'OZA'
                )
              else
                case properties->>'unit_count'
                when null then
                  null
                else
                  jsonb_build_object(
                    'gs1:value', (properties->>'unit_count')::numeric,
                    'gs1:unitCode', 'C62'
                  )
                end
              end
            end,
            'sizeDimensionDescription',
            case
            when
              (properties->>'volume_ml' is null or properties->>'volume_ml' = '') and
              (properties->>'volume_fluid_ounce' is null or properties->>'volume_fluid_ounce' = '') and
              (properties->>'weight_g' is null or properties->>'weight_g' = '') and
              (properties->>'weight_ounce' is null or properties->>'weight_ounce' = '')
            then
              nullif(properties->>'size', '')
            else
              null
            end,
            'gs1:netWeight',
            case when properties->>'weight_g' is not null and properties->>'weight_g' <> '' then
              jsonb_build_object(
                'gs1:value', properties->>'weight_g',
                'gs1:unitCode', 'GRM'
              )
            else
              case when properties->>'weight_ounce' is not null and properties->>'weight_ounce' <> '' then
                jsonb_build_object(
                  'gs1:value', (properties->>'weight_ounce')::numeric,
                  'gs1:unitCode', 'ONZ'
                )
              else
                null
              end
            end
        )
      )
      where linked_data = '{}'
    SQL
  end

  def down
    execute <<~SQL.squish
      update products
      set linked_data = '{}'
      where linked_data->>'@type' = 'gs1:Product'
    SQL
  end
end
