# frozen_string_literal: true

HEROKU_PRODUCTION_DEPLOY = <<~BASH
  git push heroku-production main && \
  heroku run rake db:migrate -a brocade-io && \
  heroku run rake data:migrate -a brocade-io && \
  heroku restart -a brocade-io
BASH

namespace :deploy do
  def print_warning
    printf <<~TEXT
      \033[31m
      WARNING! You are about to deploy to the brocade-io PRODUCTION environment.
      \033[0m
    TEXT
  end

  def print_confirmation
    print "Are you ready to release? Type 'yes' to continue: "
  end

  def confirmed?
    $stdin.gets.strip.casecmp('YES').zero?
  end

  desc 'deploy to production environment on Heroku'
  task production: :environment do
    print_warning
    print_confirmation
    if confirmed?
      sh(HEROKU_PRODUCTION_DEPLOY)
    else
      puts 'Cancelling release.'
    end
  end
end
