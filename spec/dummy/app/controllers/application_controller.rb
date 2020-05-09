class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper Starburst::AnnouncementsHelper
  helper_method :current_user

  def current_user
    @_current_user ||= User.find(params[:user_id]) if params[:user_id].present?
  end
end
