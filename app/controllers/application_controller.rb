# frozen_string_literal: true

# Base controller
class ApplicationController < ActionController::Base
  include Pagy::Backend
end
