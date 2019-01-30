class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout 'static'
  skip_before_action :require_login
end
