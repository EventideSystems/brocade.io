# frozen_string_literal: true

# Application helper
module ApplicationHelper
  include Pagy::Frontend

  DESKTOP_LINK_TO_CLASS = 'font-medium text-gray-500 dark:text-white hover:text-gray-900 dark:hover:text-gray-400'
  MOBILE_LINK_TO_CLASS = 'block rounded-md px-3 py-2 text-base font-medium text-gray-700 dark:text-white hover:bg-gray-50 hover:text-gray-900 dark:hover:text-gray-400' # rubocop:disable Layout/LineLength

  def desktop_link_to(*, **options)
    options[:class] = DESKTOP_LINK_TO_CLASS
    link_to(*, **options)
  end

  def mobile_link_to(*, **options)
    options[:class] = MOBILE_LINK_TO_CLASS
    link_to(*, **options)
  end

  def google_analytics_id
    Rails.configuration.google_analytics_id
  end
end
