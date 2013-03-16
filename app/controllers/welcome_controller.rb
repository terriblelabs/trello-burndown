class WelcomeController < ApplicationController
  def index
    redirect_to controller: :boards, action: :index
  end
end
