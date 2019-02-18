class ApplicationController < ActionController::Base
  def cookies
    cookies[:score] = { value: 3, expires: 1.hour.from_now }
  end
end
