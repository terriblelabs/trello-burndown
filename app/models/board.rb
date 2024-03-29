class Board < ActiveRecord::Base

  validates_uniqueness_of :trello_board_id
  has_many :board_snapshots

  DEFAULT_REMAINING_LIST_NAME = "To Do"

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
    match = card.name.match(/\[(\d+(\.\d+)?)\]/)
    return 0 unless match
    match[1].to_f
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

  def remaining_list_name
    attributes['remaining_list_name'] || DEFAULT_REMAINING_LIST_NAME
  end

  def remaining_work
    work_by_list[remaining_list_name]
  end

  def projected_completion_series
    results = []
    work_remaining = remaining_work || 0
    date = Date.current

    while work_remaining > 0
      unless date.saturday? || date.sunday?
        work_remaining -= (1 * development_factor)
        results << {
          date: date.stamp("2013/01/13"),
          work: work_remaining.to_f
        }
      end
      date += 1.day
    end
    results
  end

end
