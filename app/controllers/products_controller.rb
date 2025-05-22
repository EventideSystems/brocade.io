# frozen_string_literal: true

# Controller for products
class ProductsController < ApplicationController
  include ProductSearch

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @pagy, @products = product_search(params)

    respond_to do |format|
      format.html
      format.json do
        render json: @products.map(&:linked_data)
      end
    end
  end

  def show # rubocop:disable Metrics/MethodLength
    if @product.nil?
      respond_to do |format|
        format.html { redirect_to products_path, alert: 'Product not found' } # rubocop:disable Rails/I18nLocaleTexts
        format.json { render json: { error: 'Product not found' }, status: :not_found }
      end
    else
      respond_to do |format|
        format.html
        format.json do
          render json: @product
        end
      end
    end
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.' # rubocop:disable Rails/I18nLocaleTexts
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.' # rubocop:disable Rails/I18nLocaleTexts
    else
      render :edit
    end
  end

  def destroy
    raise 'Not implemented'
  end

  private

  # SMELL: Not used?
  def flatten_product_attributes(product)
    product
      .attributes
      .slice(*%w[gtin name brand_name])
      .merge(product.properties)
      .compact
  end

  # SMELL: Not used?
  def set_product
    @product = Product.from_param(params[:id])
  end

  def product_params # rubocop:disable Metrics/MethodLength
    params
      .expect(
        product: [:gtin,
                  :name,
                  :brand_name,
                  { properties: {} }]
      ).tap do |permitted_params|
        permitted_params[:properties].each_key do |key|
          permitted_params[:properties].delete(key) if permitted_params[:properties][key].blank?
        end
      end
  end
end
