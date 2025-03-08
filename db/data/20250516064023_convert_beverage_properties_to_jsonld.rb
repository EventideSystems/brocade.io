# frozen_string_literal: true

# Convert products with bevarage-related properties to JSON-LD
class ConvertBeveragePropertiesToJsonld < ActiveRecord::Migration[8.0] # rubocop:disable Metrics/ClassLength
  def up # rubocop:disable Metrics/MethodLength
    execute <<~SQL.squish
      update products
      set linked_data = jsonb_strip_nulls(
        jsonb_build_object(
            '@context', jsonb_build_object(
              'gs1', 'https://gs1.org/voc/'
            ),
            '@type', 'gs1:Beverage',
            'gs1:productName', name,
            'gs1:gtin', gtin,
            'gs1:brand',#{' '}
              case when brand_name is not null and brand_name <> '' then
                jsonb_build_object(
                  '@type', 'gs1:Organization',
                  'gs1:name', brand_name
                )
              else
                null
              end,
            'gs1:percentageOfAlcoholByVolume',#{' '}
            case properties->>'alcohol_by_volume'
            when '0' then#{' '}
              null
            else#{' '}
              (properties->>'alcohol_by_volume')::numeric
            end,
            'gs1:servingSize',#{' '}
            case properties->>'serving_size'
            when '1' then
              jsonb_build_object(
                'gs1:value', 1,
                'gs1:unitCode', 'C62'
              )
            when '1.1 mL' then
              jsonb_build_object(
                'gs1:value', 1.1,
                'gs1:unitCode', 'MLT'
              )
            else
              null
            end,
            'gs1:servingsPerContainer', (properties->>'servings_per_container')::numeric,
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
                case properties->>'size'
                when '700ml' then
                  jsonb_build_object(
                    'gs1:value', 700,
                    'gs1:unitCode', 'MLT'
                  )#{' '}
                when '350ml' then
                  jsonb_build_object(
                    'gs1:value', 350,
                    'gs1:unitCode', 'MLT'
                  )#{'  '}
                when '70 cl' then
                  jsonb_build_object(
                    'gs1:value', 700,
                    'gs1:unitCode', 'MLT'
                  )#{' '}
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
              end
            end
          )
        )
      where properties->'alcohol_by_volume' is not null
      and name <> 'Crunchy Chili Onion Peanuts'
    SQL
  end

  def down
    execute <<~SQL.squish
      update products
      set linked_data = '{}'
      where properties->'alcohol_by_volume' is not null
      and name <> 'Crunchy Chili Onion Peanuts'
    SQL
  end
end
