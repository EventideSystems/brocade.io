# frozen_string_literal: true

# Convert products with food/bevarage/tobacco-related properties to JSON-LD
class ConvertFoodBeverageTobaccoProductPropertiesToJsonld < ActiveRecord::Migration[8.0] # rubocop:disable Metrics/ClassLength
  def up # rubocop:disable Metrics/MethodLength
    execute <<~SQL.squish
      update products
      set linked_data = jsonb_strip_nulls(
        jsonb_build_object(
            '@context', jsonb_build_object(
              'gs1', 'https://gs1.org/voc/'
            ),
            '@type', 'gs1:FoodBeverageTobaccoProduct',
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
            'gs1:energyPerNutrientBasis',#{' '}
            case when properties->>'calories' is not null and properties->>'calories' <> '' then
              jsonb_build_object(
                'gs1:value', (properties->>'calories')::numeric,
                'gs1:unitCode', 'E14'
              )
            else null end,
            'gs1:carbohydratesPerNutrientBasis',
            case when properties->>'carbohydrate' is not null and properties->>'carbohydrate' <> '' then#{'  '}
              jsonb_build_object(
                'gs1:value', (properties->>'carbohydrate')::numeric,
                'gs1:unitCode', 'GRM'
              )
            else null end,
            'gs1:cholesterolPerNutrientBasis',
            case when properties->>'cholesterol' is not null and properties->>'cholesterol' <> '' then#{'              '}
              jsonb_build_object(
                'gs1:value', (properties->>'cholesterol')::numeric,
                'gs1:unitCode', 'MGM'
              )
            else null end,
            'gs1:fatPerNutrientBasis',
            case when properties->>'fat' is not null and properties->>'fat' <> '' then#{'    '}
              jsonb_build_object(
                'gs1:value', (properties->>'fat')::numeric,
                'gs1:unitCode', 'GRM'
              )
            else null end,
            'gs1:energyFromFatPerNutrientBasis',
            case when properties->>'fat_calories' is not null and properties->>'fat_calories' <> '' then#{'    '}
              jsonb_build_object(
                'gs1:value', (properties->>'fat_calories')::numeric,
                'gs1:unitCode', 'E15'
              )
            else null end,
            'gs1:fibrePerNutrientBasis',
            case when properties->>'fiber' is not null and properties->>'fiber' <> '' then
              jsonb_build_object(
                'gs1:value', (properties->>'fiber')::numeric,
                'gs1:unitCode', 'GRM'
              )
            else null end,
            'gs1:ingredientStatement',
            nullif(properties->>'ingredients', ''),
            'gs1:monounsaturatedFatPerNutrientBasis',
            case when properties->>'monounsaturated_fat' is not null and properties->>'monounsaturated_fat' <> '' then
              jsonb_build_object(
                'gs1:value', (properties->>'monounsaturated_fat')::numeric,
                'gs1:unitCode', 'GRM'
              )
            else null end,
            'gs1:polyunsaturatedFatPerNutrientBasis',
            case when properties->>'polyunsaturated_fat' is not null and properties->>'polyunsaturated_fat' <> '' then
              jsonb_build_object(
                'gs1:value', (properties->>'polyunsaturated_fat')::numeric,
                'gs1:unitCode', 'GRM'
              )
            else null end,
            'gs1:potassiumPerNutrientBasis',
            case when properties->>'potassium' is not null and properties->>'potassium' <> '' then
              jsonb_build_object(
                'gs1:value', (properties->>'potassium')::numeric,
                'gs1:unitCode', 'MGM'
              )
            else null end,
            'gs1:proteinPerNutrientBasis',
            case when properties->>'protein' is not null and properties->>'protein' <> '' then
            jsonb_build_object(
              'gs1:value', (properties->>'protein')::numeric,
              'gs1:unitCode', 'GRM'
            )
            else null end,
            'gs1:saturatedFatPerNutrientBasis',
            case when properties->>'saturated_fat' is not null and properties->>'saturated_fat' <> '' then
              jsonb_build_object(
                'gs1:value', (properties->>'saturated_fat')::numeric,
                'gs1:unitCode', 'GRM'
              )
            else null end,
            'gs1:servingSizeDescription',
            nullif(properties->>'serving_size', ''),
            'gs1:numberOfServingsPerPackage',
            case
            when properties->>'servings_per_container' = '1,5'
            then 1.5 #{' '}
            when properties->>'servings_per_container' = 'About 5 1/2'
            then 5.5#{' '}
            when properties->>'servings_per_container' = '3 1/2'
            then 3.5#{' '}
            when properties->>'servings_per_container' ~ '^\d+(.\d+)?$'#{' '}
              or properties->>'servings_per_container' ~* '^(about|approx.|approximately)\s+\d+(.\d+)?'
              or properties->>'servings_per_container' ~* '^\d+(.\d+)?\s+(capsules|sachets|crackers)$'
            then (regexp_match(properties->>'servings_per_container', '[0-9]+.?[0-9]*'))[1]::numeric#{' '}
            when properties->>'servings_per_container' ~* '^one$'#{' '}
            then 1
            else null
            end,#{' '}
            'gs1:numberOfServingsPerPackageMeasurementPrecision',
            case
            when properties->>'servings_per_container' ~* '^(about|approx.|approximately)\s.*'
            then 'APPROXIMATELY'
            else null
            end,
            'gs1:sodiumPerNutrientBasis',
            case when properties->>'sodium' is not null and properties->>'sodium' <> '' then
              jsonb_build_object(
                'gs1:value', (properties->>'sodium')::numeric,
                'gs1:unitCode', 'MGM'
              )
            else null end,
            'gs1:sugarsPerNutrientBasis',
            case when properties->>'sugars' is not null and properties->>'sugars' <> '' then
              jsonb_build_object(
                'gs1:value', (properties->>'sugars')::numeric,
                'gs1:unitCode', 'GRM'
              )
            else null end,
            'gs1:transFatPerNutrientBasis',
            case when properties->>'trans_fat' is not null and properties->>'trans_fat' <> '' then
              jsonb_build_object(
                'gs1:value', (properties->>'trans_fat')::numeric,
                'gs1:unitCode', 'GRM'
              )
            else null end,
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
      where
      (#{'  '}
        (properties->'calories' is not null and properties->>'calories' not in ('', '0', '0.0', '0.00'))
      or (properties->'carbohydrate' is not null and properties->>'carbohydrate' not in ('', '0', '0.0', '0.00'))
      or (properties->'cholesterol' is not null and properties->>'cholesterol' not in ('', '0', '0.0', '0.00'))
      or (properties->'fat' is not null and properties->>'fat' not in ('', '0', '0.0', '0.00'))
      or (properties->'fat_calories' is not null and properties->>'fat_calories' not in ('', '0', '0.0', '0.00'))
      or (properties->'fiber' is not null and properties->>'fiber' not in ('', '0', '0.0', '0.00'))
      or (properties->'ingredients' is not null and properties->>'ingredients' <> '')
      or (properties->'monounsaturated_fat' is not null and properties->>'monounsaturated_fat' not in ('', '0', '0.0', '0.00'))
      or (properties->'polyunsaturated_fat' is not null and properties->>'polyunsaturated_fat' not in ('', '0', '0.0', '0.00'))
      or (properties->'potassium' is not null and properties->>'potassium' not in ('', '0', '0.0', '0.00'))
      or (properties->'protein' is not null and properties->>'protein' not in ('', '0', '0.0', '0.00'))
      or (properties->'saturated_fat' is not null and properties->>'saturated_fat' not in ('', '0', '0.0', '0.00'))
      or (properties->'serving_size' is not null and properties->>'serving_size' not in ('', '0', '0.0', '0.00'))
      or (properties->'servings_per_container' is not null and properties->>'servings_per_container' not in ('', '0', '0.0', '0.00'))
      or (properties->'sodium' is not null and properties->>'sodium' not in ('', '0', '0.0', '0.00'))
      or (properties->'sugars' is not null and properties->>'sugars' not in ('', '0', '0.0', '0.00'))
      or (properties->'trans_fat' is not null and properties->>'trans_fat' not in ('', '0', '0.0', '0.00'))
      ) and linked_data = '{}';
    SQL
  end

  def down
    execute <<~SQL.squish
      update products
      set linked_data = '{}'
      where linked_data->>'@type' = 'gs1:FoodBeverageTobaccoProduct'
    SQL
  end
end
