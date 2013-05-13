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
    Board.where(trello_board_id: params[:id]).first_or_create
  end
  helper_method :board

end
