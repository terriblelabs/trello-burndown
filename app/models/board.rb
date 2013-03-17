class Board < ActiveRecord::Base

  validates_uniqueness_of :trello_board_id
  has_many :board_snapshots

  def name
    trello_board.name
  end

  def list(list_id)
    @_lists ||= {}
    @_lists[list_id] ||= Trello::List.find(list_id).name
  end

  def cards_by_list
    cards.group_by{ |c| list(c.list_id) }
  end

  def cards
    @_cards ||= trello_board.cards
  end

  def trello_board
    @_trello_board ||= Trello::Board.find trello_board_id
  end

  def work(card)
    match = card.name.match(/\[(\d+)\]/)
    return 0 unless match
    match[1].to_i
  end

  def total_work
    cards.sum {|c| work(c) }
  end

  def work_by_list
    Hash[cards_by_list.map do |list, cards|
      [list, cards.map{|c| work(c) }.sum]
    end]
  end

  def take_snapshot
    board_snapshots.where(date: Date.today).first_or_create do |snapshot|
      snapshot.lists = work_by_list
    end
  end

end