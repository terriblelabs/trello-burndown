class BoardsController < ApplicationController
  def index
  end

  def show
  end

  private

  def boards
    Trello::Board.all
  end
  helper_method :boards

  def board
    Board.new(params[:id])
  end
  helper_method :board

end
