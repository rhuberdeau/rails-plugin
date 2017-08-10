class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    head :ok
  end
end
