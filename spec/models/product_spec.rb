# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '.from_param' do
    describe 'EAN-13 product' do
      subject { described_class.from_param(param) }

      let!(:product) do
        create(
          :product,
          gtin: '04012200328002',
          name: 'test product'
        )
      end

      describe 'using EAN-14 code' do # rubocop:disable RSpec/NestedGroups
        let(:param) { '04012200328002' }

        it { is_expected.to eq(product) }
      end

      describe 'using EAN-13 code' do # rubocop:disable RSpec/NestedGroups
        let(:param) { '4012200328002' }

        it { is_expected.to eq(product) }
      end
    end
  end

  describe 'full text search' do
    subject { described_class.full_text_search(terms).to_sql.tr("\n", ' ') }

    context 'multiple terms' do # rubocop:disable RSpec/ContextWording
      let(:terms) { %w[foo bar] }
      let(:expected) do
        <<~SQL.squish.tr("\n", ' ').gsub(/\s$/, '')
          SELECT "products".* FROM "products"
          WHERE
          (to_tsvector('english', products.linked_data) @@ to_tsquery('english', 'foo:* & bar:*')
          OR to_tsvector('english', products.name) @@ to_tsquery('english', 'foo:* & bar:*')
          OR to_tsvector('english', products.brand_name) @@ to_tsquery('english', 'foo:* & bar:*'))
        SQL
      end

      it { is_expected.to eq(expected) }
    end

    context 'multiple terms with ampersand' do # rubocop:disable RSpec/ContextWording
      let(:terms) { %w[foo & bar] }

      let(:expected) do
        <<~SQL.squish.tr("\n", ' ').gsub(/\s$/, '')
          SELECT "products".* FROM "products"
          WHERE
          (to_tsvector('english', products.linked_data) @@ to_tsquery('english', 'foo:* & \\&:* & bar:*')
          OR to_tsvector('english', products.name) @@ to_tsquery('english', 'foo:* & \\&:* & bar:*')
          OR to_tsvector('english', products.brand_name) @@ to_tsquery('english', 'foo:* & \\&:* & bar:*'))
        SQL
      end

      it { is_expected.to eq(expected) }
    end
  end
end
