# typed: false
# frozen_string_literal: true

Rails.application.routes.draw do
  mount Phalanx::Engine => '/phalanx'
end
