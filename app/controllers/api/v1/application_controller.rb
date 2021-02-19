class Api::V1::ApplicationController < ActionController::Base
  protect_from_forgery
  include Authenticable
  respond_to :json
end
