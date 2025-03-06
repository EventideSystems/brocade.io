# frozen_string_literal: true

Rails.configuration.google_analytics_id = ENV.fetch('GOOGLE_ANALYTICS_ID', nil)
