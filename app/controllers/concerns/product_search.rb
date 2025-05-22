# frozen_string_literal: true

module ProductSearch # rubocop:disable Style/Documentation
  extend ActiveSupport::Concern

  included do
    include Rails::Pagination
  end

  def product_search(params)
    if params[:query].present?
      pagy, records = pagy(build_query(params[:query]))
    elsif params[:name].present? || params[:brand].present?
      pagy, records = pagy(build_param_query(params))
    else
      pagy, records = pagy(Product.all)
    end

    [pagy, records]
  end

  private

  def build_query(query_params)
    base_query = Product.full_text_search(query_params.split)

    return base_query unless gtin?(query_params)

    base_query.or(Product.by_gtin(query_params))
  end

  def build_param_query(params)
    base_query = Product.all
    base_query = base_query.where('name ILIKE :name', name: "%#{params[:name]}%") if params[:name].present?
    base_query = base_query.where('brand_name ILIKE :brand', brand: "%#{params[:brand]}%") if params[:brand].present?

    base_query
  end

  def gtin?(string)
    string !~ /\D/
  end
end
